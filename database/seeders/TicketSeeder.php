<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Ticket;
use App\Models\Category;
use Illuminate\Database\Seeder;

class TicketSeeder extends Seeder
{
    public function run(): void
    {
        if (Ticket::query()->exists()) {
            $this->command->info('Data tiket sudah ada, seeder tiket dilewati.');
            return;
        }

        // [!] Data user pembuat laporan (harus sudah ada di database)
        $users = User::where('role', 'user')->get();
        if ($users->isEmpty()) {
            $this->command->warn('⚠️ Tidak ada user dengan role "user". Buat user dulu!');
            return;
        }

        // [!] Kategori
        $categories = Category::all();
        if ($categories->isEmpty()) {
            $this->command->warn('⚠️ Tidak ada kategori. Buat kategori dulu!');
            return;
        }

        // [!] Data variasi
        $titles = [
            // Fasilitas
            'Kursi rusak di laboratorium komputer',
            'AC mati di ruang kelas 101',
            'Pintu toilet tidak bisa ditutup',
            'Lampu di perpustakaan mati',
            'Tangga gedung timur berbahaya',
            'Meja kantor retak',
            'Proyektor tidak berfungsi',
            'Papan tulis kotor',
            'Tempat sampah penuh',
            'Kunci ruang kelas hilang',

            // Komdis (Bullying, Pelecehan)
            'Bullying di kelas A',
            'Pelecehan verbal dari senior',
            'Diskriminasi saat seleksi',
            'Ejekan terhadap penampilan',
            'Isolasi sosial oleh teman sekelas',
            'Ancaman dari mahasiswa senior',
            'Perlakuan tidak adil dari dosen',
            'Pengucilan dalam kelompok',
            'Hinaan di media sosial',
            'Agresi fisik dari temannya',

            // Laboratorium
            'Alat lab tidak berfungsi dengan baik',
            'Bahan kimia lab habis',
            'Komputer lab rusak',
            'Printer lab error',
            'Jaringan internet lab lambat',
            'Peralatan microscope tidak akurat',
            'Reaktan lab expired',
            'Sistem database lab down',
            'Software lab tidak terupdate',
            'Hardware lab perlu maintenance',

            // Akademik (KKN, Nilai)
            'Nilai KKN belum diumumkan',
            'Masalah dengan pembimbing KKN',
            'Penghitungan nilai tidak transparan',
            'Nilai ujian terasa tidak adil',
            'Kesalahan input nilai semester',
            'Perselisihan dengan dosen pembimbing',
            'Masalah jadwal KKN bentrok',
            'Nilai praktikum tidak sesuai harapan',
            'Permintaan revisi nilai',
            'Beasiswa tertunda karena nilai',

            // Tambahan variasi lainnya
            'Listrik padam saat kuliah',
            'Masalah dengan sistem akademik',
            'Ruang kelas tidak tersedia',
            'Asisten lab tidak profesional',
            'Tugas KKN tidak jelas',
            'Dosen tidak datang ke kelas',
            'Sistem presensi error',
            'Perpanjangan KKN diperlukan',
            'Masalah dengan dokumentasi akademik',
            'Sertifikat KKN belum dikirim',
        ];

        $descriptions = [
            'Fasilitas sudah rusak sejak awal semester dan belum diperbaiki',
            'Masalah ini mengganggu proses belajar mengajar',
            'Perlu perhatian segera untuk kenyamanan pengguna',
            'Sudah melaporkan berkali-kali tapi belum ada tindakan',
            'Kondisi sangat mempengaruhi kualitas pembelajaran',
            'Mohon segera ditangani oleh pihak terkait',
            'Ini sudah menjadi masalah berulang setiap semester',
            'Kami merasa keberatan dengan situasi ini',
            'Perlu solusi cepat untuk efisiensi kerja',
            'Harap segera diperiksa dan diperbaiki',
            'Situasi ini sangat mengganggu',
            'Sudah cukup lama masalah ini belum teratasi',
            'Kami membutuhkan bantuan segera',
            'Ini berdampak pada produktivitas kami',
            'Mohon untuk ditindaklanjuti dengan serius',
        ];

        $priorities = ['low', 'medium', 'high'];

        // [!] Generate 100 tiket
        for ($i = 1; $i <= 100; $i++) {
            // Random user pembuat laporan
            $user = $users->random();
            
            // Random kategori
            $category = $categories->random();
            
            // Random priority
            $priority = $priorities[array_rand($priorities)];
            
            // Random tanggal (Feb 2026 sampai sekarang)
            $randomDate = now()->subDays(rand(0, 110))->startOfDay()->addHours(rand(6, 22))->addMinutes(rand(0, 59));
            if ($randomDate->month < 2 || ($randomDate->month == 2 && $randomDate->day < 1)) {
                $randomDate = $randomDate->setDate(2026, 2, rand(1, 28));
            }

            // Random status
            $statuses = ['open', 'onprogress', 'resolved', 'rejected'];
            $status = $statuses[array_rand($statuses)];

            Ticket::create([
                'user_id' => $user->id,
                'code' => 'TIC-DHH-' . rand(10000, 99999),
                'title' => $titles[array_rand($titles)] . ' #' . $i,
                'description' => $descriptions[array_rand($descriptions)],
                'category_id' => $category->id,
                'priority' => $priority,
                'status' => $status,
                'attachment' => null, // Opsional
                'created_at' => $randomDate,
                'updated_at' => $randomDate,
                'completed_at' => $status === 'resolved' ? $randomDate->addDays(rand(1, 7)) : null,
            ]);
        }

        $this->command->info('✅ 100 tiket dummy berhasil dibuat!');
    }
}
