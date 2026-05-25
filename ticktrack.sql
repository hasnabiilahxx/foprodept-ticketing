-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 21, 2026 at 09:41 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ticktrack`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'Laboratorium', NULL, NULL),
(2, 'Komdis', NULL, NULL),
(3, 'Akademik', NULL, NULL),
(4, 'Fasilitas', NULL, NULL);

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
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2025_10_23_162413_create_tickets_table', 1),
(6, '2025_10_26_141448_create_ticket_replies_table', 1),
(7, '2026_04_12_174518_create_categories_table', 1),
(8, '2026_04_12_174659_add_category_id_to_tickets_table', 1),
(9, '2026_04_17_112727_add_attachment_to_tickets_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'auth_token', '576f32558ef39f8f92636b4f53582d009135673f9ab09698cd48c950c033dee2', '[\"*\"]', '2026-05-20 23:22:27', NULL, '2026-05-20 23:00:12', '2026-05-20 23:22:27'),
(2, 'App\\Models\\User', 2, 'auth_token', 'def01d81478cba37ad560e85306bdaccce9628c9f1a8a62664f9d99f4f54ba01', '[\"*\"]', '2026-05-20 23:04:58', NULL, '2026-05-20 23:01:14', '2026-05-20 23:04:58');

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE `tickets` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `code` varchar(255) NOT NULL,
  `title` text NOT NULL,
  `description` longtext NOT NULL,
  `status` enum('open','onprogress','resolved','rejected') NOT NULL DEFAULT 'open',
  `priority` enum('low','medium','high') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `attachment` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tickets`
--

