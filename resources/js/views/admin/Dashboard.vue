<script setup>
import { onMounted, watch } from 'vue'
import { Chart } from 'chart.js/auto'
import { useDashboardStore } from '@/stores/dashboard'
import { useTicketStore } from '@/stores/ticket'
import { storeToRefs } from 'pinia'
import feather from 'feather-icons'
import { capitalize } from 'lodash'
import { DateTime } from 'luxon'

const dashboardStore = useDashboardStore()
const { statistic } = storeToRefs(dashboardStore)
const {fetchStatistics } = dashboardStore

const ticketStore = useTicketStore()
const { recentTickets } = storeToRefs(ticketStore)
const { fetchRecentTickets } = ticketStore

const toggleTicketMenu = (ticket) => {
    ticket.showMenu = !ticket.showMenu
}

let chart = null

watch(statistic, () => {
    if (statistic.value && chart) {
        chart.data.datasets[0].data = [
            statistic.value.status_distribution?.open,
            statistic.value.status_distribution?.onprogress,
            statistic.value.status_distribution?.resolved,
            statistic.value.status_distribution?.rejected
        ]
        chart.update()
    }
}, { deep: true })

onMounted(async () => {
    const statusCtx = document.getElementById('statusChart')?.getContext('2d')

    // bikin chart dulu dengan data kosong
    if (statusCtx) {
        chart = new Chart(statusCtx, {
            type: 'doughnut',
            data: {
                labels: ['open', 'on progress', 'resolved', 'rejected'],
                datasets: [{
                    data: [0, 0, 0, 0], // 👈 awal kosong
                    backgroundColor: [
                        '#3B82F6',
                        '#F59E0B',
                        '#10B981',
                        '#EF4444'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                animation: {
                    animateRotate: true,
                    duration: 1000 // bisa kamu atur
                },
                plugins: {
                    legend: {
                        position: 'bottom',
                    }
                },
                cutout: '70%',
            }
        })
    }

    // baru fetch data
    await fetchRecentTickets()
    await fetchStatistics()

    feather.replace()
})

</script>

<template>
    <!-- Statistics Cards -->
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 lg:gap-6">
        <div class="stat-card bg-white rounded-xl shadow-sm p-6 border border-gray-100">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm font-medium text-gray-600">Total Tiket</p>
                    <h3 class="text-2xl font-bold text-gray-800 mt-1">{{ statistic?.total_tickets }}</h3>
                </div>
                <div class="p-3 bg-blue-50 rounded-lg">
                    <i data-feather="tag" class="w-6 h-6 text-blue-600"></i>
                </div>
            </div>
            <!-- <div class="mt-4 flex items-center text-sm">
                <span class="text-green-500 flex items-center">
                    <i data-feather="trending-up" class="w-4 h-4 mr-1"></i>
                    12%
                </span>
                <span class="text-gray-500 ml-2">vs bulan lalu</span>
            </div> -->
        </div>

        <div class="stat-card bg-white rounded-xl shadow-sm p-6 border border-gray-100">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm font-medium text-gray-600">Tiket Aktif</p>
                    <h3 class="text-2xl font-bold text-gray-800 mt-1">{{ statistic?.active_tickets }}</h3>
                </div>
                <div class="p-3 bg-yellow-50 rounded-lg">
                    <i data-feather="clock" class="w-6 h-6 text-yellow-600"></i>
                </div>
            </div>
            <!-- <div class="mt-4 flex items-center text-sm">
                <span class="text-red-500 flex items-center">
                    <i data-feather="trending-down" class="w-4 h-4 mr-1"></i>
                    3%
                </span>
                <span class="text-gray-500 ml-2">vs bulan lalu</span>
            </div> -->
        </div>

        <div class="stat-card bg-white rounded-xl shadow-sm p-6 border border-gray-100">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm font-medium text-gray-600">Selesai</p>
                    <h3 class="text-2xl font-bold text-gray-800 mt-1">{{ statistic?.resolved_tickets }}</h3>
                </div>
                <div class="p-3 bg-green-50 rounded-lg">
                    <i data-feather="check-circle" class="w-6 h-6 text-green-600"></i>
                </div>
            </div>
            <!-- <div class="mt-4 flex items-center text-sm">
                <span class="text-green-500 flex items-center">
                    <i data-feather="trending-up" class="w-4 h-4 mr-1"></i>
                    8%
                </span>
                <span class="text-gray-500 ml-2">vs bulan lalu</span>
            </div> -->
        </div>

        <div class="stat-card bg-white rounded-xl shadow-sm p-6 border border-gray-100">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm font-medium text-gray-600">Rata-rata Waktu</p>
                    <h3 class="text-2xl font-bold text-gray-800 mt-1">{{ statistic?.avg_resolution_time }} Jam</h3>
                </div>
                <div class="p-3 bg-purple-50 rounded-lg">
                    <i data-feather="clock" class="w-6 h-6 text-purple-600"></i>
                </div>
            </div>
            <!-- <div class="mt-4 flex items-center text-sm">
                <span class="text-green-500 flex items-center">
                    <i data-feather="trending-down" class="w-4 h-4 mr-1"></i>
                    15%
                </span>
                <span class="text-gray-500 ml-2">vs bulan lalu</span>
            </div> -->
        </div>
    </div>

    <!-- Charts and Recent Tickets -->
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">

        <!-- Chart — di mobile tampil duluan (order-1), di desktop balik ke kanan (lg:order-2) -->
        <div class="order-1 lg:order-2 lg:col-span-4 bg-white rounded-xl shadow-sm p-6 border border-gray-100">
            <h3 class="text-lg font-semibold text-gray-800 mb-4">Distribusi Status</h3>
            <!-- [!] Langsung flex di canvas wrapper -->
            <div class="flex justify-center max-w-xs mx-auto lg:max-w-none">
                <canvas id="statusChart"></canvas>
            </div>
        </div>

        <!-- Recent Tickets — di mobile tampil kedua (order-2), di desktop balik ke kiri (lg:order-1) -->
        <div class="order-2 lg:order-1 lg:col-span-8 bg-white rounded-xl shadow-sm border border-gray-100">
            <div class="p-6 border-b border-gray-100">
                <div class="flex items-center justify-between">
                    <h3 class="text-lg font-semibold text-gray-800">Tiket Terbaru</h3>
                    <RouterLink 
                        :to="{ name: 'admin.ticket' }"
                        class="text-sm text-blue-600 hover:text-blue-800 font-medium"
                    >
                        Lihat Semua
                    </RouterLink>
                </div>
            </div>
            <div class="divide-y divide-gray-100">
                <div v-for="ticket in recentTickets" :key="ticket.code" class="p-4 hover:bg-gray-50">
                    <div class="flex items-center justify-between">
                        <div>
                            <h4 class="text-sm font-medium text-gray-800">{{ ticket.title }}</h4>
                            <p class="text-xs text-gray-500 mt-1">#{{ ticket.code }}</p>
                            <div class="flex items-center mt-2 space-x-2">
                                <span class="px-2 py-1 text-xs font-medium text-blue-700 bg-blue-100 rounded-full">
                                    {{ capitalize(ticket.status) }}
                                </span>
                                <span class="text-xs text-gray-500">
                                    {{ DateTime.fromISO(ticket.created_at).toRelative() }}
                                </span>
                            </div>
                        </div>
                        <div class="relative">
                            <button @click="toggleTicketMenu(ticket)" class="text-gray-400 hover:text-gray-600">
                                <i data-feather="more-vertical" class="w-5 h-5"></i>
                            </button>
                            <div v-show="ticket.showMenu"
                                class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-100 py-1 z-50">
                                <RouterLink :to="{ name: 'admin.ticket.detail', params: { code: ticket.code } }"
                                    class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50">
                                    <i data-feather="eye" class="w-4 h-4 inline-block mr-2"></i>
                                    Lihat Detail
                                </RouterLink>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>