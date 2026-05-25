<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {

        $users = [
            ['name' => 'Admin', 'email' => 'admin@ticktrack.com', 'password' => 'password', 'role' => 'admin'],
            ['name' => 'Hasna Nabilah', 'email' => 'hasna@apps.ipb.ac.id', 'password' => '123456', 'role' => 'user'],
            ['name' => 'Harris Caine', 'email' => 'harris@apps.ipb.ac.id', 'password' => '123456', 'role' => 'user'],
            ['name' => 'Dirly', 'email' => 'dirly@apps.ipb.ac.id', 'password' => '123456', 'role' => 'user'],
            ['name' => 'Najla Fadhilah', 'email' => 'najla@apps.ipb.ac.id', 'password' => '123456', 'role' => 'user'],
        ];

        foreach ($users as $user) {
            User::updateOrCreate(
                ['email' => $user['email']],
                [
                    'name' => $user['name'],
                    'password' => bcrypt($user['password']),
                    'role' => $user['role'],
                    'email_verified_at' => now(),
                ]
            );
        }

        $this->call([
            CategorySeeder::class,
        ]);


        $this->call([
            TicketSeeder::class,
        ]);
    }
}
