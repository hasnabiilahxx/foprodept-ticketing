<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        foreach (['Laboratorium', 'Komdis', 'Akademik', 'Fasilitas'] as $name) {
            \App\Models\Category::firstOrCreate(['name' => $name]);
        }
    }
}