INSERT INTO `tickets` (`id`, `user_id`, `code`, `title`, `description`, `status`, `priority`, `created_at`, `updated_at`, `completed_at`, `category_id`, `attachment`) VALUES
(1, 5, 'TIC-DHH-77778', 'Lampu di perpustakaan mati #1', 'Sudah melaporkan berkali-kali tapi belum ada tindakan', 'onprogress', 'medium', '2026-03-23 13:39:00', '2026-03-23 13:39:00', NULL, 2, NULL),
(2, 2, 'TIC-DHH-30105', 'Lampu di perpustakaan mati #2', 'Ini berdampak pada produktivitas kami', 'onprogress', 'high', '2026-05-15 08:42:00', '2026-05-15 08:42:00', NULL, 1, NULL),
(3, 5, 'TIC-DHH-97055', 'Agresi fisik dari temannya #3', 'Kami membutuhkan bantuan segera', 'onprogress', 'low', '2026-04-16 04:48:00', '2026-04-16 04:48:00', NULL, 2, NULL),
(4, 3, 'TIC-DHH-25761', 'Kunci ruang kelas hilang #4', 'Kondisi sangat mempengaruhi kualitas pembelajaran', 'open', 'medium', '2026-03-01 06:40:00', '2026-03-01 06:40:00', NULL, 4, NULL),
(5, 4, 'TIC-DHH-87222', 'Peralatan microscope tidak akurat #5', 'Mohon untuk ditindaklanjuti dengan serius', 'rejected', 'high', '2026-03-27 03:23:00', '2026-03-27 03:23:00', NULL, 1, NULL),
(6, 4, 'TIC-DHH-69615', 'Ejekan terhadap penampilan #6', 'Kami merasa keberatan dengan situasi ini', 'resolved', 'high', '2026-03-05 08:30:00', '2026-03-05 08:30:00', '2026-03-05 08:30:00', 3, NULL),
(7, 5, 'TIC-DHH-44920', 'Pengucilan dalam kelompok #7', 'Mohon segera ditangani oleh pihak terkait', 'rejected', 'medium', '2026-05-21 00:04:00', '2026-05-21 00:04:00', NULL, 3, NULL),
(8, 4, 'TIC-DHH-45864', 'Pintu toilet tidak bisa ditutup #8', 'Perlu solusi cepat untuk efisiensi kerja', 'resolved', 'low', '2026-04-21 11:13:00', '2026-04-21 11:13:00', '2026-04-21 11:13:00', 1, NULL),
(9, 4, 'TIC-DHH-82330', 'Peralatan microscope tidak akurat #9', 'Ini berdampak pada produktivitas kami', 'rejected', 'medium', '2026-04-07 07:28:00', '2026-04-07 07:28:00', NULL, 4, NULL),
(10, 2, 'TIC-DHH-71784', 'Nilai ujian terasa tidak adil #10', 'Mohon untuk ditindaklanjuti dengan serius', 'open', 'high', '2026-03-31 08:00:00', '2026-03-31 08:00:00', NULL, 3, NULL),
(11, 5, 'TIC-DHH-93835', 'Listrik padam saat kuliah #11', 'Ini berdampak pada produktivitas kami', 'resolved', 'high', '2026-05-11 11:57:00', '2026-05-11 11:57:00', '2026-05-11 11:57:00', 2, NULL),
(12, 2, 'TIC-DHH-76513', 'Nilai KKN belum diumumkan #12', 'Mohon untuk ditindaklanjuti dengan serius', 'resolved', 'high', '2026-02-08 05:59:00', '2026-02-08 05:59:00', '2026-02-08 05:59:00', 3, NULL),
(13, 2, 'TIC-DHH-55869', 'Sertifikat KKN belum dikirim #13', 'Kami membutuhkan bantuan segera', 'open', 'medium', '2026-02-07 14:35:00', '2026-02-07 14:35:00', NULL, 1, NULL),
(14, 3, 'TIC-DHH-83438', 'Peralatan microscope tidak akurat #14', 'Perlu perhatian segera untuk kenyamanan pengguna', 'open', 'low', '2026-03-11 15:06:00', '2026-03-11 15:06:00', NULL, 3, NULL),
(15, 3, 'TIC-DHH-35959', 'Pintu toilet tidak bisa ditutup #15', 'Sudah cukup lama masalah ini belum teratasi', 'rejected', 'low', '2026-03-27 01:16:00', '2026-03-27 01:16:00', NULL, 2, NULL),
(16, 2, 'TIC-DHH-26666', 'Tangga gedung timur berbahaya #16', 'Mohon segera ditangani oleh pihak terkait', 'resolved', 'high', '2026-03-15 12:23:00', '2026-03-15 12:23:00', '2026-03-15 12:23:00', 4, NULL),
(17, 5, 'TIC-DHH-63935', 'Beasiswa tertunda karena nilai #17', 'Situasi ini sangat mengganggu', 'open', 'medium', '2026-04-25 00:54:00', '2026-04-25 00:54:00', NULL, 3, NULL),
(18, 5, 'TIC-DHH-54139', 'Peralatan microscope tidak akurat #18', 'Harap segera diperiksa dan diperbaiki', 'resolved', 'medium', '2026-04-21 13:56:00', '2026-04-21 13:56:00', '2026-04-21 13:56:00', 4, NULL),
(19, 2, 'TIC-DHH-90393', 'Pelecehan verbal dari senior #19', 'Perlu perhatian segera untuk kenyamanan pengguna', 'resolved', 'medium', '2026-03-01 01:15:00', '2026-03-01 01:15:00', '2026-03-01 01:15:00', 3, NULL),
(20, 2, 'TIC-DHH-22936', 'Reaktan lab expired #20', 'Sudah melaporkan berkali-kali tapi belum ada tindakan', 'open', 'low', '2026-03-06 08:59:00', '2026-03-06 08:59:00', NULL, 3, NULL),
(21, 4, 'TIC-DHH-96320', 'Lampu di perpustakaan mati #21', 'Mohon untuk ditindaklanjuti dengan serius', 'open', 'medium', '2026-05-14 07:07:00', '2026-05-14 07:07:00', NULL, 2, NULL),
(22, 3, 'TIC-DHH-51016', 'Perpanjangan KKN diperlukan #22', 'Sudah cukup lama masalah ini belum teratasi', 'resolved', 'low', '2026-03-06 10:19:00', '2026-03-06 10:19:00', '2026-03-06 10:19:00', 4, NULL),
(23, 5, 'TIC-DHH-73760', 'Lampu di perpustakaan mati #23', 'Harap segera diperiksa dan diperbaiki', 'onprogress', 'high', '2026-03-01 00:49:00', '2026-03-01 00:49:00', NULL, 2, NULL),
(24, 4, 'TIC-DHH-63750', 'Papan tulis kotor #24', 'Perlu solusi cepat untuk efisiensi kerja', 'open', 'low', '2026-02-24 03:14:00', '2026-02-24 03:14:00', NULL, 3, NULL),
(25, 3, 'TIC-DHH-23678', 'Proyektor tidak berfungsi #25', 'Mohon segera ditangani oleh pihak terkait', 'onprogress', 'high', '2026-04-09 09:03:00', '2026-04-09 09:03:00', NULL, 1, NULL),
(26, 3, 'TIC-DHH-99424', 'Ejekan terhadap penampilan #26', 'Masalah ini mengganggu proses belajar mengajar', 'resolved', 'high', '2026-03-18 11:40:00', '2026-03-18 11:40:00', '2026-03-18 11:40:00', 2, NULL),
(27, 3, 'TIC-DHH-20972', 'Masalah dengan pembimbing KKN #27', 'Sudah cukup lama masalah ini belum teratasi', 'resolved', 'medium', '2026-02-12 06:45:00', '2026-02-12 06:45:00', '2026-02-12 06:45:00', 3, NULL),
(28, 2, 'TIC-DHH-71427', 'Hinaan di media sosial #28', 'Kami merasa keberatan dengan situasi ini', 'resolved', 'medium', '2026-02-23 03:45:00', '2026-02-23 03:45:00', '2026-02-23 03:45:00', 2, NULL),
(29, 3, 'TIC-DHH-98749', 'Bullying di kelas A #29', 'Kami membutuhkan bantuan segera', 'open', 'high', '2026-05-03 15:13:00', '2026-05-03 15:13:00', NULL, 4, NULL),
(30, 5, 'TIC-DHH-31811', 'Pengucilan dalam kelompok #30', 'Ini berdampak pada produktivitas kami', 'resolved', 'low', '2026-05-20 23:54:00', '2026-05-20 23:54:00', '2026-05-20 23:54:00', 1, NULL),
(31, 2, 'TIC-DHH-84918', 'Perpanjangan KKN diperlukan #31', 'Kondisi sangat mempengaruhi kualitas pembelajaran', 'onprogress', 'high', '2026-02-12 23:03:00', '2026-02-12 23:03:00', NULL, 4, NULL),
(32, 2, 'TIC-DHH-90149', 'Pengucilan dalam kelompok #32', 'Kondisi sangat mempengaruhi kualitas pembelajaran', 'onprogress', 'medium', '2026-05-18 06:47:00', '2026-05-18 06:47:00', NULL, 3, NULL),
(33, 5, 'TIC-DHH-10030', 'Reaktan lab expired #33', 'Masalah ini mengganggu proses belajar mengajar', 'resolved', 'high', '2026-02-26 00:32:00', '2026-02-26 00:32:00', '2026-02-26 00:32:00', 1, NULL),
(34, 5, 'TIC-DHH-51594', 'Jaringan internet lab lambat #34', 'Kondisi sangat mempengaruhi kualitas pembelajaran', 'resolved', 'high', '2026-04-11 02:08:00', '2026-04-11 02:08:00', '2026-04-11 02:08:00', 2, NULL),
(35, 5, 'TIC-DHH-21689', 'Masalah dengan pembimbing KKN #35', 'Mohon segera ditangani oleh pihak terkait', 'onprogress', 'low', '2026-05-19 15:10:00', '2026-05-19 15:10:00', NULL, 4, NULL),
(36, 3, 'TIC-DHH-38528', 'Listrik padam saat kuliah #36', 'Harap segera diperiksa dan diperbaiki', 'rejected', 'high', '2026-05-06 08:16:00', '2026-05-06 08:16:00', NULL, 2, NULL),
(37, 2, 'TIC-DHH-93069', 'Hardware lab perlu maintenance #37', 'Ini berdampak pada produktivitas kami', 'open', 'medium', '2026-05-17 03:46:00', '2026-05-17 03:46:00', NULL, 1, NULL),
(38, 5, 'TIC-DHH-98095', 'Papan tulis kotor #38', 'Perlu perhatian segera untuk kenyamanan pengguna', 'rejected', 'low', '2026-04-28 13:12:00', '2026-04-28 13:12:00', NULL, 4, NULL),
(39, 5, 'TIC-DHH-96048', 'Kursi rusak di laboratorium komputer #39', 'Sudah cukup lama masalah ini belum teratasi', 'open', 'medium', '2026-03-08 03:35:00', '2026-03-08 03:35:00', NULL, 1, NULL),
(40, 2, 'TIC-DHH-29762', 'Proyektor tidak berfungsi #40', 'Situasi ini sangat mengganggu', 'resolved', 'low', '2026-04-19 14:12:00', '2026-04-19 14:12:00', '2026-04-19 14:12:00', 3, NULL),
(41, 2, 'TIC-DHH-58671', 'Sistem database lab down #41', 'Perlu perhatian segera untuk kenyamanan pengguna', 'rejected', 'low', '2026-04-14 02:54:00', '2026-04-14 02:54:00', NULL, 4, NULL),
(42, 4, 'TIC-DHH-59072', 'Sistem database lab down #42', 'Harap segera diperiksa dan diperbaiki', 'onprogress', 'medium', '2026-03-15 06:06:00', '2026-03-15 06:06:00', NULL, 2, NULL),
(43, 2, 'TIC-DHH-81704', 'Printer lab error #43', 'Fasilitas sudah rusak sejak awal semester dan belum diperbaiki', 'resolved', 'high', '2026-05-06 10:39:00', '2026-05-06 10:39:00', '2026-05-06 10:39:00', 2, NULL),
(44, 4, 'TIC-DHH-75838', 'Permintaan revisi nilai #44', 'Kami membutuhkan bantuan segera', 'open', 'medium', '2026-02-07 15:58:00', '2026-02-07 15:58:00', NULL, 3, NULL),
(45, 3, 'TIC-DHH-62293', 'Tugas KKN tidak jelas #45', 'Mohon segera ditangani oleh pihak terkait', 'onprogress', 'medium', '2026-03-09 15:37:00', '2026-03-09 15:37:00', NULL, 4, NULL),
(46, 3, 'TIC-DHH-37485', 'Proyektor tidak berfungsi #46', 'Situasi ini sangat mengganggu', 'open', 'high', '2026-03-01 08:18:00', '2026-03-01 08:18:00', NULL, 4, NULL),
(47, 2, 'TIC-DHH-78348', 'Perselisihan dengan dosen pembimbing #47', 'Mohon segera ditangani oleh pihak terkait', 'onprogress', 'high', '2026-02-24 08:52:00', '2026-02-24 08:52:00', NULL, 1, NULL),
(48, 2, 'TIC-DHH-78685', 'Perpanjangan KKN diperlukan #48', 'Kami membutuhkan bantuan segera', 'rejected', 'low', '2026-04-19 09:10:00', '2026-04-19 09:10:00', NULL, 1, NULL),
(49, 5, 'TIC-DHH-98089', 'Jaringan internet lab lambat #49', 'Situasi ini sangat mengganggu', 'rejected', 'low', '2026-03-01 07:35:00', '2026-03-01 07:35:00', NULL, 3, NULL),
(50, 4, 'TIC-DHH-26134', 'Nilai ujian terasa tidak adil #50', 'Kami membutuhkan bantuan segera', 'onprogress', 'low', '2026-05-18 09:23:00', '2026-05-18 09:23:00', NULL, 4, NULL),
(51, 3, 'TIC-DHH-38784', 'Pengucilan dalam kelompok #51', 'Fasilitas sudah rusak sejak awal semester dan belum diperbaiki', 'resolved', 'medium', '2026-03-16 07:39:00', '2026-03-16 07:39:00', '2026-03-16 07:39:00', 2, NULL),
(52, 4, 'TIC-DHH-29996', 'Dosen tidak datang ke kelas #52', 'Kami membutuhkan bantuan segera', 'resolved', 'low', '2026-04-11 14:46:00', '2026-04-11 14:46:00', '2026-04-11 14:46:00', 1, NULL),
(53, 3, 'TIC-DHH-92940', 'Ejekan terhadap penampilan #53', 'Kondisi sangat mempengaruhi kualitas pembelajaran', 'onprogress', 'medium', '2026-05-04 09:44:00', '2026-05-04 09:44:00', NULL, 3, NULL),
(54, 4, 'TIC-DHH-15744', 'Diskriminasi saat seleksi #54', 'Fasilitas sudah rusak sejak awal semester dan belum diperbaiki', 'onprogress', 'low', '2026-03-06 07:20:00', '2026-03-06 07:20:00', NULL, 2, NULL),
(55, 2, 'TIC-DHH-10164', 'Nilai ujian terasa tidak adil #55', 'Kondisi sangat mempengaruhi kualitas pembelajaran', 'open', 'low', '2026-04-27 12:00:00', '2026-04-27 12:00:00', NULL, 2, NULL),
(56, 3, 'TIC-DHH-64581', 'Kunci ruang kelas hilang #56', 'Masalah ini mengganggu proses belajar mengajar', 'onprogress', 'low', '2026-05-21 15:06:00', '2026-05-21 15:06:00', NULL, 1, NULL),
(57, 3, 'TIC-DHH-83355', 'Ancaman dari mahasiswa senior #57', 'Situasi ini sangat mengganggu', 'onprogress', 'high', '2026-05-14 09:39:00', '2026-05-14 09:39:00', NULL, 2, NULL),
(58, 2, 'TIC-DHH-16778', 'Isolasi sosial oleh teman sekelas #58', 'Sudah cukup lama masalah ini belum teratasi', 'open', 'high', '2026-02-28 09:15:00', '2026-02-28 09:15:00', NULL, 4, NULL),
(59, 5, 'TIC-DHH-30404', 'Reaktan lab expired #59', 'Perlu perhatian segera untuk kenyamanan pengguna', 'open', 'high', '2026-05-09 08:49:00', '2026-05-09 08:49:00', NULL, 3, NULL),
(60, 3, 'TIC-DHH-40161', 'Kesalahan input nilai semester #60', 'Fasilitas sudah rusak sejak awal semester dan belum diperbaiki', 'open', 'medium', '2026-05-18 04:42:00', '2026-05-18 04:42:00', NULL, 2, NULL),
(61, 5, 'TIC-DHH-16397', 'Hinaan di media sosial #61', 'Mohon segera ditangani oleh pihak terkait', 'rejected', 'medium', '2026-02-10 02:11:00', '2026-02-10 02:11:00', NULL, 2, NULL),
(62, 3, 'TIC-DHH-74620', 'Alat lab tidak berfungsi dengan baik #62', 'Kondisi sangat mempengaruhi kualitas pembelajaran', 'open', 'low', '2026-04-16 04:23:00', '2026-04-16 04:23:00', NULL, 1, NULL),
(63, 2, 'TIC-DHH-52160', 'Perselisihan dengan dosen pembimbing #63', 'Fasilitas sudah rusak sejak awal semester dan belum diperbaiki', 'onprogress', 'low', '2026-04-19 13:07:00', '2026-04-19 13:07:00', NULL, 3, NULL),
(64, 2, 'TIC-DHH-50098', 'AC mati di ruang kelas 101 #64', 'Sudah cukup lama masalah ini belum teratasi', 'open', 'medium', '2026-02-25 10:07:00', '2026-02-25 10:07:00', NULL, 4, NULL),
(65, 3, 'TIC-DHH-23613', 'Pintu toilet tidak bisa ditutup #65', 'Masalah ini mengganggu proses belajar mengajar', 'onprogress', 'low', '2026-03-10 10:00:00', '2026-03-10 10:00:00', NULL, 2, NULL),
(66, 4, 'TIC-DHH-13955', 'Peralatan microscope tidak akurat #66', 'Sudah melaporkan berkali-kali tapi belum ada tindakan', 'onprogress', 'high', '2026-03-06 05:22:00', '2026-03-06 05:22:00', NULL, 3, NULL),
(67, 5, 'TIC-DHH-89132', 'Nilai ujian terasa tidak adil #67', 'Ini berdampak pada produktivitas kami', 'open', 'medium', '2026-04-02 15:17:00', '2026-04-02 15:17:00', NULL, 1, NULL),
(68, 3, 'TIC-DHH-41636', 'Penghitungan nilai tidak transparan #68', 'Kami merasa keberatan dengan situasi ini', 'rejected', 'low', '2026-03-31 12:09:00', '2026-03-31 12:09:00', NULL, 1, NULL),
(69, 2, 'TIC-DHH-72750', 'Nilai KKN belum diumumkan #69', 'Kondisi sangat mempengaruhi kualitas pembelajaran', 'rejected', 'medium', '2026-05-10 03:48:00', '2026-05-10 03:48:00', NULL, 3, NULL),
(70, 2, 'TIC-DHH-82418', 'Bullying di kelas A #70', 'Sudah cukup lama masalah ini belum teratasi', 'onprogress', 'high', '2026-04-10 15:18:00', '2026-04-10 15:18:00', NULL, 1, NULL),
(71, 5, 'TIC-DHH-69820', 'Perpanjangan KKN diperlukan #71', 'Masalah ini mengganggu proses belajar mengajar', 'rejected', 'medium', '2026-04-30 10:04:00', '2026-04-30 10:04:00', NULL, 4, NULL),
(72, 2, 'TIC-DHH-56722', 'Peralatan microscope tidak akurat #72', 'Ini berdampak pada produktivitas kami', 'onprogress', 'medium', '2026-04-18 15:20:00', '2026-04-18 15:20:00', NULL, 1, NULL),
(73, 5, 'TIC-DHH-65464', 'Kesalahan input nilai semester #73', 'Situasi ini sangat mengganggu', 'onprogress', 'medium', '2026-02-07 05:39:00', '2026-02-07 05:39:00', NULL, 1, NULL),
(74, 5, 'TIC-DHH-29788', 'Diskriminasi saat seleksi #74', 'Kami merasa keberatan dengan situasi ini', 'rejected', 'high', '2026-05-05 01:52:00', '2026-05-05 01:52:00', NULL, 1, NULL),
(75, 5, 'TIC-DHH-32161', 'Perlakuan tidak adil dari dosen #75', 'Masalah ini mengganggu proses belajar mengajar', 'open', 'high', '2026-05-05 14:37:00', '2026-05-05 14:37:00', NULL, 4, NULL),
(76, 4, 'TIC-DHH-42066', 'Lampu di perpustakaan mati #76', 'Kami membutuhkan bantuan segera', 'rejected', 'medium', '2026-05-09 15:36:00', '2026-05-09 15:36:00', NULL, 4, NULL),
(77, 2, 'TIC-DHH-60576', 'Tugas KKN tidak jelas #77', 'Kami membutuhkan bantuan segera', 'open', 'low', '2026-02-25 02:42:00', '2026-02-25 02:42:00', NULL, 4, NULL),
(78, 2, 'TIC-DHH-16555', 'Masalah dengan sistem akademik #78', 'Harap segera diperiksa dan diperbaiki', 'open', 'medium', '2026-02-21 12:59:00', '2026-02-21 12:59:00', NULL, 4, NULL),
(79, 3, 'TIC-DHH-59452', 'Komputer lab rusak #79', 'Sudah melaporkan berkali-kali tapi belum ada tindakan', 'rejected', 'high', '2026-03-16 00:05:00', '2026-03-16 00:05:00', NULL, 2, NULL),
(80, 3, 'TIC-DHH-33990', 'Permintaan revisi nilai #80', 'Kami membutuhkan bantuan segera', 'onprogress', 'medium', '2026-04-10 13:34:00', '2026-04-10 13:34:00', NULL, 2, NULL),
(81, 5, 'TIC-DHH-86030', 'Kunci ruang kelas hilang #81', 'Kondisi sangat mempengaruhi kualitas pembelajaran', 'open', 'high', '2026-03-12 08:01:00', '2026-03-12 08:01:00', NULL, 3, NULL),
(82, 2, 'TIC-DHH-48532', 'Jaringan internet lab lambat #82', 'Fasilitas sudah rusak sejak awal semester dan belum diperbaiki', 'onprogress', 'medium', '2026-03-29 05:49:00', '2026-03-29 05:49:00', NULL, 3, NULL),
(83, 2, 'TIC-DHH-28560', 'Asisten lab tidak profesional #83', 'Kondisi sangat mempengaruhi kualitas pembelajaran', 'rejected', 'high', '2026-04-06 04:42:00', '2026-04-06 04:42:00', NULL, 1, NULL),
(84, 5, 'TIC-DHH-60549', 'Alat lab tidak berfungsi dengan baik #84', 'Mohon segera ditangani oleh pihak terkait', 'resolved', 'high', '2026-04-30 23:45:00', '2026-04-30 23:45:00', '2026-04-30 23:45:00', 1, NULL),
(85, 5, 'TIC-DHH-76548', 'Ejekan terhadap penampilan #85', 'Fasilitas sudah rusak sejak awal semester dan belum diperbaiki', 'rejected', 'high', '2026-04-11 14:15:00', '2026-04-11 14:15:00', NULL, 4, NULL),
(86, 2, 'TIC-DHH-38400', 'Nilai KKN belum diumumkan #86', 'Perlu solusi cepat untuk efisiensi kerja', 'open', 'medium', '2026-02-02 10:05:00', '2026-02-02 10:05:00', NULL, 2, NULL),
(87, 3, 'TIC-DHH-66191', 'Sertifikat KKN belum dikirim #87', 'Kami membutuhkan bantuan segera', 'rejected', 'high', '2026-04-30 08:32:00', '2026-04-30 08:32:00', NULL, 3, NULL),
(88, 5, 'TIC-DHH-28922', 'Sistem presensi error #88', 'Ini sudah menjadi masalah berulang setiap semester', 'resolved', 'low', '2026-03-06 08:41:00', '2026-03-06 08:41:00', '2026-03-06 08:41:00', 2, NULL),
(89, 4, 'TIC-DHH-61166', 'Meja kantor retak #89', 'Mohon untuk ditindaklanjuti dengan serius', 'onprogress', 'low', '2026-04-30 08:41:00', '2026-04-30 08:41:00', NULL, 2, NULL),
(90, 5, 'TIC-DHH-66475', 'Masalah dengan sistem akademik #90', 'Sudah melaporkan berkali-kali tapi belum ada tindakan', 'rejected', 'low', '2026-02-14 11:35:00', '2026-02-14 11:35:00', NULL, 2, NULL),
(91, 3, 'TIC-DHH-19476', 'Permintaan revisi nilai #91', 'Kami membutuhkan bantuan segera', 'open', 'medium', '2026-05-13 03:14:00', '2026-05-13 03:14:00', NULL, 2, NULL),
(92, 4, 'TIC-DHH-78301', 'Kesalahan input nilai semester #92', 'Perlu perhatian segera untuk kenyamanan pengguna', 'resolved', 'low', '2026-05-08 00:25:00', '2026-05-08 00:25:00', '2026-05-08 00:25:00', 3, NULL),
(93, 5, 'TIC-DHH-18784', 'Agresi fisik dari temannya #93', 'Situasi ini sangat mengganggu', 'onprogress', 'medium', '2026-02-27 06:01:00', '2026-02-27 06:01:00', NULL, 1, NULL),
(94, 4, 'TIC-DHH-79159', 'Sertifikat KKN belum dikirim #94', 'Sudah melaporkan berkali-kali tapi belum ada tindakan', 'resolved', 'low', '2026-03-07 15:38:00', '2026-03-07 15:38:00', '2026-03-07 15:38:00', 4, NULL),
(95, 4, 'TIC-DHH-81661', 'Software lab tidak terupdate #95', 'Sudah melaporkan berkali-kali tapi belum ada tindakan', 'resolved', 'high', '2026-02-12 14:23:00', '2026-02-12 14:23:00', '2026-02-12 14:23:00', 3, NULL),
(96, 4, 'TIC-DHH-73694', 'Ancaman dari mahasiswa senior #96', 'Ini sudah menjadi masalah berulang setiap semester', 'open', 'high', '2026-04-21 23:07:00', '2026-04-21 23:07:00', NULL, 3, NULL),
(97, 4, 'TIC-DHH-34189', 'Alat lab tidak berfungsi dengan baik #97', 'Kondisi sangat mempengaruhi kualitas pembelajaran', 'open', 'high', '2026-05-08 01:05:00', '2026-05-08 01:05:00', NULL, 3, NULL),
(98, 3, 'TIC-DHH-37593', 'Isolasi sosial oleh teman sekelas #98', 'Kami membutuhkan bantuan segera', 'onprogress', 'medium', '2026-04-30 03:59:00', '2026-04-30 03:59:00', NULL, 4, NULL),
(99, 3, 'TIC-DHH-56659', 'Alat lab tidak berfungsi dengan baik #99', 'Perlu solusi cepat untuk efisiensi kerja', 'onprogress', 'high', '2026-04-22 01:52:00', '2026-04-22 01:52:00', NULL, 4, NULL),
(100, 5, 'TIC-DHH-36496', 'Ancaman dari mahasiswa senior #100', 'Ini sudah menjadi masalah berulang setiap semester', 'rejected', 'low', '2026-04-21 13:27:00', '2026-04-21 13:27:00', NULL, 4, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `ticket_replies`
--

CREATE TABLE `ticket_replies` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `ticket_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `content` longtext NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ticket_replies`
--

INSERT INTO `ticket_replies` (`id`, `ticket_id`, `user_id`, `content`, `created_at`, `updated_at`) VALUES
(1, 64, 1, 'haloo kenapa ya ini', '2026-05-20 23:00:50', '2026-05-20 23:00:50'),
(2, 64, 2, 'halo pak, ini ac mati dr kmrin pak', '2026-05-20 23:01:45', '2026-05-20 23:01:45'),
(3, 64, 1, 'baik kami akan kirimkan servis ya terimakasih atas laporannya', '2026-05-20 23:02:12', '2026-05-20 23:02:12');

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
  `role` enum('user','admin') NOT NULL DEFAULT 'user',
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `role`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'admin@ticktrack.com', '2026-05-20 22:59:57', '$2y$10$XwwQFtbV2jyRqJzNhQDUDu1PijRDp0V.YTyyFTOVT4ecDgR7GssaC', 'admin', NULL, '2026-05-20 22:59:57', '2026-05-20 22:59:57'),
(2, 'Hasna Nabilah', 'hasna@apps.ipb.ac.id', '2026-05-20 22:59:57', '$2y$10$Gh4135xjO8s5LPyHCw6Uxe3PKCuxvqDKRgSVNBMwilPbVUOLRnQc6', 'user', NULL, '2026-05-20 22:59:57', '2026-05-20 22:59:57'),
(3, 'Harris Caine', 'harris@apps.ipb.ac.id', '2026-05-20 22:59:57', '$2y$10$BOt32wEp6CrGqcbV4rsL2OHWBtLPXGwMqRURDC0jTVwXsAUvRsspS', 'user', NULL, '2026-05-20 22:59:57', '2026-05-20 22:59:57'),
(4, 'Dirly', 'dirly@apps.ipb.ac.id', '2026-05-20 22:59:57', '$2y$10$qa/TBZXTqdNEBNJXHyF6e.wIncQd79wemMwqX5iLr/r93TIHxBkV.', 'user', NULL, '2026-05-20 22:59:57', '2026-05-20 22:59:57'),
(5, 'Najla Fadhilah', 'najla@apps.ipb.ac.id', '2026-05-20 22:59:57', '$2y$10$tmBqkOxDT6IZHcHuILloZuMthFtAXK4VeR8s71QpVPzsqgh5Nu.3G', 'user', NULL, '2026-05-20 22:59:57', '2026-05-20 22:59:57');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tickets_code_unique` (`code`),
  ADD KEY `tickets_user_id_foreign` (`user_id`),
  ADD KEY `tickets_category_id_foreign` (`category_id`);

--
-- Indexes for table `ticket_replies`
--
ALTER TABLE `ticket_replies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ticket_replies_ticket_id_foreign` (`ticket_id`),
  ADD KEY `ticket_replies_user_id_foreign` (`user_id`);

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
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT for table `ticket_replies`
--
ALTER TABLE `ticket_replies`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tickets`
--
ALTER TABLE `tickets`
  ADD CONSTRAINT `tickets_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tickets_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `ticket_replies`
--
ALTER TABLE `ticket_replies`
  ADD CONSTRAINT `ticket_replies_ticket_id_foreign` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`),
  ADD CONSTRAINT `ticket_replies_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
