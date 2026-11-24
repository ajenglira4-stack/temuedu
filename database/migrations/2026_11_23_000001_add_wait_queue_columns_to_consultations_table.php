<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('consultations', function (Blueprint $table) {
            $table->timestamp('response_deadline_at')->nullable()->after('expires_at');
            $table->timestamp('consultant_replied_at')->nullable()->after('response_deadline_at');
            $table->boolean('waiting_queue')->default(false)->after('consultant_replied_at');
            $table->timestamp('queued_at')->nullable()->after('waiting_queue');
            $table->foreignId('switched_from_consultation_id')
                ->nullable()
                ->after('queued_at')
                ->constrained('consultations')
                ->nullOnDelete();

            $table->index(['waiting_queue', 'status', 'prodi_id', 'queued_at'], 'consultations_wait_queue_idx');
        });
    }

    public function down(): void
    {
        Schema::table('consultations', function (Blueprint $table) {
            $table->dropIndex('consultations_wait_queue_idx');
            $table->dropConstrainedForeignId('switched_from_consultation_id');
            $table->dropColumn(['response_deadline_at', 'consultant_replied_at', 'waiting_queue', 'queued_at']);
        });
    }
};
