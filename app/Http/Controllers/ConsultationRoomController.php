<?php

namespace App\Http\Controllers;

use App\Models\Appointment;
use App\Models\Consultant;
use App\Models\Consultation;
use App\Models\Message;
use App\Models\Payment;
use App\Services\AvailabilityService;
use App\Services\ConsultationQueueService;
use App\Support\Avatar;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Ruang chat konsultasi. Dipakai bersama oleh MAHASISWA dan KONSULTAN pemilik sesi.
 * Setiap method memeriksa kepemilikan sesi (roleIn) dan status pembayaran (isAccessible) di server.
 */
class ConsultationRoomController extends Controller
{
    public function show(Consultation $consultation, AvailabilityService $availability, ConsultationQueueService $queueService)
    {
        $role = $this->roleIn($consultation);
        $consultation->expireIfNeeded();

        // Layanan berbayar terkunci sampai pembayaran dinyatakan berhasil
        if (! $consultation->isAccessible()) {
            if ($role === 'student') {
                $pending = Payment::where('consultation_id', $consultation->id)
                    ->where('status', 'pending')->latest('id')->first();

                return $pending && $pending->isPayable()
                    ? redirect()->route('payment.show', $pending->order_id)->with('error', 'Selesaikan pembayaran untuk membuka ruang chat.')
                    : redirect()->route('consultation.history')->with('error', 'Pembayaran untuk sesi ini belum selesai.');
            }

            abort(403, 'Sesi ini belum dibayar.');
        }

        $consultation->load(['user', 'consultant.user', 'prodi']);

        // pesan dari lawan chat ditandai sudah dibaca
        $consultation->messages()
            ->where('sender_id', '!=', Auth::id())
            ->whereNull('read_at')
            ->update(['read_at' => now()]);

        $messages = $consultation->messages()->orderBy('id')->get()
            ->map(fn ($m) => $this->format($m))->all();

        if ($role === 'student') {
            $peer = [
                'nama' => $consultation->consultant->user->name,
                'foto' => $consultation->consultant->avatar_url,
                'sub' => $consultation->prodi->nama_prodi,
            ];
            $back = route('consultation.consultants', $consultation->prodi_id);
        } else {
            $peer = [
                'nama' => $consultation->user->name,
                'foto' => Avatar::initials($consultation->user->name),
                'sub' => 'Mahasiswa',
            ];
            $back = route('consultant.dashboard');
        }

        $state = $this->state($consultation, $availability, $queueService);
        $existingReview = $consultation->review;

        $appointments = $consultation->appointments()->with('schedule')->orderByDesc('id')->get();

        // Offline Meet: mahasiswa boleh mengajukan pertemuan selama belum ada pengajuan aktif
        $hasActive = $appointments->contains(fn ($a) => in_array($a->status, ['pending', 'approved', 'completed'], true));
        $canPropose = $role === 'student'
            && $consultation->service === 'offline_meet'
            && $consultation->isChatOpen()
            && ! $hasActive;
        $autoOpenMeet = $canPropose && $appointments->isEmpty();

        $availabilityInfo = $availability->summaryFor($consultation->consultant);
        $service = config('temuedu.services.' . $consultation->service);
        $detailUrl = $role === 'consultant' ? route('consultant.consultations.show', $consultation->id) : null;

        return view('consultation.chat', compact(
            'consultation', 'role', 'peer', 'back', 'messages', 'state', 'appointments',
            'detailUrl', 'availabilityInfo', 'service', 'canPropose', 'autoOpenMeet', 'existingReview'
        ));
    }

    /** Polling: ambil pesan baru (id > after) + status sesi. */
    public function messages(Request $request, Consultation $consultation, AvailabilityService $availability, ConsultationQueueService $queueService)
    {
        $this->roleIn($consultation);

        if (! $consultation->isAccessible()) {
            return response()->json(['error' => 'Sesi ini belum dibayar.'], 402);
        }

        $consultation->expireIfNeeded();

        $after = (int) $request->query('after', 0);

        $new = $consultation->messages()->where('id', '>', $after)->orderBy('id')->get();

        $consultation->messages()
            ->where('sender_id', '!=', Auth::id())
            ->whereNull('read_at')
            ->update(['read_at' => now()]);

        return response()->json([
            'messages' => $new->map(fn ($m) => $this->format($m))->values(),
            'state' => $this->state($consultation, $availability, $queueService),
        ]);
    }

