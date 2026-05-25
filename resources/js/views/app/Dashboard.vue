<script setup>
import { onMounted, ref, watch } from 'vue'
import { useTicketStore } from '@/stores/ticket';
import { storeToRefs } from 'pinia';
import { debounce } from 'lodash';
import feather from 'feather-icons'
import { DateTime } from 'luxon'
import { capitalize } from 'lodash'

const ticketStore = useTicketStore()
const {tickets, success, pagination } = storeToRefs(ticketStore)
const { fetchTickets } = ticketStore

// TODO: Create filters ref with search fields
// Hint: You'll need search, status, priority, and date
const filters = ref({
    search: '',
    status: '',
    priority: '',
    date: '',
})

// fungsi bwat pindah halaman
const goToPage = async (page) => {
    if (page < 1 || page > pagination.value.last_page) return
    await fetchTickets({ ...filters.value, page })
}

// TODO: Implement watch effect on filters
// Hint: Use debounce and call fetchTickets with updated filters
watch(filters, debounce(async () => {
    await fetchTickets({ ...filters.value, page: 1 })
}, 300), { deep: true })

// TODO: Implement onMounted hook
// Hint: Fetch initial tickets and initialize feather icons
onMounted(async () => {
    await fetchTickets()

    feather.replace()
})

</script>

<template>
    <!-- Header — responsive -->
    <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between mb-8 gap-4">
        <div>
            <h1 class="text-xl sm:text-2xl font-bold text-gray-800">Tiket Saya</h1>
            <p class="text-xs sm:text-sm text-gray-500 mt-1">Kelola dan pantau status tiket Anda</p>
        </div>
        <RouterLink :to="{ name: 'app.ticket.create' }"
            class="w-full sm:w-auto inline-flex items-center justify-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700">
            <i data-feather="plus" class="w-4 h-4 mr-2"></i>
            Buat Tiket Baru
        </RouterLink>
    </div>

    <!-- Success Alert -->
    <div class="mb-6 bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded-lg relative flex items-center justify-between"
        role="alert" v-if="success">
        <div class="flex items-center">
            <i data-feather="check-circle" class="w-5 h-5 mr-2"></i>
            <span class="text-sm">{{ success }}</span>
        </div>
        <button class="flex items-center justify-center" @click="success = null">
            <i data-feather="x" class="w-4 h-4 text-green-600"></i>
        </button>
    </div>

    <!-- Filters — responsive grid -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 mb-6">
        <div class="p-4 lg:p-6 space-y-4">
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 lg:gap-4">
                <!-- Search -->
                <div class="relative">
                    <input type="text" placeholder="Cari tiket..." v-model="filters.search"
                        class="w-full pl-10 pr-4 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500">
                    <i data-feather="search" class="w-4 h-4 text-gray-400 absolute left-3 top-2.5"></i>
                </div>

                <!-- Status -->
                <select v-model="filters.status"
                    class="border border-gray-200 rounded-lg px-4 py-2 text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500">
                    <option value="">Semua Status</option>
                    <option value="open">Open</option>
                    <option value="onprogress">In Progress</option>
                    <option value="resolved">Resolved</option>
                    <option value="rejected">Rejected</option>
                </select>

                <!-- Priority -->
                <select v-model="filters.priority"
                    class="border border-gray-200 rounded-lg px-4 py-2 text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500">
                    <option value="">Semua Prioritas</option>
                    <option value="low">Rendah</option>
                    <option value="medium">Sedang</option>
                    <option value="high">Tinggi</option>
                </select>

                <!-- Date -->
                <select v-model="filters.date"
                    class="border border-gray-200 rounded-lg px-4 py-2 text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500">
                    <option value="">Semua Tanggal</option>
                    <option value="today">Hari Ini</option>
                    <option value="week">Minggu Ini</option>
                    <option value="month">Bulan Ini</option>
                </select>
            </div>
        </div>
    </div>

    <!-- Tickets List -->
    <div class="space-y-4">
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 hover:shadow-md transition-shadow"
            v-for="ticket in tickets" :key="ticket.code">
            <RouterLink :to="{ name: 'app.ticket.detail', params: { code: ticket.code } }" class="block p-4 lg:p-6">
                <div class="flex flex-col sm:flex-row sm:items-start sm:justify-between gap-4">
                    <div class="flex-1 min-w-0">
                        <!-- Title + Badges -->
                        <div class="flex flex-col sm:flex-row sm:items-center gap-2 mb-2">
                            <h3 class="text-base sm:text-lg font-semibold text-gray-800 truncate">{{ ticket.title }}</h3>
                        </div>

                        <!-- Badges — wrap di mobile -->
                        <div class="flex flex-wrap gap-2 mb-2">
                            <span class="px-2.5 py-1 text-xs rounded-lg" :class="{
                                'text-blue-700 bg-blue-100': ticket.status === 'open',
                                'text-yellow-700 bg-yellow-100': ticket.status === 'onprogress',
                                'text-green-700 bg-green-100': ticket.status === 'resolved',
                                'text-red-700 bg-red-100': ticket.status === 'rejected'
                            }">
                                {{ capitalize(ticket.status) }}
                            </span>

                            <span class="px-2.5 py-1 text-xs rounded-lg" :class="{
                                'text-red-700 bg-red-100': ticket.priority === 'high',
                                'text-yellow-700 bg-yellow-100': ticket.priority === 'medium',
                                'text-green-700 bg-green-100': ticket.priority === 'low'
                            }">
                                {{ capitalize(ticket.priority) }}
                            </span>
                        </div>

                        <!-- Code + Date -->
                        <p class="text-xs sm:text-sm text-gray-500 mb-3">
                            #{{ ticket.code }} • Dibuat pada {{ DateTime.fromISO(ticket.created_at).toFormat('dd MMM yyyy, HH:mm') }}
                        </p>

                        <!-- Replies + Updated — stack di mobile -->
                        <div class="flex flex-col sm:flex-row sm:items-center gap-2 sm:gap-4 text-xs sm:text-sm text-gray-500">
                            <div class="flex items-center">
                                <i data-feather="message-square" class="w-4 h-4 mr-1 flex-shrink-0"></i>
                                <span>{{ ticket.ticket_replies.length }} balasan</span>
                            </div>
                            <div class="flex items-center">
                                <i data-feather="clock" class="w-4 h-4 mr-1 flex-shrink-0"></i>
                                <span>Update {{ DateTime.fromISO(ticket.updated_at).toRelative() }}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Chevron — hide di mobile -->
                    <div class="hidden sm:block ml-4 flex-shrink-0">
                        <i data-feather="chevron-right" class="w-5 h-5 text-gray-400"></i>
                    </div>
                </div>
            </RouterLink>
        </div>

        <!-- Empty State -->
        <div v-if="tickets.length === 0" class="bg-white rounded-xl shadow-sm border border-gray-100 p-12 text-center">
            <i data-feather="inbox" class="w-12 h-12 text-gray-300 mx-auto mb-3"></i>
            <p class="text-gray-500">Belum ada tiket</p>
        </div>
    </div>

    <!-- Pagination -->
    <div v-if="pagination.total > 0" class="mt-8 px-4 lg:px-6 py-4 border-t border-gray-100 flex flex-col lg:flex-row items-center justify-between gap-4 bg-white rounded-xl shadow-sm border border-gray-100">
        
        <!-- Info -->
        <p class="text-xs lg:text-sm text-gray-500 order-1 lg:order-2">
            Menampilkan {{ tickets.length }} dari {{ pagination.total }} tiket
        </p>

        <!-- Tombol -->
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
</template>