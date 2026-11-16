-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 10, 2026 at 05:06 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `temuedu`
--

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `consultation_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `consultant_id` bigint(20) UNSIGNED NOT NULL,
  `schedule_id` bigint(20) UNSIGNED NOT NULL,
  `tipe` enum('online_meet','offline_meet') NOT NULL,
  `link_meeting` varchar(255) DEFAULT NULL,
  `lokasi` varchar(255) DEFAULT NULL,
  `catatan` text DEFAULT NULL,
  `status` enum('pending','approved','rejected','completed','cancelled') NOT NULL DEFAULT 'pending',
  `payment_status` varchar(20) NOT NULL DEFAULT 'paid',
  `duration_minutes` smallint(5) UNSIGNED DEFAULT NULL,
  `harga` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`id`, `consultation_id`, `user_id`, `consultant_id`, `schedule_id`, `tipe`, `link_meeting`, `lokasi`, `catatan`, `status`, `payment_status`, `duration_minutes`, `harga`, `created_at`, `updated_at`) VALUES
(1, 1, 4, 1, 1, 'online_meet', NULL, NULL, 'Ingin dibahas dengan contoh soal.', 'pending', 'paid', NULL, NULL, '2026-10-23 11:56:45', '2026-10-23 11:56:45'),
(2, 2, 4, 2, 4, 'online_meet', NULL, NULL, 'ingin membahas bab 1', 'pending', 'paid', NULL, NULL, '2026-10-23 12:31:05', '2026-10-23 12:31:05'),
(3, 3, 4, 1, 2, 'online_meet', NULL, NULL, 'bab 1', 'pending', 'paid', NULL, NULL, '2026-10-24 04:50:25', '2026-10-24 04:50:25'),
(4, 19, 4, 1, 9, 'online_meet', 'https://zoom.us/id/join', NULL, NULL, 'approved', 'paid', 90, 55000, '2026-11-09 02:55:13', '2026-11-09 03:14:49');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('laravel-cache-1b6453892473a467d07372d45eb05abc2031647a', 'i:1;', 1794209347),
('laravel-cache-1b6453892473a467d07372d45eb05abc2031647a:timer', 'i:1794209347;', 1794209347),
('laravel-cache-ac3478d69a3c81fa62e60f5c3696165a4e5e6ac4', 'i:1;', 1794034527),
('laravel-cache-ac3478d69a3c81fa62e60f5c3696165a4e5e6ac4:timer', 'i:1794034527;', 1794034527),
('laravel-cache-da4b9237bacccdf19c0760cab7aec4a8359010b0', 'i:1;', 1794195494),
('laravel-cache-da4b9237bacccdf19c0760cab7aec4a8359010b0:timer', 'i:1794195494;', 1794195494);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `consultants`
--

CREATE TABLE `consultants` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `prodi_id` bigint(20) UNSIGNED NOT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `domisili` varchar(255) DEFAULT NULL,
  `kompetensi` text DEFAULT NULL,
  `alumni` varchar(255) DEFAULT NULL,
  `ipk` decimal(3,2) DEFAULT NULL,
  `harga` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `portofolio_link` varchar(255) DEFAULT NULL,
  `rating_avg` decimal(2,1) NOT NULL DEFAULT 0.0,
  `rating_count` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `consultants`
--

INSERT INTO `consultants` (`id`, `user_id`, `prodi_id`, `foto`, `domisili`, `kompetensi`, `alumni`, `ipk`, `harga`, `portofolio_link`, `rating_avg`, `rating_count`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 2, 1, NULL, 'Jakarta', 'Akuntansi Keuangan, Perpajakan', 'Universitas Negeri Jakarta', 3.90, 30000, NULL, 0.0, 0, 1, '2026-10-23 11:56:43', '2026-10-23 11:56:43'),
(2, 3, 2, NULL, 'Jakarta', 'Manajemen Bisnis, Kewirausahaan', 'Universitas Indonesia', 3.85, 25000, NULL, 0.0, 0, 1, '2026-10-23 11:56:44', '2026-10-23 11:56:44'),
(3, 5, 1, 'consultants/6yIsgUicHhP2DZhsxdYOD14Ftt1GwhOZcO3bK7Uu.jpg', 'jakarta', 'Akuntansi Keuangan', 'Universitas Tama Jagarkasa', 3.72, 55000, 'https://www.linkedin.com/in/hadijah-s-e-051a63148?trk=contact-info', 0.0, 0, 1, '2026-10-24 05:15:05', '2026-10-24 05:15:05');

-- --------------------------------------------------------

--
-- Table structure for table `consultant_availabilities`
--

CREATE TABLE `consultant_availabilities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `consultant_id` bigint(20) UNSIGNED NOT NULL,
  `day_of_week` tinyint(3) UNSIGNED NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `consultant_availabilities`