    /** Kirim pesan. Untuk Chat: pesan pertama mahasiswa mulai timer tunggu 3 menit; timer 60 menit mulai saat konsultan membalas. */
    public function store(Request $request, Consultation $consultation, AvailabilityService $availability, ConsultationQueueService $queueService)
    {
        $role = $this->roleIn($consultation);

        $data = $request->validate([
            'isi' => ['required', 'string', 'max:2000'],
        ], [
            'isi.required' => 'Pesan tidak boleh kosong.',
            'isi.max' => 'Pesan maksimal 2000 karakter.',
        ]);

        $text = trim($data['isi']);
        if ($text === '') {
            return response()->json(['error' => 'Pesan tidak boleh kosong.'], 422);
        }

        $created = [];
        $error = null;
        $status = 422;

        DB::transaction(function () use ($consultation, $role, $text, $availability, &$created, &$error, &$status) {
            // kunci baris agar dua pesan bersamaan tidak memulai timer dua kali
            $c = Consultation::lockForUpdate()->findOrFail($consultation->id);
            $c->expireIfNeeded();

            if (! $c->isAccessible()) {
                $error = 'Sesi ini belum dibayar.';
                $status = 402;
                return;
            }

            if (! $c->isChatOpen()) {
                $error = 'Sesi konsultasi sudah berakhir.';
                return;
            }

            $consultant = Consultant::findOrFail($c->consultant_id);

            // Konsultan hanya dapat membalas pada jam layanannya
            if ($role === 'consultant' && ! $availability->isAvailableNow($consultant)) {
                $error = 'Kamu sedang di luar jam layanan. Balasan hanya dapat dikirim pada jam layanan (atur di menu Jadwal).';
                return;
            }

            $firstStart = $role === 'student' && ! $c->started_at && ! $c->response_deadline_at;

            // Timer baru dimulai saat konsultan benar-benar bisa menjawab
            if ($firstStart && $c->isTimed() && ! $availability->isAvailableNow($consultant)) {
                $next = $availability->nextWindow($consultant);
                $error = 'Konsultan sedang di luar jam layanan. Mulai chat saat jam layanan'
                    . ($next ? ' (berikutnya: ' . $next['label'] . ').' : '.');
                return;
            }

            if ($role === 'student') {
                $firstQuestion = ! $c->messages()->where('tipe', 'text')->where('sender_id', $c->user_id)->exists();

                if ($firstQuestion && (! $c->topik || in_array($c->topik, ['Online Meet', 'Offline Meet'], true))) {
                    $c->update(['topik' => Str::limit($text, 90)]);
                }
            }

            if ($firstStart && $c->service === 'chat') {
                $waitMinutes = (int) config('temuedu.response_wait_minutes', 3);
                $c->update(['response_deadline_at' => now()->addMinutes($waitMinutes)]);

                $created[] = Message::create([
                    'consultation_id' => $c->id,
                    'sender_id' => Auth::id(),
                    'tipe' => 'system',
                    'isi' => 'Pesan terkirim. Menunggu respon konsultan (maksimal ' . $waitMinutes . ' menit). Durasi konsultasi ' . $c->timerMinutes() . ' menit baru berjalan setelah konsultan membalas.',
                ]);
            } elseif ($firstStart && $c->isTimed()) {
                $c->start();

                $created[] = Message::create([
                    'consultation_id' => $c->id,
                    'sender_id' => Auth::id(),
                    'tipe' => 'system',
                    'isi' => 'Sesi konsultasi dimulai. Chat berlaku ' . $c->timerMinutes() . ' menit, sampai pukul ' . $c->expires_at->format('H:i') . '.',
                ]);
            }

            // Saat konsultan membalas pertama kali di layanan Chat, hentikan waktu tunggu & mulai timer 60 menit
            if ($role === 'consultant' && $c->service === 'chat' && ! $c->consultant_replied_at) {
                $c->update([
                    'consultant_replied_at' => now(),
                    'waiting_queue' => false,
                    'queued_at' => null,
                ]);

                if (! $c->started_at) {
                    $c->start();

                    $created[] = Message::create([
                        'consultation_id' => $c->id,
                        'sender_id' => Auth::id(),
                        'tipe' => 'system',
                        'isi' => 'Konsultan telah siap. Sesi konsultasi dimulai (' . $c->timerMinutes() . ' menit, sampai pukul ' . $c->expires_at->format('H:i') . ').',
                    ]);
                }
            }

            $created[] = Message::create([
                'consultation_id' => $c->id,
                'sender_id' => Auth::id(),
                'tipe' => 'text',
                'isi' => $text,
            ]);
        });

        $fresh = $consultation->fresh();

        if ($error) {
            return response()->json(['error' => $error, 'state' => $this->state($fresh, $availability, $queueService)], $status);
        }

        return response()->json([
            'messages' => array_map(fn ($m) => $this->format($m), $created),
            'state' => $this->state($fresh, $availability, $queueService),
        ]);
    }

