<script setup>
import { onMounted, ref, watch } from 'vue'
import { useTicketStore } from '@/stores/ticket'
import { storeToRefs } from 'pinia'
import { capitalize, debounce } from 'lodash'
import feather from 'feather-icons'
import { DateTime } from 'luxon'

//definisi ticket store
const ticketStore = useTicketStore()
const { tickets, categories, pagination } = storeToRefs(ticketStore)
const { fetchTickets } = ticketStore

// TODO: Create filters ref with search fields
// Hint: You'll need search, status, priority, and date
const filters = ref({
    search: '',
    status: '',
    category_id: '',
    priority: '',
    date: '',
    month: '',
    year: '',
})

// fungsi pindah halaman
const goToPage = async (page) => {
    if (page < 1 || page > pagination.value.last_page) return
    await fetchTickets({ ...filters.value, page })
}

const currentYear = new Date().getFullYear()

const years = Array.from({ length: 5 }, (_, i) => currentYear - i)

// implementasi watch buat filternya
watch(filters, debounce(async () => {
    await fetchTickets({ ...filters.value, page: 1 })
}, 300), { deep: true })

// TODO: Implement onMounted hook
// Hint: Fetch initial tickets and initialize feather icons

onMounted(async () => {
    const now = new Date()

    filters.value.year = now.getFullYear()

    await fetchTickets()
    await ticketStore.fetchCategories()

    console.log('categories FE:', categories.value)

    feather.replace()
})


</script>

<template>
    <div class="p-6">
        <!-- Filters and Actions -->
<div class="bg-white rounded-xl shadow-sm border border-gray-100 mb-6">
    <div class="p-6 space-y-4">

        <!-- Search + Month + Year -->
        <div class="flex flex-col lg:flex-row gap-4 justify-between">

            <!-- Search -->
            <div class="relative w-full lg:w-1/5">
                <input 
                    type="text" 
                    v-model="filters.search" 
                    placeholder="Cari tiket..."
                    class="w-full pl-10 pr-4 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
                >
                <i data-feather="search" class="w-4 h-4 text-gray-400 absolute left-3 top-2.5"></i>
            </div>

            <!-- Year -->
            <div class="flex gap-4 w-full lg:w-auto">
                <!-- Year -->
                <select v-model="filters.year"
                    class="border border-gray-200 rounded-lg px-4 py-2 text-sm">
                    <option value="">Semua Tahun</option>
                    <option v-for="y in years" :key="y" :value="y">
                        {{ y }}
                    </option>
                </select>

            </div>
        </div>

        <!-- 🎯 Filters -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">

            <!-- Status -->
            <select v-model="filters.status"
                class="border border-gray-200 rounded-lg px-4 py-2 text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500">
                <option value="">Semua Status</option>
                <option value="open">Open</option>
                <option value="onprogress">On Progress</option>
                <option value="resolved">Resolved</option>
                <option value="rejected">Rejected</option>
            </select>

            <!-- Category -->
            <select v-model="filters.category_id"
                class="border border-gray-200 rounded-lg px-4 py-2 text-sm">
                <option value="">Semua Kategori</option>
                <option 
                    v-for="cat in categories" 
                    :key="cat.id" 
                    :value="cat.id">
                    {{ cat.name }}
                </option>
            </select>

            <!-- Priority -->
            <select v-model="filters.priority"
                class="border border-gray-200 rounded-lg px-4 py-2 text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500">
                <option value="">Semua Prioritas</option>
                <option value="high">High</option>
                <option value="medium">Medium</option>
                <option value="low">Low</option>
            </select>

            <!-- Month -->
                <select v-model="filters.month"
                    class="border border-gray-200 rounded-lg px-4 py-2 text-sm">
                    <option value="">Semua Bulan</option>
                    <option value="1">Januari</option>
                    <option value="2">Februari</option>
                    <option value="3">Maret</option>
                    <option value="4">April</option>
                    <option value="5">Mei</option>
                    <option value="6">Juni</option>
                    <option value="7">Juli</option>
                    <option value="8">Agustus</option>
                    <option value="9">September</option>
                    <option value="10">Oktober</option>
                    <option value="11">November</option>
                    <option value="12">Desember</option>
                </select>
            <!-- Date
            <select v-model="filters.date"
                class="border border-gray-200 rounded-lg px-4 py-2 text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500">
                <option value="">Semua Tanggal</option>
                <option value="today">Hari Ini</option>
                <option value="week">Minggu Ini</option>
                <option value="month">Bulan Ini</option>
            </select> -->
        </div>
    </div>
