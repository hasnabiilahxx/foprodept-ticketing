<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { storeToRefs } from 'pinia'
import feather from 'feather-icons'
import { onMounted } from 'vue'

const router = useRouter()
const authStore = useAuthStore()
const { loading, error } = storeToRefs(authStore)

const form = ref({
    old_password: '',
    password: '',
    password_confirmation: '',
})

const showPassword = ref(false)
const showNewPassword = ref(false)
const showConfirmPassword = ref(false)

// [!] Fungsi ganti password
const handleChangePassword = async () => {
    // Validasi frontend
    if (!form.value.old_password) {
        error.value = { old_password: ['Password lama harus diisi'] }
        return
    }

    if (!form.value.password) {
        error.value = { password: ['Password baru harus diisi'] }
        return
    }

    if (form.value.password.length < 6) {
        error.value = { password: ['Password minimal 6 karakter'] }
        return
    }

    if (form.value.password !== form.value.password_confirmation) {
        error.value = { password_confirmation: ['Password tidak cocok'] }
        return
    }

    // [!] Reset error sebelum submit
    error.value = null

    try {
        loading.value = true

        // [!] Call API
        const response = await authStore.changePassword(form.value)

        // [!] Cek apakah ada error dari server
        if (error.value) {
            console.error('❌ Error dari server:', error.value)
            return
        }

        // [!] Kalau berhasil
        alert('Password berhasil diubah!')
        router.push({ name: 'app.dashboard' })

    } catch (err) {
        console.error('Unexpected error:', err)
        alert('Terjadi kesalahan, coba lagi')
    } finally {
        loading.value = false
    }
}

onMounted(() => {
    feather.replace()
})
</script>

<template>
    <div class="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md mx-auto">
            <!-- Header -->
            <div class="mb-8">
                <RouterLink :to="{ name: 'app.dashboard' }"
                    class="inline-flex items-center text-sm text-gray-600 hover:text-gray-800 mb-4">
                    <i data-feather="arrow-left" class="w-4 h-4 mr-2"></i>
                    Kembali ke Dashboard
                </RouterLink>
                <h1 class="text-2xl font-bold text-gray-800">Ganti Password</h1>
                <p class="text-sm text-gray-500 mt-2">Perbarui password akun Anda</p>
            </div>

            <!-- Card -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                <!-- Error Alert (general) -->
                <div v-if="error?.general" class="mb-6 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg text-sm">
                    <i data-feather="alert-circle" class="w-4 h-4 inline-block mr-2"></i>
                    {{ error.general[0] }}
                </div>
                
                <form @submit.prevent="handleChangePassword" class="space-y-6">

                    <!-- Old Password -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Password Lama
                        </label>
                        <div class="relative">
                            <input 
                                v-model="form.old_password"
                                :type="showPassword ? 'text' : 'password'"
                                class="w-full px-4 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
                                :class="{ 'border-red-500 ring-red-500': error?.old_password }"
                                placeholder="Masukkan password lama"
                            >
                            <button 
                                type="button"
                                @click="showPassword = !showPassword"
                                class="absolute right-3 top-2.5 text-gray-400 hover:text-gray-600">
                                <i :data-feather="showPassword ? 'eye-off' : 'eye'" class="w-4 h-4"></i>
                            </button>
                        </div>
                        <p class="mt-1 text-xs text-red-500" v-if="error?.old_password">
                            {{ error.old_password?.join(', ') }}
                        </p>
                    </div>

                    <!-- New Password -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Password Baru
                        </label>
                        <div class="relative">
                            <input 
                                v-model="form.password"
                                :type="showNewPassword ? 'text' : 'password'"
                                class="w-full px-4 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
                                :class="{ 'border-red-500 ring-red-500': error?.password }"
                                placeholder="Masukkan password baru"
                            >
                            <button 
                                type="button"
                                @click="showNewPassword = !showNewPassword"
                                class="absolute right-3 top-2.5 text-gray-400 hover:text-gray-600">
                                <i :data-feather="showNewPassword ? 'eye-off' : 'eye'" class="w-4 h-4"></i>
                            </button>
                        </div>
                        <p class="mt-1 text-xs text-gray-500">
                            Minimal 6 karakter
                        </p>
                        <p class="mt-1 text-xs text-red-500" v-if="error?.password">
                            {{ error.password?.join(', ') }}
                        </p>
                    </div>

                    <!-- Confirm Password -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Konfirmasi Password Baru
                        </label>
                        <div class="relative">
                            <input 
                                v-model="form.password_confirmation"
                                :type="showConfirmPassword ? 'text' : 'password'"
                                class="w-full px-4 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
                                :class="{ 'border-red-500 ring-red-500': error?.password_confirmation }"
                                placeholder="Konfirmasi password baru"
                            >
                            <button 
                                type="button"
                                @click="showConfirmPassword = !showConfirmPassword"
                                class="absolute right-3 top-2.5 text-gray-400 hover:text-gray-600">
                                <i :data-feather="showConfirmPassword ? 'eye-off' : 'eye'" class="w-4 h-4"></i>
                            </button>
                        </div>
                        <p class="mt-1 text-xs text-red-500" v-if="error?.password_confirmation">
                            {{ error.password_confirmation?.join(', ') }}
                        </p>
                    </div>

                    <!-- Submit Button -->
                    <button 
                        type="submit"
                        :disabled="loading"
                        class="w-full px-4 py-2 bg-blue-600 text-white rounded-lg text-sm font-medium hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed">
                        <span v-if="!loading">Simpan Password Baru</span>
                        <span v-else>Menyimpan...</span>
                    </button>

                </form>
            </div>

            <!-- Info -->
            <div class="mt-6 p-4 bg-blue-50 border border-blue-200 rounded-lg">
                <p class="text-xs text-blue-800">
                    <strong>Tips keamanan:</strong> Gunakan password yang kuat dengan kombinasi huruf besar, huruf kecil, angka, dan simbol.
                </p>
            </div>
        </div>
    </div>
</template>