    /** Akhiri sesi (oleh mahasiswa atau konsultan). */
    public function close(Consultation $consultation, AvailabilityService $availability, ConsultationQueueService $queueService)
    {
        $role = $this->roleIn($consultation);

        if (! $consultation->isAccessible()) {
            return response()->json(['error' => 'Sesi ini belum dibayar.'], 402);
        }

        $consultation->expireIfNeeded();

        if ($consultation->status === 'active') {
            $consultation->update([
                'status' => 'closed',
                'waiting_queue' => false,
                'queued_at' => null,
            ]);

            Message::create([
                'consultation_id' => $consultation->id,
                'sender_id' => Auth::id(),
                'tipe' => 'system',
                'isi' => 'Sesi konsultasi diakhiri oleh ' . ($role === 'student' ? 'mahasiswa' : 'konsultan') . '.',
            ]);

            $queueService->assignNextWaitingStudent($consultation->consultant, $availability);
        }

        return response()->json(['state' => $this->state($consultation->fresh(), $availability, $queueService)]);
    }

    /** Mahasiswa memilih konsultan lain yang tersedia setelah 3 menit konsultan belum merespon. */
    public function switchConsultant(Request $request, Consultation $consultation, AvailabilityService $availability, ConsultationQueueService $queueService)
    {
        if ($this->roleIn($consultation) !== 'student') {
            abort(403);
        }

        if (! $consultation->canSwitchConsultant()) {
            return response()->json(['error' => 'Perpindahan konsultan hanya tersedia setelah melewati batas tunggu 3 menit tanpa balasan.'], 422);
        }

        $data = $request->validate([
            'consultant_id' => ['required', 'integer', 'exists:consultants,id'],
        ]);

        $target = Consultant::where('is_active', true)
            ->where('prodi_id', $consultation->prodi_id)
            ->where('id', '!=', $consultation->consultant_id)
            ->find($data['consultant_id']);

        if (! $target || ! $availability->isAvailableNow($target) || $queueService->isConsultantBusy($target)) {
            return response()->json(['error' => 'Konsultan yang dipilih sedang tidak tersedia atau sibuk. Silakan pilih konsultan lain atau masuk antrian.'], 422);
        }

        $new = $queueService->switchToConsultant($consultation, $target);

        return response()->json(['redirect' => route('consultation.room', $new)]);
    }