</div>

        <!-- Tickets Table -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-100">
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50">
                        <tr>
                            <!-- [!] SEMUA HEADER JADI CLICKABLE -->
                            
                            <!-- ID Tiket -->
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                                @click="ticketStore.setSortBy('code')">
                                <div class="flex items-center gap-2">
                                    <span>ID Tiket</span>
                                    <!-- Sort indicator -->
                                    <span v-if="ticketStore.sortBy === 'code'" class="text-blue-600 font-bold">
                                        {{ ticketStore.sortOrder === 'asc' ? '↑' : '↓' }}
                                    </span>
                                    <span v-else class="text-gray-300">⇅</span>
                                </div>
                            </th>

                            <!-- Judul -->
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                                @click="ticketStore.setSortBy('title')">
                                <div class="flex items-center gap-2">
                                    <span>Judul</span>
                                    <span v-if="ticketStore.sortBy === 'title'" class="text-blue-600 font-bold">
                                        {{ ticketStore.sortOrder === 'asc' ? '↑' : '↓' }}
                                    </span>
                                    <span v-else class="text-gray-300">⇅</span>
                                </div>
                            </th>

                            <!-- Pelapor (tidak sortable) -->
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Pelapor
                            </th>

                            <!-- Status -->
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                                @click="ticketStore.setSortBy('status')">
                                <div class="flex items-center gap-2">
                                    <span>Status</span>
                                    <span v-if="ticketStore.sortBy === 'status'" class="text-blue-600 font-bold">
                                        {{ ticketStore.sortOrder === 'asc' ? '↑' : '↓' }}
                                    </span>
                                    <span v-else class="text-gray-300">⇅</span>
                                </div>
                            </th>

                            <!-- Kategori (tidak sortable karena join) -->
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Kategori
                            </th>

                            <!-- Prioritas -->
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                                @click="ticketStore.setSortBy('priority')">
                                <div class="flex items-center gap-2">
                                    <span>Prioritas</span>
                                    <span v-if="ticketStore.sortBy === 'priority'" class="text-blue-600 font-bold">
                                        {{ ticketStore.sortOrder === 'asc' ? '↑' : '↓' }}
                                    </span>
                                    <span v-else class="text-gray-300">⇅</span>
                                </div>
                            </th>

                            <!-- Tanggal -->
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                                @click="ticketStore.setSortBy('created_at')">
                                <div class="flex items-center gap-2">
                                    <span>Tanggal</span>
                                    <span v-if="ticketStore.sortBy === 'created_at'" class="text-blue-600 font-bold">
                                        {{ ticketStore.sortOrder === 'asc' ? '↑' : '↓' }}
                                    </span>
                                    <span v-else class="text-gray-300">⇅</span>
                                </div>
                            </th>

                            <!-- Aksi (tidak sortable) -->
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Aksi
                            </th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-100">
                        <tr v-for="ticket in tickets" :key="ticket.code" class="hover:bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-blue-600">
                                #{{ ticket.code }}</td>
                            <td class="px-6 py-4">
                                <div class="text-sm text-gray-800">{{ ticket.title }}</div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="flex items-center">
                                    <img :src="`https://ui-avatars.com/api/?name=${ticket.user.name}&background=0D8ABC&color=fff`"
                                        :alt="ticket.user.name" class="w-6 h-6 rounded-full">
                                    <span class="ml-2 text-sm text-gray-800">{{ ticket.user.name }}</span>
                                </div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-3 py-1 text-xs font-medium rounded-full" :class="{
                                    'text-blue-700 bg-blue-100': ticket.status === 'open',
                                    'text-yellow-700 bg-yellow-100': ticket.status === 'onprogress',
                                    'text-green-700 bg-green-100': ticket.status === 'resolved',
                                    'text-red-700 bg-red-100': ticket.status === 'rejected'
                                }">
                                    {{ capitalize(ticket.status) }}
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-3 py-1 text-xs font-medium rounded-full" :class="{
                                    'text-blue-700 bg-blue-100': ticket.category?.name === 'Laboratorium',
                                    'text-red-700 bg-red-100': ticket.category?.name === 'Komdis',
                                    'text-violet-700 bg-violet-100': ticket.category?.name === 'Akademik',
                                    'text-yellow-700 bg-yellow-100': ticket.category?.name === 'Fasilitas',
                                }">
                                    {{ ticket.category?.name || '-' }}
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-3 py-1 text-xs font-medium rounded-full" :class="{
                                    'text-red-700 bg-red-100': ticket.priority === 'high',
                                    'text-yellow-700 bg-yellow-100': ticket.priority === 'medium',
                                    'text-green-700 bg-green-100': ticket.priority === 'low'
                                }">
                                    {{ capitalize(ticket.priority) }}
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                                {{ DateTime.fromISO(ticket.created_at).toFormat('dd MMMM yyyy HH:mm') }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm">
                                <RouterLink :to="{ name: 'admin.ticket.detail', params: { code: ticket.code } }"
                                    class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                                    <i data-feather="message-square" class="w-4 h-4 mr-2"></i>
                                    Jawab
                                </RouterLink>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- Pagination -->
            <div class="px-4 lg:px-6 py-4 border-t border-gray-100 flex flex-col lg:flex-row items-center justify-between gap-4">
                
                <!-- Info — pindah ke atas di mobile -->
                <p class="text-xs lg:text-sm text-gray-500 order-1 lg:order-2">
                    Menampilkan {{ tickets.length }} dari {{ pagination.total }} tiket
                </p>

                <!-- Tombol — pindah ke bawah di mobile -->
                <div class="order-2 lg:order-1 flex items-center gap-1 flex-wrap justify-center lg:justify-start">

                    <!-- Prev -->
                    <button
                        @click="goToPage(pagination.current_page - 1)"
                        :disabled="pagination.current_page === 1"
                        class="px-2 lg:px-3 py-1.5 text-xs lg:text-sm rounded-lg border border-gray-200 text-gray-600 hover:bg-gray-50 disabled:opacity-40 disabled:cursor-not-allowed"
                    >
                        ← Prev
                    </button>

                    <!-- Angka halaman -->
                    <template v-for="page in pagination.last_page" :key="page">
                        <button
                            @click="goToPage(page)"
                            :class="[
                                'px-2 lg:px-3 py-1.5 text-xs lg:text-sm rounded-lg border',
                                page === pagination.current_page
                                    ? 'bg-blue-600 text-white border-blue-600'
                                    : 'border-gray-200 text-gray-600 hover:bg-gray-50'
                            ]"
                        >
                            {{ page }}
                        </button>
                    </template>

                    <!-- Next -->
                    <button
                        @click="goToPage(pagination.current_page + 1)"
                        :disabled="pagination.current_page === pagination.last_page"
                        class="px-2 lg:px-3 py-1.5 text-xs lg:text-sm rounded-lg border border-gray-200 text-gray-600 hover:bg-gray-50 disabled:opacity-40 disabled:cursor-not-allowed"
                    >
                        Next →
                    </button>

                </div>
            </div>
        </div>    
    </div>
</template>