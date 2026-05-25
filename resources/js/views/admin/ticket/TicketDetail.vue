<script setup>
import { onMounted, ref, computed, onUnmounted, nextTick } from 'vue'
import { useTicketStore } from '@/stores/ticket'
import { useAuthStore } from '@/stores/auth' // [!] TAMBAH INI
import { storeToRefs } from 'pinia'
import { capitalize } from 'lodash'
import feather from 'feather-icons'
import { DateTime } from 'luxon'
import { useRoute } from 'vue-router'

const route = useRoute()
const ticketStore = useTicketStore()
const authStore = useAuthStore() // [!] TAMBAH INI
const { success, error, loading, loadingFetch } = storeToRefs(ticketStore)
const { currentUser } = storeToRefs(authStore) // [!] TAMBAH INI
const { fetchTicket, createTicketReply } = ticketStore
const { me } = authStore // [!] TAMBAH INI

const ticket = ref({})
const form = ref({
    status: '',
    content: '',
})

const chatContainer = ref(null)
let lastUpdateTime = null
let pollingInterval = null

const isClosed = computed(() => {
    return ['resolved', 'rejected'].includes(ticket.value.status)
})

// [!] Method untuk check apakah pesan dari saya
const isMyMessage = (userId) => {
    return currentUser.value?.id === userId
}

const scrollToBottom = async () => {
    await nextTick()
    if (chatContainer.value) {
        chatContainer.value.scrollTop = chatContainer.value.scrollHeight
    }
}

const fetchTicketDetail = async () => {
    const response = await fetchTicket(route.params.code)
    if (!response) return
    ticket.value = response
    form.value.status = response.status
    lastUpdateTime = new Date()
    await scrollToBottom()
}

const handleSubmit = async () => {
    if (!form.value.content || form.value.content.trim() === '') {
        error.value = { content: ['Pesan tidak boleh kosong'] }
        console.warn('⚠️ Pesan kosong, ditolak')
        return
    }

    error.value = null

    await createTicketReply(route.params.code, form.value)

    if (error.value) {
        console.error('❌ Submit gagal:', error.value)
        return
    }

    form.value.content = ''
    await fetchTicketDetail()
    await scrollToBottom()
}

const startSmartPolling = () => {
    pollingInterval = setInterval(async () => {
        if (!route.params.code) {
            console.warn('⚠️ Code tidak ditemukan, stop polling')
            clearInterval(pollingInterval)
            return
        }

        try {
            const response = await fetchTicket(route.params.code)
            if (!response) {
                console.warn('⚠️ Response kosong')
                return
            }

            const replyCountChanged = 
                response.ticket_replies.length !== ticket.value.ticket_replies?.length
            
            const statusChanged = response.status !== ticket.value.status

            if (replyCountChanged || statusChanged) {
                console.log('✅ Ada balasan baru atau status berubah')
                ticket.value = response
                form.value.status = response.status
                lastUpdateTime = new Date()
                
                if (replyCountChanged) {
                    await scrollToBottom()
                }
            } else {
                console.log('⏭️ Belum ada balasan baru')
            }
        } catch (err) {
            console.error('❌ Polling error:', err)
        }
    }, 3000)
}

onMounted(async () => {
    if (!route.params.code) return
    await me() // [!] FETCH CURRENT USER DULU

    await fetchTicketDetail()
    feather.replace()
    startSmartPolling()
})

onUnmounted(() => {
    if (pollingInterval) {
        clearInterval(pollingInterval)
        console.log('🛑 Polling stopped')
    }
})
</script>

