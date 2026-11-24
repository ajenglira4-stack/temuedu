<?php

namespace App\Http\Controllers;

use App\Models\Consultation;
use App\Models\Message;
use App\Support\Avatar;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    /**
     * Menampilkan profil mahasiswa.
     */
    public function show(Request $request)
    {
        $user = $request->user();

        $totalKonsultasi = Consultation::where('user_id', $user->id)
            ->whereHas('messages')
            ->count();

        $unread = Message::unreadFor($user)->count();

        $avatar = Avatar::initials($user->name);

        return view('profile.show', compact(
            'user',
            'totalKonsultasi',
            'unread',
            'avatar'
        ));
    }

    /**
     * Memperbarui nama dan email mahasiswa.
     */
    public function update(Request $request)
    {
        $user = $request->user();

        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => [
                'required',
                'string',
                'email',
                'max:255',
                'unique:users,email,' . $user->id,
            ],
            'jurusan' => ['nullable', 'string', 'max:120'],
        ], [
            'name.required' => 'Nama lengkap wajib diisi.',
            'name.max' => 'Nama maksimal 255 karakter.',
            'email.required' => 'Email wajib diisi.',
            'email.email' => 'Format email tidak valid.',
            'email.unique' => 'Email tersebut sudah digunakan akun lain.',
            'email.max' => 'Email maksimal 255 karakter.',
            'jurusan.max' => 'Jurusan maksimal 120 karakter.',
        ]);

        // Hanya memperbarui nama, email, dan jurusan akun yang sedang login.
        // Role dan password tidak dapat diubah melalui form ini.
        $user->name = $data['name'];
        $user->email = $data['email'];
        $user->jurusan = isset($data['jurusan']) ? (trim($data['jurusan']) ?: null) : null;
        $user->save();

        return redirect()
            ->route('profile.show')
            ->with('success', 'Profil berhasil diperbarui!');
    }

    /**
     * Menyimpan preferensi notifikasi mahasiswa dan konsultan.
     */
    public function updateNotifications(Request $request)
    {
        $data = $request->validate([
            'notification_enabled' => ['required', 'in:0,1'],
        ]);

        $user = $request->user();

        $user->notification_enabled = $data['notification_enabled'] === '1';
        $user->save();

        return back()->with('success', $user->notification_enabled
            ? 'Notifikasi pesan diaktifkan.'
            : 'Notifikasi pesan dimatikan.');
    }
}
