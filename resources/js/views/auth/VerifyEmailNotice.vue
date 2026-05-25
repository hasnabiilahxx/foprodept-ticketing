<script setup>
import { useRoute, useRouter } from 'vue-router'
import { ref } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { storeToRefs } from 'pinia'
import { axiosInstance } from '@/plugins/axios'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const { loading } = storeToRefs(authStore)

const email = ref(route.params.email)
const resendSuccess = ref(false)

const handleResendEmail = async () => {
    try {
        loading.value = true
        
        await axiosInstance.post('/email/resend', { email: email.value })

        resendSuccess.value = true
        setTimeout(() => {
            resendSuccess.value = false
        }, 3000)
    } catch (err) {
        console.error('Error:', err)
        alert(err.response?.data?.message || 'Terjadi kesalahan')
    } finally {
        loading.value = false
    }
}
</script>

<template>
    <div class="space-y-6">
        <!-- Success Alert -->
        <div v-if="resendSuccess" class="p-4 bg-green-100 border border-green-400 text-green-700 rounded-lg">
            <i data-feather="check-circle" class="w-5 h-5 inline-block mr-2"></i>
            Email verifikasi berhasil dikirim ulang!
        </div>

        <!-- Main Content -->
        <div class="text-center">
            <i data-feather="mail" class="w-16 h-16 text-blue-500 mx-auto mb-4"></i>
            
            <h2 class="text-2xl font-bold text-gray-800 mb-2">Cek Email Anda! 📬</h2>
            
            <p class="text-gray-600 mb-4">
                Kami telah mengirim link verifikasi ke:<br>
                <strong class="text-blue-600">{{ email }}</strong>
            </p>

            <p class="text-gray-600 mb-6">
                Silakan klik link verifikasi di email Anda untuk mengaktifkan akun. 
                Link akan berlaku selama 60 menit.
            </p>

            <!-- Resend Email Button -->
            <div class="space-y-4">
                <button 
                    @click="handleResendEmail"
                    :disabled="loading"
                    class="inline-block px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50">
                    {{ loading ? 'Mengirim...' : 'Kirim Ulang Email' }}
                </button>

                <p class="text-sm text-gray-500">
                    Tidak menerima email? Cek folder spam atau klik tombol di atas.
                </p>
            </div>

            <!-- Back to Login -->
            <div class="mt-8 pt-8 border-t border-gray-200">
                <p class="text-sm text-gray-600 mb-4">Sudah verifikasi?</p>
                <RouterLink :to="{ name: 'login' }"
                    class="inline-block px-6 py-2 border border-blue-600 text-blue-600 rounded-lg hover:bg-blue-50">
                    Kembali ke Login
                </RouterLink>
            </div>
        </div>
    </div>
</template>