<template>
    <div class="p-4 lg:p-6">
        <!-- Back Button -->
        <div class="mb-6">
            <RouterLink :to="{ name: 'admin.ticket' }"
                class="inline-flex items-center text-xs lg:text-sm text-gray-600 hover:text-gray-800">
                <i data-feather="arrow-left" class="w-4 h-4 mr-2"></i>
                Kembali ke Daftar Tiket
            </RouterLink>
        </div>

        <!-- Ticket Info -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 mb-6">
            <div class="p-4 lg:p-6">
                <!-- Title + Badges -->
                <div class="flex flex-col sm:flex-row sm:items-start sm:justify-between gap-4 mb-4">
                    <div class="flex-1 min-w-0">
                        <h1 class="text-xl sm:text-2xl font-bold text-gray-800 break-words">{{ ticket.title }}</h1>
                        <!-- Badges — wrap di mobile -->
                        <div class="mt-3 flex flex-wrap gap-2">
                            <span class="px-3 py-1 text-xs font-medium rounded-full" :class="{
                                'text-blue-700 bg-blue-100': ticket.status === 'open',
                                'text-yellow-700 bg-yellow-100': ticket.status === 'onprogress',
                                'text-green-700 bg-green-100': ticket.status === 'resolved',
                                'text-red-700 bg-red-100': ticket.status === 'rejected'
                            }">
                                {{ capitalize(ticket.status) }}
                            </span>

                            <span class="px-3 py-1 text-xs font-medium rounded-full" :class="{
                                'text-red-700 bg-red-100': ticket.priority === 'high',
                                'text-yellow-700 bg-yellow-100': ticket.priority === 'medium',
                                'text-green-700 bg-green-100': ticket.priority === 'low'
                            }">
                                {{ capitalize(ticket.priority) }}
                            </span>
                        </div>
                    </div>

                    <!-- Tombol Lampiran — full width di mobile -->
                    <button
                        class="w-full sm:w-auto px-4 py-2 border border-gray-200 rounded-lg text-xs sm:text-sm text-gray-600 hover:bg-gray-50 flex-shrink-0">
                        <a 
                            v-if="ticket.attachment"
                            :href="ticket.attachment"
                            target="_blank"
                            class="inline-flex items-center"
                        >
                            <i data-feather="eye" class="w-4 h-4 inline-block mr-2"></i>
                            Lihat Lampiran
                        </a>

                        <p v-else class="text-xs text-gray-400">
                            Tidak ada lampiran
                        </p>
                    </button>
                </div>

                <!-- Meta Info — stack di mobile -->
                <div class="flex flex-col sm:flex-row sm:items-center gap-2 text-xs sm:text-sm text-gray-500 border-t border-gray-100 pt-4">
                    <span>#{{ ticket.code }}</span>
                    <span class="hidden sm:block">•</span>
                    <span>Dilaporkan oleh <strong>{{ ticket.user?.name }}</strong></span>
                    <span class="hidden sm:block">•</span>
                    <span>
                        Dibuat pada {{ DateTime.fromISO(ticket.created_at).toFormat('dd MMM yyyy, HH:mm') }}
                    </span>
                </div>

                <!-- Description -->
                <div class="mt-4">
                    <p class="text-xs sm:text-sm text-gray-600 leading-relaxed">
                        {{ ticket.description }}
                    </p>
                </div>
            </div>
        </div>

        <!-- Discussion Thread -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 flex flex-col h-[700px]">
            
            <!-- Replies Container — scrollable -->
            <div ref="chatContainer" class="flex-1 overflow-y-auto p-4 lg:p-6 space-y-4">
                <!-- Messages -->
                <!-- Messages -->
                <div v-for="reply in ticket.ticket_replies" :key="reply.id"
                    :class="['flex', isMyMessage(reply.user_id) ? 'justify-end' : 'justify-start']">
                    
                    <!-- Pesan dari orang lain (kiri) -->
                    <div v-if="!isMyMessage(reply.user_id)" class="flex gap-3 max-w-xs lg:max-w-md">
                        <img :src="`https://ui-avatars.com/api/?name=${reply.user.name}&background=0D8ABC&color=fff`" 
                            alt="User"
                            class="w-8 h-8 lg:w-10 lg:h-10 rounded-full flex-shrink-0">
                        <div class="flex-1 min-w-0">
                            <p class="text-xs text-gray-500 mb-1">{{ reply.user.name }}</p>
                            <div class="bg-gray-100 rounded-lg rounded-tl-none px-4 py-2">
                                <p class="text-xs sm:text-sm text-gray-800 break-words">{{ reply.content }}</p>
                            </div>
                            <!-- [!] GANTI INI — tambah tanggal -->
                            <p class="text-xs text-gray-400 mt-1">
                                {{ DateTime.fromISO(reply.created_at).toFormat('dd MMM yyyy, HH:mm') }}
                            </p>
                        </div>
                    </div>

                    <!-- Pesan dari saya (kanan) -->
                    <div v-else class="flex gap-3 max-w-xs lg:max-w-md flex-row-reverse">
                        <img :src="`https://ui-avatars.com/api/?name=${reply.user.name}&background=10B981&color=fff`" 
                            alt="Me"
                            class="w-8 h-8 lg:w-10 lg:h-10 rounded-full flex-shrink-0">
                        <div class="flex-1 min-w-0 text-right">
                            <p class="text-xs text-gray-500 mb-1">Saya</p>
                            <div class="bg-blue-600 text-white rounded-lg rounded-tr-none px-4 py-2 ml-auto inline-block">
                                <p class="text-xs sm:text-sm break-words">{{ reply.content }}</p>
                            </div>
                            <!-- [!] GANTI INI — tambah tanggal -->
                            <p class="text-xs text-gray-400 mt-1">
                                {{ DateTime.fromISO(reply.created_at).toFormat('dd MMM yyyy, HH:mm') }}
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Empty State -->
                <div v-if="!ticket.ticket_replies || ticket.ticket_replies.length === 0" class="flex items-center justify-center h-32">
                    <div class="text-center text-gray-500 py-8">
                        <i data-feather="inbox" class="w-8 h-8 text-gray-300 mx-auto mb-2"></i>
                        <p class="text-xs sm:text-sm">Belum ada balasan</p>
                    </div>
                </div>
            </div>

            <!-- Closed Alert + Reply Form — sticky di bawah -->
            <div class="border-t border-gray-100 flex-shrink-0 bg-white">
                <!-- <div v-if="isClosed" class="p-4 bg-red-100 text-red-700 rounded-lg m-4 text-xs sm:text-sm">
                    <i data-feather="alert-circle" class="w-4 h-4 inline-block mr-2"></i>
                    Tiket sudah ditutup. Anda tidak dapat mengirim balasan lagi.
                </div> -->

                <div class="p-6 border-t border-gray-100">
                <h4 class="text-sm font-medium text-gray-800 mb-4">Tambah Jawaban</h4>
                <form @submit.prevent="handleSubmit" class="space-y-4">
                    <div class="grid grid-cols-1 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Status Tiket</label>
                            <select v-model="form.status"
                                class="w-full px-4 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500">
                                <option value="open" class="text-blue-700">Open</option>
                                <option value="onprogress" class="text-yellow-700">On Progress</option>
                                <option value="resolved" class="text-green-700">Resolved</option>
                                <option value="rejected" class="text-red-700">Rejected</option>
                            </select>
                        </div>
                    </div>
                    <div v-if="isClosed" class="p-4 bg-red-100 text-red-700 rounded-lg mb-4">
                        Tiket sudah ditutup. Anda tidak dapat mengirim balasan lagi.
                    </div>
                    <div>
                        <textarea v-model = "form.content" :disabled="isClosed"
                            class="w-full px-4 py-3 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
                            :class="{ 'border-red-500 ring-red-500': error?.content }" rows="4"
                            placeholder="Tulis jawaban anda disini"></textarea>
                        <p class="mt-1 text-sm text-red-500" v-if="error?.content">
                            {{ error?.content?.join(', ') }}
                        </p>
                    </div>
                    <div class="flex justify-end">
                        <button type="submit" :disabled="isClosed || loading || !form.content?.trim()"
                            class="w-full sm:w-auto px-6 py-2 bg-blue-600 text-white rounded-lg text-xs sm:text-sm hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed inline-flex items-center justify-center disabled:cursor-not-allowed">
                            <i data-feather="send" class="w-4 h-4 mr-2"></i>
                            <span v-if="!loading">Kirim Balasan</span>
                            <span v-else>Loading...</span>
                        </button>
                    </div>
                </form>
            </div>
            </div>
        </div>
    </div>
</template>