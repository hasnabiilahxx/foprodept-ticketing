<script setup>
import { onMounted , ref } from 'vue'
import { useTicketStore } from '@/stores/ticket'
import { storeToRefs } from 'pinia'
import { useRouter } from 'vue-router'
import feather from 'feather-icons'

//inisiasi ticket store nya
const ticketStore = useTicketStore()
const { success, error, loading, categories } = storeToRefs(ticketStore)
const router = useRouter()
const { createTicket } = ticketStore

//naro lampiran
const file = ref(null)
const fileInput = ref(null)

const triggerFile = () => {
    fileInput.value.click()
}

const handleFileChange = (e) => {
    const selectedFile = e.target.files[0]

    if (!selectedFile) return

    // max 10MB
    const maxSize = 10 * 1024 * 1024

    if (selectedFile.size > maxSize) {
        error.value = {
            attachment: ['Ukuran file maksimal 10MB']
        }

        file.value = null
        fileInput.value.value = '' // reset input
        return
    }

    file.value = selectedFile
}

// TODO: Create form ref with ticket fields
// Hint: You'll need title, description, priority
const form = ref({
    title: '',
    description: '',
    category_id: '',
    priority: '',
})

// TODO: Implement handleSubmit function
// Hint: This should call the createTicket function from ticket store
// and handle any errors
const handleSubmit = async () => {
    const formData = new FormData()

    formData.append('title', form.value.title)
    formData.append('description', form.value.description)
    formData.append('category_id', form.value.category_id)
    formData.append('priority', form.value.priority)

    if (file.value) {
        formData.append('attachment', file.value)
    }

    const result = await createTicket(formData)

    if (!result) {
        return
    }
        router.push({ name: 'app.dashboard' })
}

// TODO: Implement onMounted hook
// Hint: Initialize feather icons
onMounted(async () => {
    await ticketStore.fetchCategories()

    console.log('categories user:', categories.value)

    feather.replace() //biar package iconnya bisa jln dgn baik
})
</script>