--

INSERT INTO `consultant_availabilities` (`id`, `consultant_id`, `day_of_week`, `start_time`, `end_time`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(2, 1, 2, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(3, 1, 3, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(4, 1, 4, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(5, 1, 5, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(6, 1, 6, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(7, 1, 7, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(8, 2, 1, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(9, 2, 2, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(10, 2, 3, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(11, 2, 4, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(12, 2, 5, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(13, 2, 6, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(14, 2, 7, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(15, 3, 1, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(16, 3, 2, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(17, 3, 3, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(18, 3, 4, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(19, 3, 5, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(20, 3, 6, '00:00:00', '23:59:00', 1, '2026-10-25 12:40:04', '2026-10-25 12:40:04'),
(21, 3, 7, '16:00:00', '19:00:00', 1, '2026-10-25 12:40:04', '2026-11-07 06:54:17');

-- --------------------------------------------------------

--
-- Table structure for table `consultant_schedules`
--

CREATE TABLE `consultant_schedules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `consultant_id` bigint(20) UNSIGNED NOT NULL,
  `tanggal` date NOT NULL,
  `jam_mulai` time NOT NULL,
  `jam_selesai` time NOT NULL,
  `is_booked` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `consultant_schedules`
--

INSERT INTO `consultant_schedules` (`id`, `consultant_id`, `tanggal`, `jam_mulai`, `jam_selesai`, `is_booked`, `created_at`, `updated_at`) VALUES
(1, 1, '2026-10-24', '09:00:00', '10:00:00', 1, '2026-10-23 11:56:45', '2026-10-23 11:56:45'),
(2, 1, '2026-10-24', '13:00:00', '14:00:00', 1, '2026-10-23 11:56:45', '2026-10-24 04:50:25'),
(3, 1, '2026-10-25', '09:00:00', '10:00:00', 0, '2026-10-23 11:56:45', '2026-10-23 11:56:45'),
(4, 2, '2026-10-24', '09:00:00', '10:00:00', 1, '2026-10-23 11:56:45', '2026-10-23 12:31:05'),
(5, 2, '2026-10-24', '13:00:00', '14:00:00', 0, '2026-10-23 11:56:45', '2026-10-23 11:56:45'),
(6, 2, '2026-10-25', '09:00:00', '10:00:00', 0, '2026-10-23 11:56:45', '2026-10-23 11:56:45'),
(7, 3, '2026-10-24', '18:30:00', '20:30:00', 0, '2026-10-24 05:19:31', '2026-10-24 05:19:31'),
(8, 3, '2026-10-26', '17:00:00', '18:00:00', 0, '2026-10-24 05:20:26', '2026-10-24 05:20:26'),
(9, 1, '2026-11-10', '15:00:00', '16:30:00', 1, '2026-11-09 02:55:13', '2026-11-09 02:55:13');

-- --------------------------------------------------------

--
-- Table structure for table `consultations`
--

CREATE TABLE `consultations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `consultant_id` bigint(20) UNSIGNED NOT NULL,
  `prodi_id` bigint(20) UNSIGNED NOT NULL,
  `service` varchar(20) NOT NULL DEFAULT 'chat',
  `is_paid` tinyint(1) NOT NULL DEFAULT 1,
  `topik` varchar(255) DEFAULT NULL,
  `harga` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `status` enum('active','closed','expired') NOT NULL DEFAULT 'active',
  `started_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `consultations`
--

INSERT INTO `consultations` (`id`, `user_id`, `consultant_id`, `prodi_id`, `service`, `is_paid`, `topik`, `harga`, `status`, `started_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 4, 1, 1, 'chat', 1, 'Bingung menyusun laporan arus kas', 30000, 'expired', '2026-10-23 11:51:45', '2026-10-23 12:51:45', '2026-10-23 11:56:45', '2026-10-24 04:49:58'),
(2, 4, 2, 2, 'chat', 1, 'halooo', 25000, 'expired', '2026-10-23 12:31:17', '2026-10-23 13:31:17', '2026-10-23 11:59:26', '2026-10-24 04:53:23'),
(3, 4, 1, 1, 'chat', 1, NULL, 30000, 'closed', NULL, NULL, '2026-10-24 04:49:58', '2026-10-31 08:56:16'),
(4, 4, 2, 2, 'chat', 1, NULL, 25000, 'closed', NULL, NULL, '2026-10-24 05:06:47', '2026-10-25 12:48:55'),
(5, 4, 3, 1, 'chat', 1, NULL, 55000, 'closed', NULL, NULL, '2026-10-24 05:16:55', '2026-10-24 05:16:55'),
(6, 4, 2, 2, 'chat', 0, NULL, 35000, 'expired', NULL, NULL, '2026-10-25 12:49:02', '2026-10-25 12:49:10'),
(7, 4, 2, 2, 'chat', 0, NULL, 35000, 'expired', NULL, NULL, '2026-10-25 12:56:55', '2026-10-25 12:56:56'),
(8, 4, 2, 2, 'chat', 0, NULL, 35000, 'expired', NULL, NULL, '2026-10-25 13:01:08', '2026-10-25 13:01:10'),
(9, 4, 2, 2, 'chat', 0, NULL, 35000, 'expired', NULL, NULL, '2026-10-25 13:06:22', '2026-10-25 13:06:23'),
(10, 4, 2, 2, 'chat', 1, NULL, 35000, 'closed', NULL, NULL, '2026-10-25 13:07:19', '2026-10-25 13:07:19'),
(11, 4, 1, 1, 'chat', 0, NULL, 35000, 'expired', NULL, NULL, '2026-10-31 08:56:22', '2026-10-31 09:29:01'),
(12, 4, 1, 1, 'offline_meet', 0, 'Offline Meet', 155000, 'closed', NULL, NULL, '2026-10-31 08:57:49', '2026-10-31 09:07:56'),
(13, 4, 2, 2, 'chat', 1, NULL, 35000, 'expired', NULL, NULL, '2026-10-31 10:18:55', '2026-10-31 10:18:55'),
(14, 4, 3, 1, 'chat', 1, NULL, 35000, 'active', NULL, NULL, '2026-10-31 10:24:40', '2026-10-31 10:24:40'),
(15, 4, 1, 1, 'chat', 1, NULL, 35000, 'active', NULL, NULL, '2026-10-31 10:40:43', '2026-10-31 10:40:53'),
(16, 4, 3, 1, 'chat', 1, NULL, 35000, 'closed', NULL, NULL, '2026-10-31 10:41:06', '2026-11-07 06:45:31'),
(17, 4, 2, 2, 'chat', 1, NULL, 35000, 'active', NULL, NULL, '2026-11-07 04:21:59', '2026-11-07 04:22:11'),
(18, 4, 3, 1, 'chat', 1, NULL, 35000, 'active', NULL, NULL, '2026-11-07 06:45:39', '2026-11-07 06:47:43'),
(19, 4, 1, 1, 'online_meet', 1, 'halo', 55000, 'active', NULL, NULL, '2026-11-09 02:55:13', '2026-11-09 02:55:55');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `consultation_id` bigint(20) UNSIGNED NOT NULL,
  `sender_id` bigint(20) UNSIGNED NOT NULL,
  `tipe` enum('text','system') NOT NULL DEFAULT 'text',
  `isi` text NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `consultation_id`, `sender_id`, `tipe`, `isi`, `read_at`, `created_at`, `updated_at`) VALUES
(1, 1, 4, 'text', 'Halo Kak, saya bingung menyusun laporan arus kas untuk tugas akuntansi.', '2026-11-09 03:13:52', '2026-10-23 11:56:45', '2026-11-09 03:13:52'),
(2, 1, 2, 'text', 'Halo! Boleh ceritakan bagian mana yang paling membingungkan?', '2026-10-24 04:56:20', '2026-10-23 11:56:45', '2026-10-24 04:56:20'),
(3, 1, 4, 'text', 'Saya belum paham bedanya arus kas operasi dan investasi.', '2026-11-09 03:13:52', '2026-10-23 11:56:45', '2026-11-09 03:13:52'),
(4, 2, 4, 'system', 'Mahasiswa mengajukan janji online meet pada Sabtu, 24 Okt 2026 pukul 09:00-10:00. Menunggu persetujuan konsultan.', '2026-10-23 12:32:41', '2026-10-23 12:31:05', '2026-10-23 12:32:41'),
(5, 2, 4, 'system', 'Sesi konsultasi dimulai. Chat berlaku 1 jam, sampai pukul 20:31.', '2026-10-23 12:32:41', '2026-10-23 12:31:17', '2026-10-23 12:32:41'),
(6, 2, 4, 'text', 'halooo', '2026-10-23 12:32:41', '2026-10-23 12:31:17', '2026-10-23 12:32:41'),
(7, 2, 3, 'text', 'gmeet akan dikirim link nya besok', '2026-10-23 12:36:29', '2026-10-23 12:34:01', '2026-10-23 12:36:29'),
(8, 3, 4, 'system', 'Mahasiswa mengajukan janji online meet pada Sabtu, 24 Okt 2026 pukul 13:00-14:00. Menunggu persetujuan konsultan.', '2026-10-24 04:58:28', '2026-10-24 04:50:25', '2026-10-24 04:58:28'),
(9, 3, 2, 'text', 'halo', '2026-10-24 04:58:42', '2026-10-24 04:58:34', '2026-10-24 04:58:42'),
(10, 4, 4, 'system', 'Sesi konsultasi diakhiri oleh mahasiswa.', NULL, '2026-10-25 12:48:55', '2026-10-25 12:48:55'),
(11, 3, 4, 'system', 'Sesi konsultasi diakhiri oleh mahasiswa.', NULL, '2026-10-31 08:56:16', '2026-10-31 08:56:16'),
(12, 12, 4, 'system', 'Sesi konsultasi diakhiri oleh mahasiswa.', NULL, '2026-10-31 09:07:56', '2026-10-31 09:07:56'),
(13, 15, 4, 'system', 'Pembayaran Chat berhasil. Silakan mulai bertanya; timer 60 menit berjalan saat pesan pertama dikirim.', NULL, '2026-10-31 10:40:53', '2026-10-31 10:40:53'),
(14, 16, 4, 'system', 'Pembayaran Chat berhasil. Silakan mulai bertanya; timer 60 menit berjalan saat pesan pertama dikirim.', NULL, '2026-10-31 10:41:21', '2026-10-31 10:41:21'),
(15, 17, 4, 'system', 'Pembayaran Chat berhasil. Silakan mulai bertanya; timer 60 menit berjalan saat pesan pertama dikirim.', NULL, '2026-11-07 04:22:11', '2026-11-07 04:22:11'),
(16, 16, 4, 'system', 'Sesi konsultasi diakhiri oleh mahasiswa.', NULL, '2026-11-07 06:45:31', '2026-11-07 06:45:31'),
(17, 18, 4, 'system', 'Pembayaran Chat berhasil. Silakan mulai bertanya; timer 60 menit berjalan saat pesan pertama dikirim.', '2026-11-07 06:52:28', '2026-11-07 06:47:43', '2026-11-07 06:52:28'),
(18, 19, 4, 'system', 'Pembayaran Online Meet berhasil. Jadwal: Selasa, 10 Nov 2026 pukul 15:00-16:30. Menunggu konsultan mengirim link meeting.', '2026-11-09 03:14:02', '2026-11-09 02:55:40', '2026-11-09 03:14:02'),
(19, 19, 4, 'text', 'halo', '2026-11-09 03:14:02', '2026-11-09 02:55:55', '2026-11-09 03:14:02'),
(20, 19, 4, 'text', 'mau membahas laporan', '2026-11-09 03:14:02', '2026-11-09 02:56:03', '2026-11-09 03:14:02'),
(21, 19, 2, 'text', 'oke, saya setting link nya', '2026-11-09 03:15:31', '2026-11-09 03:14:12', '2026-11-09 03:15:31'),
(22, 19, 2, 'system', 'Online Meet dikonfirmasi konsultan. Link meeting: https://zoom.us/id/join.', '2026-11-09 03:15:31', '2026-11-09 03:14:49', '2026-11-09 03:15:31');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_10_19_000001_add_role_to_users_table', 2),
(5, '2026_10_19_000002_create_prodis_table', 2),
(6, '2026_10_19_000003_create_consultants_table', 2),
(7, '2026_10_19_000004_create_consultant_schedules_table', 2),
(8, '2026_10_19_000005_create_consultations_table', 2),
(9, '2026_10_19_000006_create_messages_table', 2),
(10, '2026_10_19_000007_create_appointments_table', 2),
(11, '2026_10_19_000008_create_reviews_table', 2),
(12, '2026_10_24_000001_add_notification_enabled_to_users_table', 3),
(13, '2026_10_26_000001_create_consultant_availabilities_table', 4),
(14, '2026_10_26_000002_create_payments_table', 4),
(15, '2026_10_26_000003_add_service_payment_columns', 4);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` varchar(64) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `consultant_id` bigint(20) UNSIGNED NOT NULL,
  `consultation_id` bigint(20) UNSIGNED DEFAULT NULL,
  `appointment_id` bigint(20) UNSIGNED DEFAULT NULL,
  `service` varchar(20) NOT NULL,
  `amount` int(10) UNSIGNED NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `snap_token` text DEFAULT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  `payment_type` varchar(50) DEFAULT NULL,
  `transaction_status` varchar(30) DEFAULT NULL,
  `fraud_status` varchar(30) DEFAULT NULL,
  `raw_notification` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`raw_notification`)),
  `expires_at` timestamp NULL DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `order_id`, `user_id`, `consultant_id`, `consultation_id`, `appointment_id`, `service`, `amount`, `status`, `snap_token`, `transaction_id`, `payment_type`, `transaction_status`, `fraud_status`, `raw_notification`, `expires_at`, `paid_at`, `created_at`, `updated_at`) VALUES
(1, 'TEMU-261025194902-0DBUV6', 4, 2, 6, NULL, 'chat', 35000, 'failed', NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-25 13:19:02', NULL, '2026-10-25 12:49:02', '2026-10-25 12:49:10'),
(2, 'TEMU-261025195655-4FWROA', 4, 2, 7, NULL, 'chat', 35000, 'failed', NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-25 13:26:55', NULL, '2026-10-25 12:56:55', '2026-10-25 12:56:56'),
(3, 'TEMU-261025200108-PZASRS', 4, 2, 8, NULL, 'chat', 35000, 'failed', NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-25 13:31:08', NULL, '2026-10-25 13:01:08', '2026-10-25 13:01:10'),
(4, 'TEMU-261025200622-BQ7X1C', 4, 2, 9, NULL, 'chat', 35000, 'failed', NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-25 13:36:22', NULL, '2026-10-25 13:06:22', '2026-10-25 13:06:23'),
(5, 'TEMU-261025200719-SOYQRS', 4, 2, 10, NULL, 'chat', 35000, 'expired', '3b8d8df0-d82b-434f-8ca3-00fcf2b3e093', 'f1864d40-ff9e-4352-82d3-b88b6de87f37', 'qris', 'pending', 'accept', '{\"status_code\":\"201\",\"transaction_id\":\"f1864d40-ff9e-4352-82d3-b88b6de87f37\",\"gross_amount\":\"35000.00\",\"currency\":\"IDR\",\"order_id\":\"TEMU-261025200719-SOYQRS\",\"payment_type\":\"qris\",\"signature_key\":\"0b3072e4ad982113ccb2b37a477400d05fbb95fb398e4cdc8a4368f6bc32701a4490280c05acdeca7b41a9d1f28536e77bf2b5edd42c4a4f205cdcbb4ef8870a\",\"transaction_status\":\"pending\",\"fraud_status\":\"accept\",\"status_message\":\"Success, transaction is found\",\"merchant_id\":\"M524091486\",\"transaction_time\":\"2026-10-25 20:09:24\",\"expiry_time\":\"2026-10-25 20:39:24\"}', '2026-10-25 13:37:19', NULL, '2026-10-25 13:07:19', '2026-10-31 08:28:00'),
(6, 'TEMU-261031155622-BVWZLD', 4, 1, 11, NULL, 'chat', 35000, 'expired', 'd2b70ab7-c986-44b5-8e07-4671ee306ca1', NULL, NULL, NULL, NULL, NULL, '2026-10-31 09:26:22', NULL, '2026-10-31 08:56:22', '2026-10-31 09:29:01'),
(7, 'TEMU-261031171855-SDQZ9T', 4, 2, 13, NULL, 'chat', 35000, 'expired', 'ae02d00e-babc-464a-9152-91f2afdc78ba', '4ea1bf5e-c07e-4b69-af2e-cd91d220194e', 'qris', 'pending', 'accept', '{\"status_code\":\"201\",\"transaction_id\":\"4ea1bf5e-c07e-4b69-af2e-cd91d220194e\",\"gross_amount\":\"35000.00\",\"currency\":\"IDR\",\"order_id\":\"TEMU-261031171855-SDQZ9T\",\"payment_type\":\"qris\",\"signature_key\":\"f6826b597439b08e600a5540e3f82fd7eb0091c61ab892c15e15714fd5a3a03546d8a6a3f938d24de28273b735b4d56627b929eb0a741058c24c3ab1cdebc4a8\",\"transaction_status\":\"pending\",\"fraud_status\":\"accept\",\"status_message\":\"Success, transaction is found\",\"merchant_id\":\"M524091486\",\"transaction_time\":\"2026-10-31 17:19:04\",\"expiry_time\":\"2026-10-31 17:49:04\"}', '2026-10-31 10:48:55', NULL, '2026-10-31 10:18:55', '2026-11-07 04:21:58'),
(8, 'TEMU-261031172440-YZMBOC', 4, 3, 14, NULL, 'chat', 35000, 'expired', 'ce540ea1-8cd4-4814-8e45-690a53da2bbc', '20ed6a2f-7059-4291-984d-2f55fc780a93', 'bank_transfer', 'pending', 'accept', '{\"status_code\":\"201\",\"transaction_id\":\"20ed6a2f-7059-4291-984d-2f55fc780a93\",\"gross_amount\":\"35000.00\",\"currency\":\"IDR\",\"order_id\":\"TEMU-261031172440-YZMBOC\",\"payment_type\":\"bank_transfer\",\"signature_key\":\"5321f869d12d32149cccf522ac9fe6505d009810600804745a10a9520731169521d1038712809b00f330d763dfd5ba19f65fec50ffb3826a2c2a42b02ab0c69e\",\"transaction_status\":\"pending\",\"fraud_status\":\"accept\",\"status_message\":\"Success, transaction is found\",\"merchant_id\":\"M524091486\",\"va_numbers\":[{\"bank\":\"bca\",\"va_number\":\"91486133399094371000289\"}],\"payment_amounts\":[],\"transaction_time\":\"2026-10-31 17:25:02\",\"expiry_time\":\"2026-10-31 17:55:02\"}', '2026-10-31 10:54:40', NULL, '2026-10-31 10:24:40', '2026-11-07 04:21:58'),
(9, 'TEMU-261031174043-Q8DQKW', 4, 1, 15, NULL, 'chat', 35000, 'paid', 'SIMULATION', 'SIM-J8CXDLZSLJ', 'simulasi-qris', 'settlement', 'accept', NULL, '2026-10-31 11:10:43', '2026-10-31 10:40:53', '2026-10-31 10:40:43', '2026-10-31 10:40:53'),
(10, 'TEMU-261031174106-FA656P', 4, 3, 16, NULL, 'chat', 35000, 'paid', 'SIMULATION', 'SIM-WHB44N4AJV', 'simulasi-bank_transfer', 'settlement', 'accept', NULL, '2026-10-31 11:11:06', '2026-10-31 10:41:21', '2026-10-31 10:41:06', '2026-10-31 10:41:21'),
(11, 'TEMU-261107112159-KHRE3U', 4, 2, 17, NULL, 'chat', 35000, 'paid', 'SIMULATION', 'SIM-IDWQLWJHYO', 'simulasi-qris', 'settlement', 'accept', NULL, '2026-11-07 04:51:59', '2026-11-07 04:22:11', '2026-11-07 04:21:59', '2026-11-07 04:22:11'),
(12, 'TEMU-261107134539-WVBGXW', 4, 3, 18, NULL, 'chat', 35000, 'paid', 'SIMULATION', 'SIM-CDCIU5EFFY', 'simulasi-qris', 'settlement', 'accept', NULL, '2026-11-07 07:15:39', '2026-11-07 06:47:43', '2026-11-07 06:45:39', '2026-11-07 06:47:43'),
(13, 'TEMU-261109095513-JZ1POY', 4, 1, 19, 4, 'online_meet', 55000, 'paid', 'SIMULATION', 'SIM-3EABVIZOTB', 'simulasi-qris', 'settlement', 'accept', NULL, '2026-11-09 03:25:13', '2026-11-09 02:55:40', '2026-11-09 02:55:13', '2026-11-09 02:55:40');

-- --------------------------------------------------------

--
-- Table structure for table `prodis`
--

CREATE TABLE `prodis` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama_prodi` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `prodis`
--

INSERT INTO `prodis` (`id`, `nama_prodi`, `created_at`, `updated_at`) VALUES
(1, 'Akuntansi', '2026-10-21 01:39:50', '2026-10-21 01:39:50'),
(2, 'Manajemen', '2026-10-21 01:39:50', '2026-10-21 01:39:50'),
(3, 'Bisnis Digital', '2026-10-21 01:39:50', '2026-10-21 01:39:50'),
(4, 'Ilmu Ekonomi', '2026-10-21 01:39:50', '2026-10-21 01:39:50'),
(5, 'Ekonomi Islam / Syariah', '2026-10-21 01:39:50', '2026-10-21 01:39:50');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `consultation_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `consultant_id` bigint(20) UNSIGNED NOT NULL,
  `rating` tinyint(3) UNSIGNED NOT NULL,
  `ulasan` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('dMZVf3sPWoVeI2YXmuO1P97uBsPcgqYWlbXtM32v', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiUGlrdzhxZzZFdGV3MDlkZFRyTGNBQ0l2OGJkSFI3czZld1RkekhqVCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1794229902),
('JYNmaLlrAly0wbxgCTz5AVN3QUpW57kVnWsN7Xgg', 4, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', 'YTo2OntzOjY6Il90b2tlbiI7czo0MDoicGlGS2lsMEVydW9rVU5Vb0tpZ292ZlVQVktEMm1EUzdyQXNmWkVBdyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czozOiJ1cmwiO2E6MDp7fXM6OToiX3ByZXZpb3VzIjthOjI6e3M6MzoidXJsIjtzOjIxOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAiO3M6NToicm91dGUiO3M6NDoiaG9tZSI7fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjQ7czoxNzoicGFzc3dvcmRfaGFzaF93ZWIiO3M6NjQ6IjE4YmNlNzY5ZDA2NzU0NWI1OWQwYzJiNzUzNzRlNzRmZmY1YmRhYjUyNDBkNmRhMTE5MzRiZTA4YjRjMGIwZDMiO30=', 1794209287),
('xqmPyN8xIkKjMOL2hLu5RQUMNecw6jtyopX7M1G4', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.143.1 Chrome/150.0.7871.250 Electron/43.7.7 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiajA0b3UxSjRTa25CbERzTEozSHNDWW56TWNLVTVSaEh5Q25ORlhNOCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1794206789);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','konsultan','user') NOT NULL DEFAULT 'user',
  `notification_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `role`, `notification_enabled`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'temueduadmin@gmail.com', '2026-10-21 01:42:18', '$2y$12$pqCUk0ReGTUpv5oHAeCNSuGdmzlDQVLgJGIHqttDiUcUnwQEPd34O', 'admin', 1, NULL, '2026-10-21 01:42:19', '2026-10-21 01:42:19'),
(2, 'Raka Saputra', 'raka.konsultan@temuedu.test', '2026-10-23 11:56:42', '$2y$12$OSHIxrczFy3KYf01kN30UOzNDdhm7bnnUSFTJJVmIjpYiO640.3g2', 'konsultan', 1, NULL, '2026-10-23 11:56:43', '2026-10-23 11:56:43'),
(3, 'Adit Pratama', 'adit.konsultan@temuedu.test', '2026-10-23 11:56:43', '$2y$12$HU212GQbOVexUi82PY/3A.uYW78YpTJU.1t522.FHFvcqs.PTi.1e', 'konsultan', 1, NULL, '2026-10-23 11:56:44', '2026-10-23 11:56:44'),
(4, 'Mahasiswa Demo', 'mahasiswa.demo@temuedu.test', '2026-10-23 11:56:44', '$2y$12$yBXw7gBby2UslO5tMS7JMuJz4T7W8RVzKQMcADKaX/JfW2orcDadS', 'user', 1, NULL, '2026-10-23 11:56:45', '2026-10-23 11:56:45'),
(5, 'Hadijah', 'hadijah.konsultan@gmail.com', '2026-10-24 05:15:03', '$2y$12$lj41TuI96GJ3VVupYRRBMu0Vu9qT35IARmHBsZB7846bCLRJqD3eG', 'konsultan', 1, NULL, '2026-10-24 05:15:03', '2026-10-24 05:15:03');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `appointments_consultation_id_foreign` (`consultation_id`),
  ADD KEY `appointments_schedule_id_foreign` (`schedule_id`),
  ADD KEY `appointments_consultant_id_status_index` (`consultant_id`,`status`),
  ADD KEY `appointments_user_id_status_index` (`user_id`,`status`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `consultants`
--
ALTER TABLE `consultants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `consultants_user_id_unique` (`user_id`),
  ADD KEY `consultants_prodi_id_foreign` (`prodi_id`);

--
-- Indexes for table `consultant_availabilities`
--
ALTER TABLE `consultant_availabilities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `consultant_availabilities_consultant_id_day_of_week_index` (`consultant_id`,`day_of_week`);

--
-- Indexes for table `consultant_schedules`
--
ALTER TABLE `consultant_schedules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `consultant_schedules_consultant_id_tanggal_jam_mulai_unique` (`consultant_id`,`tanggal`,`jam_mulai`);

--
-- Indexes for table `consultations`
--
ALTER TABLE `consultations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `consultations_prodi_id_foreign` (`prodi_id`),
  ADD KEY `consultations_user_id_status_index` (`user_id`,`status`),
  ADD KEY `consultations_consultant_id_status_index` (`consultant_id`,`status`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `messages_sender_id_foreign` (`sender_id`),
  ADD KEY `messages_consultation_id_created_at_index` (`consultation_id`,`created_at`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `payments_order_id_unique` (`order_id`),
  ADD KEY `payments_user_id_foreign` (`user_id`),
  ADD KEY `payments_consultant_id_foreign` (`consultant_id`),
  ADD KEY `payments_consultation_id_foreign` (`consultation_id`),
  ADD KEY `payments_appointment_id_foreign` (`appointment_id`),
  ADD KEY `payments_status_expires_at_index` (`status`,`expires_at`);

--
-- Indexes for table `prodis`
--
ALTER TABLE `prodis`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `prodis_nama_prodi_unique` (`nama_prodi`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reviews_consultation_id_unique` (`consultation_id`),
  ADD KEY `reviews_user_id_foreign` (`user_id`),
  ADD KEY `reviews_consultant_id_foreign` (`consultant_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `consultants`
--
ALTER TABLE `consultants`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `consultant_availabilities`
--
ALTER TABLE `consultant_availabilities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `consultant_schedules`
--
ALTER TABLE `consultant_schedules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `consultations`
--
ALTER TABLE `consultations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `prodis`
--
ALTER TABLE `prodis`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_consultant_id_foreign` FOREIGN KEY (`consultant_id`) REFERENCES `consultants` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `appointments_consultation_id_foreign` FOREIGN KEY (`consultation_id`) REFERENCES `consultations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `appointments_schedule_id_foreign` FOREIGN KEY (`schedule_id`) REFERENCES `consultant_schedules` (`id`),
  ADD CONSTRAINT `appointments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `consultants`
--
ALTER TABLE `consultants`
  ADD CONSTRAINT `consultants_prodi_id_foreign` FOREIGN KEY (`prodi_id`) REFERENCES `prodis` (`id`),
  ADD CONSTRAINT `consultants_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `consultant_availabilities`
--
ALTER TABLE `consultant_availabilities`
  ADD CONSTRAINT `consultant_availabilities_consultant_id_foreign` FOREIGN KEY (`consultant_id`) REFERENCES `consultants` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `consultant_schedules`
--
ALTER TABLE `consultant_schedules`
  ADD CONSTRAINT `consultant_schedules_consultant_id_foreign` FOREIGN KEY (`consultant_id`) REFERENCES `consultants` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `consultations`
--
ALTER TABLE `consultations`
  ADD CONSTRAINT `consultations_consultant_id_foreign` FOREIGN KEY (`consultant_id`) REFERENCES `consultants` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `consultations_prodi_id_foreign` FOREIGN KEY (`prodi_id`) REFERENCES `prodis` (`id`),
  ADD CONSTRAINT `consultations_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_consultation_id_foreign` FOREIGN KEY (`consultation_id`) REFERENCES `consultations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `messages_sender_id_foreign` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_appointment_id_foreign` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `payments_consultant_id_foreign` FOREIGN KEY (`consultant_id`) REFERENCES `consultants` (`id`),
  ADD CONSTRAINT `payments_consultation_id_foreign` FOREIGN KEY (`consultation_id`) REFERENCES `consultations` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `payments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_consultant_id_foreign` FOREIGN KEY (`consultant_id`) REFERENCES `consultants` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_consultation_id_foreign` FOREIGN KEY (`consultation_id`) REFERENCES `consultations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
