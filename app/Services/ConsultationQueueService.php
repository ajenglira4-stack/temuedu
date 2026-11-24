<?php

namespace App\Services;

use App\Models\Consultant;
use App\Models\Consultation;
use App\Models\Message;
use Illuminate\Support\Facades\DB;

/**
 * Mengelola perpindahan konsultan setelah batas waktu tunggu (3 menit)
 * dan antrian menunggu otomatis saat konsultan selesai melayani mahasiswa sebelumnya.
 */
class ConsultationQueueService
{
    public function isConsultantBusy(Consultant $consultant): bool
    {
        Consultation::expireOverdue($consultant->id);

        return Consultation::where('consultant_id', $consultant->id)
            ->where('status', 'active')
            ->where('service', 'chat')
            ->whereNotNull('consultant_replied_at')
            ->where(fn ($q) => $q->whereNull('expires_at')->orWhere('expires_at', '>', now()))
            ->exists();
    }

    /** Daftar konsultan se-prodi yang sedang dalam jam layanan dan tidak sedang sibuk. */
    public function availableConsultantsForSwitch(Consultation $consultation, AvailabilityService $availability): array
    {
        return Consultant::with('user')
            ->where('prodi_id', $consultation->prodi_id)
            ->where('is_active', true)
            ->where('id', '!=', $consultation->consultant_id)
            ->orderByDesc('rating_avg')
            ->orderBy('id')
            ->get()
            ->filter(fn (Consultant $c) => $availability->isAvailableNow($c) && ! $this->isConsultantBusy($c))
            ->map(fn (Consultant $c) => [
                'id' => $c->id,
                'nama' => $c->user->name,
                'foto' => $c->avatar_url,
                'kompetensi' => $c->kompetensi ?: '-',
                'rating' => $c->rating_count > 0 ? $c->rating_avg . ' (' . $c->rating_count . ')' : 'Baru',
            ])
            ->values()
            ->all();
    }

    /** Pindahkan sesi menunggu ke konsultan pengganti tanpa membayar ulang. */
    public function switchToConsultant(Consultation $consultation, Consultant $target, ?string $reason = null): Consultation
    {
        return DB::transaction(function () use ($consultation, $target, $reason) {
            $old = Consultation::lockForUpdate()->findOrFail($consultation->id);

            $existing = Consultation::where('switched_from_consultation_id', $old->id)->first();
            if ($existing) {
                return $existing;
            }

            $old->update([
                'status' => 'closed',
                'waiting_queue' => false,
                'queued_at' => null,
            ]);

            Message::create([
                'consultation_id' => $old->id,
                'sender_id' => $old->user_id,
                'tipe' => 'system',
                'isi' => $reason ?? 'Sesi dialihkan ke konsultan lain (' . $target->user->name . ').',
            ]);

            $waitMinutes = (int) config('temuedu.response_wait_minutes', 3);

            $new = Consultation::create([
                'user_id' => $old->user_id,
                'consultant_id' => $target->id,
                'prodi_id' => $old->prodi_id,
                'service' => 'chat',
                'is_paid' => true,
                'topik' => $old->topik,
                'harga' => $old->harga,
                'status' => 'active',
                'response_deadline_at' => now()->addMinutes($waitMinutes),
                'switched_from_consultation_id' => $old->id,
            ]);

            Message::create([
                'consultation_id' => $new->id,
                'sender_id' => $old->user_id,
                'tipe' => 'system',
                'isi' => 'Sesi dialihkan ke ' . $target->user->name . '. Menunggu respon konsultan (maksimal ' . $waitMinutes . ' menit).',
            ]);

            // Salin pesan pertanyaan mahasiswa agar konsultan pengganti langsung melihat konteksnya.
            $studentMessages = $old->messages()
                ->where('tipe', 'text')
                ->where('sender_id', $old->user_id)
                ->orderBy('id')
                ->get();

            foreach ($studentMessages as $msg) {
                Message::create([
                    'consultation_id' => $new->id,
                    'sender_id' => $old->user_id,
                    'tipe' => 'text',
                    'isi' => $msg->isi,
                ]);
            }

            return $new;
        });
    }

    /** Saat konsultan selesai melayani sesi, otomatis ambil mahasiswa terlama di antrian prodi yang sama. */
    public function assignNextWaitingStudent(Consultant $consultant, AvailabilityService $availability): ?Consultation
    {
        if (! $consultant->is_active || ! $availability->isAvailableNow($consultant) || $this->isConsultantBusy($consultant)) {
            return null;
        }

        $waiting = Consultation::where('waiting_queue', true)
            ->where('status', 'active')
            ->where('service', 'chat')
            ->where('is_paid', true)
            ->where('prodi_id', $consultant->prodi_id)
            ->orderBy('queued_at')
            ->orderBy('id')
            ->first();

        if (! $waiting) {
            return null;
        }

        $consultant->loadMissing('user');

        return $this->switchToConsultant(
            $waiting,
            $consultant,
            'Dialihkan otomatis ke ' . $consultant->user->name . ' yang baru saja selesai melayani sesi sebelumnya.'
        );
    }
}
