<?php

namespace App\Http\Controllers;

use App\Models\Consultation;
use App\Models\Review;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class ReviewController extends Controller
{
    /** Mahasiswa memberi rating & ulasan untuk konsultan setelah sesi selesai. */
    public function store(Request $request, Consultation $consultation)
    {
        if ((int) $consultation->user_id !== (int) Auth::id()) {
            abort(403, 'Anda bukan pemilik sesi konsultasi ini.');
        }

        if (! $consultation->isAccessible()) {
            return $this->respond($request, false, 'Sesi konsultasi belum aktif.', 422);
        }

        $consultation->expireIfNeeded();

        if (! in_array($consultation->status, ['closed', 'expired'], true)) {
            return $this->respond($request, false, 'Rating hanya dapat diberikan setelah sesi konsultasi selesai.', 422);
        }

        if ($consultation->review()->exists()) {
            return $this->respond($request, false, 'Kamu sudah memberikan rating untuk sesi ini.', 422);
        }

        $data = $request->validate([
            'rating' => ['required', 'integer', 'between:1,5'],
            'ulasan' => ['nullable', 'string', 'max:1000'],
        ], [
            'rating.required' => 'Pilih rating bintang 1 sampai 5.',
            'rating.between' => 'Rating harus antara 1 sampai 5.',
            'ulasan.max' => 'Ulasan maksimal 1000 karakter.',
        ]);

        $review = DB::transaction(function () use ($consultation, $data) {
            $review = Review::create([
                'consultation_id' => $consultation->id,
                'user_id' => Auth::id(),
                'consultant_id' => $consultation->consultant_id,
                'rating' => (int) $data['rating'],
                'ulasan' => isset($data['ulasan']) ? trim($data['ulasan']) ?: null : null,
            ]);

            $consultation->consultant->refreshRating();

            return $review;
        });

        return $this->respond($request, true, 'Terima kasih! Rating dan ulasan berhasil dikirim.', 200, [
            'review' => [
                'rating' => $review->rating,
                'ulasan' => $review->ulasan,
            ],
        ]);
    }

    private function respond(Request $request, bool $ok, string $message, int $status = 200, array $extra = [])
    {
        if ($request->expectsJson()) {
            return response()->json(array_merge(['ok' => $ok, 'message' => $message], $extra), $status);
        }

        return back()->with($ok ? 'success' : 'error', $message);
    }
}