    /** Mahasiswa masuk antrian menunggu konsultan yang tersedia. */
    public function enterQueue(Consultation $consultation, AvailabilityService $availability, ConsultationQueueService $queueService)
    {
        if ($this->roleIn($consultation) !== 'student') {
            abort(403);
        }

        if (! $consultation->canSwitchConsultant()) {
            return response()->json(['error' => 'Antrian hanya tersedia setelah melewati batas tunggu 3 menit tanpa balasan.'], 422);
        }

        if (! $consultation->waiting_queue) {
            $consultation->update([
                'waiting_queue' => true,
                'queued_at' => now(),
            ]);

            Message::create([
                'consultation_id' => $consultation->id,
                'sender_id' => Auth::id(),
                'tipe' => 'system',
                'isi' => 'Mahasiswa masuk antrian menunggu. Jika ada konsultan yang selesai melayani mahasiswa sebelumnya, sesi akan dialihkan otomatis.',
            ]);
        }

        return response()->json(['state' => $this->state($consultation->fresh(), $availability, $queueService)]);
    }

    /**
     * Mahasiswa mengajukan pertemuan OFFLINE MEET setelah berdiskusi di chat.
     * Waktu harus berada di jam layanan konsultan dan tidak bertabrakan.
     * Pembayaran baru dilakukan setelah konsultan menyetujui.
     */
    public function bookAppointment(Request $request, Consultation $consultation, AvailabilityService $availability)
    {
        if ($this->roleIn($consultation) !== 'student') {
            abort(403, 'Hanya mahasiswa yang dapat mengajukan pertemuan.');
        }

        if ($consultation->service !== 'offline_meet') {
            return back()->with('error', 'Pengajuan pertemuan hanya untuk layanan Offline Meet. Online Meet dipesan dari halaman konsultan.');
        }

        $data = $request->validate([
            'tanggal' => ['required', 'date_format:Y-m-d', 'after_or_equal:today'],
            'jam_mulai' => ['required', 'date_format:H:i'],
            'lokasi' => ['required', 'string', 'max:255'],
            'catatan' => ['nullable', 'string', 'max:500'],
        ], [
            'tanggal.required' => 'Tanggal pertemuan wajib diisi.',
            'tanggal.after_or_equal' => 'Tanggal tidak boleh di masa lalu.',
            'jam_mulai.required' => 'Jam mulai wajib diisi.',
            'lokasi.required' => 'Lokasi pertemuan wajib diisi.',
        ]);

        $minutes = (int) config('temuedu.services.offline_meet.minutes');
        $price = (int) config('temuedu.services.offline_meet.price');
        $start = Carbon::createFromFormat('Y-m-d H:i', $data['tanggal'] . ' ' . $data['jam_mulai']);

        $error = null;

        DB::transaction(function () use ($consultation, $data, $availability, $minutes, $price, $start, &$error) {
            $c = Consultation::lockForUpdate()->findOrFail($consultation->id);
            $c->expireIfNeeded();

            if (! $c->isChatOpen()) {
                $error = 'Sesi koordinasi sudah berakhir, pengajuan tidak dapat dibuat.';
                return;
            }

            $active = Appointment::where('consultation_id', $c->id)
                ->whereIn('status', ['pending', 'approved', 'completed'])->exists();

            if ($active) {
                $error = 'Sudah ada pengajuan pertemuan pada sesi ini.';
                return;
            }

            // kunci baris konsultan agar pemesanan bersamaan tidak bertabrakan
            Consultant::whereKey($c->consultant_id)->lockForUpdate()->first();
            $consultant = Consultant::findOrFail($c->consultant_id);

            if ($problem = $availability->validateBooking($consultant, $start, $minutes)) {
                $error = $problem;
                return;
            }

            $block = $availability->reserve($consultant, $start, $minutes);

            Appointment::create([
                'consultation_id' => $c->id,
                'user_id' => Auth::id(),
                'consultant_id' => $c->consultant_id,
                'schedule_id' => $block->id,
                'tipe' => 'offline_meet',
                'lokasi' => $data['lokasi'],
                'catatan' => $data['catatan'] ?? null,
                'status' => 'pending',
                'payment_status' => 'unpaid',
                'duration_minutes' => $minutes,
                'harga' => $price,
            ]);

            Message::create([
                'consultation_id' => $c->id,
                'sender_id' => Auth::id(),
                'tipe' => 'system',
                'isi' => 'Mahasiswa mengajukan Offline Meet pada ' . $start->translatedFormat('l, d M Y')
                    . ' pukul ' . $start->format('H:i') . '-' . $start->copy()->addMinutes($minutes)->format('H:i')
                    . ', lokasi: ' . $data['lokasi'] . '. Menunggu persetujuan konsultan.',
            ]);
        });

        return back()->with($error ? 'error' : 'success', $error ?? 'Pengajuan Offline Meet dikirim. Setelah konsultan menyetujui, kamu bisa melakukan pembayaran.');
    }

