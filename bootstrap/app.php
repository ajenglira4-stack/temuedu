<?php

use App\Http\Middleware\RoleMiddleware;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Request;
use Symfony\Component\HttpKernel\Exception\HttpException;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        // Percayai reverse proxy (seperti Railway) agar HTTPS/IP client terbaca dengan benar
        $middleware->trustProxies(at: '*');

        // Daftarkan alias "role" agar bisa dipakai: ->middleware('role:admin')
        // Webhook Midtrans dikirim dari server Midtrans (tanpa token CSRF); keasliannya dicek lewat signature.
        $middleware->validateCsrfTokens(except: ['midtrans/notification']);

        $middleware->alias([
            'role' => RoleMiddleware::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        // Jika POST /logout terkena 419 (session/CSRF sudah kedaluwarsa), langsung arahkan ke /login
        $exceptions->render(function (HttpException $e, Request $request) {
            if ($e->getStatusCode() === 419 && $request->is('logout')) {
                return redirect()->route('login');
            }
        });
    })->create();
