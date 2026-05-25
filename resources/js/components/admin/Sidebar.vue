<script setup>
import { useAuthStore } from '@/stores/auth';

const authStore = useAuthStore()
const { logout } = authStore

defineProps({
    isOpen: {
        type: Boolean,
        default: false
    }
})

const emit = defineEmits(['close'])

const handleLogout = async () => {
    await logout()
}
</script>

<template>
    <!-- Overlay gelap di mobile (klik untuk tutup) -->
    <div 
        v-if="isOpen"
        class="fixed inset-0 bg-black bg-opacity-50 z-20 lg:hidden"
        @click="emit('close')"
    ></div>

    <!-- Sidebar -->
    <aside 
        class="fixed top-0 left-0 h-full w-64 bg-white shadow-lg z-30 transform transition-transform duration-300 ease-in-out
               lg:relative lg:translate-x-0 lg:z-auto"
        :class="isOpen ? 'translate-x-0' : '-translate-x-full'"
    >
        <!-- [!] HEADER SIDEBAR — LOGO + TITLE VERTICAL -->
        <div class="p-6 border-b border-gray-100 flex flex-col items-center justify-center">
            <!-- Logo -->
            <img src="@/assets/img/logodhh.png" 
                alt="Logo" 
                class="w-24 h-24 object-contain -mb-8">
            
            <!-- Title -->
            <h1 class="text-lg font-bold text-blue-600 text-center">
                FoProDept Helpdesk
            </h1>

            <!-- Close button (mobile only) -->
            <button 
                @click="emit('close')"
                class="lg:hidden text-gray-400 hover:text-gray-600 absolute top-6 right-6"
            >
                <i data-feather="x" class="w-5 h-5"></i>
            </button>
        </div>

        <!-- Navigation -->
        <nav class="mt-6">
            <RouterLink 
                :to="{ name: 'admin.dashboard' }"
                @click="emit('close')"
                class="flex items-center px-6 py-3 text-gray-600 hover:bg-gray-50 hover:border-l-4 hover:border-gray-200"
                :class="{ 'bg-blue-50 border-l-4 border-blue-600': $route.name === 'admin.dashboard' }"
            >
                <i data-feather="home" class="w-5 h-5 mr-3"></i>
                Dashboard
            </RouterLink>
            <RouterLink 
                :to="{ name: 'admin.ticket' }"
                @click="emit('close')"
                class="flex items-center px-6 py-3 text-gray-600 hover:bg-gray-50 hover:border-l-4 hover:border-gray-200"
                :class="{ 'bg-blue-50 border-l-4 border-blue-600': $route.name === 'admin.ticket' }"
            >
                <i data-feather="tag" class="w-5 h-5 mr-3"></i>
                Tiket
            </RouterLink>
            <a 
                @click="handleLogout"
                class="flex items-center px-6 py-3 text-gray-600 hover:bg-gray-50 hover:border-l-4 hover:border-gray-200 mt-6 cursor-pointer"
            >
                <i data-feather="log-out" class="w-5 h-5 mr-3"></i>
                Logout
            </a>
        </nav>
    </aside>
</template>