    /** Mahasiswa membatalkan janji yang BELUM dibayar (tahanan jadwal dilepas). */
    public function cancelAppointment(Consultation $consultation, $appointmentId)
    {
        if ($this->roleIn($consultation) !== 'student') {
            abort(403);
        }

        $appointment = $consultation->appointments()->with('schedule')->findOrFail($appointmentId);

        if ($appointment->payment_status === 'paid') {
            return back()->with('error', 'Janji yang sudah dibayar tidak dapat dibatalkan sendiri. Hubungi administrator.');
        }

        if (! in_array($appointment->status, ['pending', 'approved'], true)) {
            return back()->with('error', 'Janji ini tidak dapat dibatalkan.');
        }

        DB::transaction(function () use ($appointment, $consultation) {
            $appointment->update(['status' => 'cancelled']);
            $appointment->schedule?->update(['is_booked' => false]);

            Payment::where('appointment_id', $appointment->id)->where('status', 'pending')->update(['status' => 'cancelled']);

            if ($consultation->service === 'online_meet' && ! $consultation->is_paid) {
                $consultation->update(['status' => 'expired']);
            }

            Message::create([
                'consultation_id' => $consultation->id,
                'sender_id' => Auth::id(),
                'tipe' => 'system',
                'isi' => 'Mahasiswa membatalkan janji meet.',
            ]);
        });

        return back()->with('success', 'Janji meet dibatalkan.');
    }

    /**
     * Pemeriksaan hak akses: hanya mahasiswa pemilik sesi dan konsultan pemilik sesi.
     * Admin & pengguna lain -> 403.
     */
    private function roleIn(Consultation $consultation): string
    {
        $user = Auth::user();

        if ((int) $consultation->user_id === (int) $user->id) {
            return 'student';
        }

        if ($user->role === 'konsultan' && $user->consultant
            && (int) $user->consultant->id === (int) $consultation->consultant_id) {
            return 'consultant';
        }

        abort(403, 'Anda bukan peserta konsultasi ini.');
    }

    private function format(Message $m): array
    {
        return [
            'id' => $m->id,
            'mine' => (int) $m->sender_id === (int) Auth::id(),
            'tipe' => $m->tipe,
            'text' => $m->isi,
            'time' => $m->created_at->format('H:i'),
        ];
    }

    private function state(Consultation $c, ?AvailabilityService $availability = null, ?ConsultationQueueService $queueService = null): array
    {
        $switchedTo = $c->status === 'closed'
            ? Consultation::where('switched_from_consultation_id', $c->id)->latest('id')->first()
            : null;

        $canSwitch = $c->canSwitchConsultant();
        $isStudent = (int) $c->user_id === (int) Auth::id();

        $available = ($canSwitch && $isStudent && $availability && $queueService)
            ? $queueService->availableConsultantsForSwitch($c, $availability)
            : [];

        $review = $c->review;

        return [
            'status' => $c->status,
            'open' => $c->isChatOpen(),
            'started' => (bool) $c->started_at,
            'remaining' => $c->remainingSeconds(),
            'service' => $c->service,
            'timed' => $c->isTimed(),
            'minutes' => $c->timerMinutes(),
            'waiting_response' => $c->isWaitingResponse(),
            'wait_remaining' => $c->waitRemainingSeconds(),
            'can_switch' => $canSwitch,
            'waiting_queue' => (bool) $c->waiting_queue,
            'available_consultants' => $available,
            'redirect' => $switchedTo && $isStudent ? route('consultation.room', $switchedTo) : null,
            'reviewed' => (bool) $review,
            'review' => $review ? ['rating' => $review->rating, 'ulasan' => $review->ulasan] : null,
        ];
    }
}