<template>
    <div class="mb-6">
        <RouterLink :to="{ name: 'app.dashboard' }"
            class="inline-flex items-center text-sm text-gray-600 hover:text-gray-800">
            <i data-feather="arrow-left" class="w-4 h-4 mr-2"></i>
            Kembali ke Daftar Tiket
        </RouterLink>
    </div>

    <!-- Create Ticket Form -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100">
        <div class="p-6 border-b border-gray-100">
            <h1 class="text-2xl font-bold text-gray-800">Buat Tiket Baru</h1>
            <p class="text-sm text-gray-500 mt-1">Isi form di bawah ini untuk membuat tiket baru</p>
        </div>
        <form @submit.prevent="handleSubmit" class="p-6 space-y-6">
            <!-- Judul Tiket -->
            <div>
                <label for="title" class="block text-sm font-medium text-gray-700 mb-2">Judul Tiket</label>
                <input type="text" id="title" v-model="form.title" placeholder="Contoh: Masalah pembayaran uang KKN"
                    class="w-full px-4 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500">
                <div v-if="error?.title" class="flex items-center mt-2">
                    <p class="text-xs text-red-500">{{ error.title[0] }}</p>
                </div>
            </div>

            <!-- Deskripsi -->
            <div>
                <label for="description" class="block text-sm font-medium text-gray-700 mb-2">Deskripsi
                    Masalah</label>
                <textarea id="description" v-model="form.description" rows="6"
                    placeholder="Jelaskan masalah Anda secara detail. Sertakan informasi seperti:&#10;- Kapan masalah mulai terjadi&#10;- Apa yang sudah Anda coba&#10;- Dampak masalah terhadap pekerjaan"
                    class="w-full px-4 py-3 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500"></textarea>
                <div v-if="error?.description" class="flex items-center mt-2">
                    <p class="text-xs text-red-500">{{ error.description[0] }}</p>
                </div>
            </div>
            <!-- Kategori -->
            <div>
                <label class="block text-sm font-medium text-gray-700">Kategori</label>
                <select v-model="form.category_id"
                    class="w-full px-4 py-2 border border-gray-200 rounded-lg"
                    :class="{ 'border-red-500': error?.category_id }">

                    <option value="">Pilih Kategori</option>

                    <option 
                        v-for="cat in categories" 
                        :key="cat.id" 
                        :value="cat.id">

                        {{ cat.name }}
                    </option>
                </select>

                <!-- error message -->
                <p v-if="error?.category_id" class="text-red-500 text-sm">
                    {{ error.category_id[0] }}
                </p>
            </div>
            <!-- Prioritas -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Prioritas</label>
                <div class="grid grid-cols-3 gap-4">
                    <label class="relative flex cursor-pointer rounded-lg border"
                        :class="[form.priority === 'low' ? 'border-green-200 bg-green-50' : 'border-gray-200']">
                        <input type="radio" v-model="form.priority" value="low" class="sr-only">
                        <div class="flex w-full items-center justify-between p-4">
                            <div class="flex items-center">
                                <div class="text-sm">
                                    <p class="font-medium text-gray-900">Rendah</p>
                                    <p class="text-gray-500">Tidak mendesak</p>
                                </div>
                            </div>
                            <div class="shrink-0 text-green-600" v-show="form.priority === 'low'">
                                <i data-feather="check-circle" class="w-6 h-6"></i>
                            </div>
                        </div>
                    </label>
                    <label class="relative flex cursor-pointer rounded-lg border"
                        :class="[form.priority === 'medium' ? 'border-yellow-200 bg-yellow-50' : 'border-gray-200']">
                        <input type="radio" v-model="form.priority" value="medium" class="sr-only">
                        <div class="flex w-full items-center justify-between p-4">
                            <div class="flex items-center">
                                <div class="text-sm">
                                    <p class="font-medium text-gray-900">Sedang</p>
                                    <p class="text-gray-500">Normal</p>
                                </div>
                            </div>
                            <div class="shrink-0 text-yellow-600" v-show="form.priority === 'medium'">
                                <i data-feather="check-circle" class="w-6 h-6"></i>
                            </div>
                        </div>
                    </label>
                    <label class="relative flex cursor-pointer rounded-lg border"
                        :class="[form.priority === 'high' ? 'border-red-200 bg-red-50' : 'border-gray-200']">
                        <input type="radio" v-model="form.priority" value="high" class="sr-only">
                        <div class="flex w-full items-center justify-between p-4">
                            <div class="flex items-center">
                                <div class="text-sm">
                                    <p class="font-medium text-gray-900">Tinggi</p>
                                    <p class="text-gray-500">Mendesak</p>
                                </div>
                            </div>
                            <div class="shrink-0 text-red-600" v-show="form.priority === 'high'">
                                <i data-feather="check-circle" class="w-6 h-6"></i>
                            </div>
                        </div>
                    </label>
                </div>
                <div v-if="error?.priority" class="flex items-center mt-2">
                    <p class="text-xs text-red-500">{{ error.priority[0] }}</p>
                </div>
            </div>
            
            <div class="flex items-center space-x-4">
                <button 
                    type="button"
                    @click="triggerFile"
                    class="px-4 py-2 border border-gray-200 rounded-lg text-sm text-gray-600 hover:bg-gray-50"
                >
                    <i data-feather="paperclip" class="w-4 h-4 inline-block mr-2"></i>
                    Lampiran
                </button> 
                <p v-if="error?.attachment" class="text-red-500 text-sm">
                    {{ error.attachment[0] }}
                </p>
                <input 
                    type="file"
                    ref="fileInput"
                    class="hidden"
                    @change="handleFileChange"
                />
                <!-- tampilkan nama file -->
                <span v-if="file" class="text-sm text-gray-500">
                    {{ file.name }}
                </span>
                <span class="text-xs text-gray-400">
                    Maksimal ukuran file 10MB (jpg, png, pdf, doc, docx)
                </span>
            </div>

            <!-- Submit Button -->
            <div class="flex justify-end space-x-4">
                <RouterLink :to="{ name: 'app.dashboard' }"
                    class="px-6 py-2 border border-gray-200 rounded-lg text-sm text-gray-600 hover:bg-gray-50">
                    Batal
                </RouterLink>
                <button type="submit" class="px-6 py-2 bg-blue-600 text-white rounded-lg text-sm hover:bg-blue-700"
                    :disabled="loading">
                    <i data-feather="send" class="w-4 h-4 inline-block mr-2"></i>
                    {{ loading ? 'Mengirim...' : 'Kirim Tiket' }}
                </button>
            </div>
        </form>
    </div>
</template>