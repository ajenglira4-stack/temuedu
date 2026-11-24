<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportSql extends Command
{
    protected $signature = 'temuedu:import-sql {file=temuedu.sql : Path dump SQL relatif ke root project}';

    protected $description = 'Mengimpor data (INSERT saja) dari dump phpMyAdmin ke database. Baris yang sudah ada dilewati.';

    /** Tabel yang tidak diimpor: migrations sudah diisi oleh artisan migrate. */
    private const SKIP = ['migrations'];

    public function handle(): int
    {
        $path = base_path($this->argument('file'));

        if (! is_file($path)) {
            $this->error("File {$path} tidak ditemukan.");
            return self::FAILURE;
        }

        $sql = file_get_contents($path);

        // Setiap blok data diawali "INSERT INTO `tabel`" dan diakhiri ";" lalu baris kosong dan komentar "--".
        preg_match_all('/INSERT INTO\s+`(\w+)`.*?;\n(?=\n--)/s', $sql, $matches, PREG_SET_ORDER);

        if (! $matches) {
            $this->warn('Tidak ada perintah INSERT di dump.');
            return self::SUCCESS;
        }

        DB::statement('SET FOREIGN_KEY_CHECKS=0');
        DB::statement("SET SESSION sql_mode='NO_AUTO_VALUE_ON_ZERO'");

        try {
            foreach ($matches as [$statement, $table]) {
                if (in_array($table, self::SKIP, true)) {
                    $this->line("Dilewati: {$table}");
                    continue;
                }

                $insert = preg_replace('/^INSERT INTO/', 'INSERT IGNORE INTO', $statement, 1);
                DB::unprepared($insert);
                $this->info("Diimpor: {$table} (" . DB::table($table)->count() . ' baris sekarang)');
            }
        } finally {
            DB::statement('SET FOREIGN_KEY_CHECKS=1');
        }

        return self::SUCCESS;
    }
}
