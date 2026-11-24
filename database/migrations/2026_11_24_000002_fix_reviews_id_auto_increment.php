<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement('ALTER TABLE `reviews` MODIFY `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT');
        }
    }

    public function down(): void
    {
        //
    }
};
