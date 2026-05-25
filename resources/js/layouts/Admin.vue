<script setup>
import { ref, watch, nextTick } from 'vue'
import Sidebar from '@/components/admin/Sidebar.vue'
import feather from 'feather-icons'

const sidebarOpen = ref(false)

watch(sidebarOpen, async (val) => {
    if (val) {
        await nextTick()
        feather.replace()
    }
})
</script>

<template>
    <div class="flex h-screen bg-gray-50">
        <!-- Sidebar -->
        <Sidebar :isOpen="sidebarOpen" @close="sidebarOpen = false" />

        <!-- Main Content -->
        <main class="flex-1 overflow-x-hidden overflow-y-auto min-w-0">
            <!-- Topbar -->
            <div class="bg-white shadow-sm sticky top-0 z-10">
                <div class="flex items-center justify-between px-4 lg:px-6 py-4">
                    <div class="flex items-center gap-3">
                        <!-- Burger button (mobile only) -->
                        <button 
                            @click="sidebarOpen = true"
                            class="lg:hidden p-2 text-gray-600 hover:text-gray-800 hover:bg-gray-100 rounded-lg"
                        >
                            <i data-feather="menu" class="w-5 h-5"></i>
                        </button>
                        <h2 class="text-lg lg:text-xl font-semibold text-gray-800">
                            {{ $route.meta.title }}
                        </h2>
                    </div>
                    <div class="flex items-center space-x-2 lg:space-x-4">
                        <!-- <button class="relative p-2 text-gray-600 hover:text-gray-800 hover:bg-gray-100 rounded-full">
                            <i data-feather="bell" class="w-5 h-5 lg:w-6 lg:h-6"></i>
                            <span class="absolute top-0 right-0 w-2 h-2 bg-red-500 rounded-full"></span>
                        </button> -->
                        <div class="flex items-center bg-gray-50 px-3 py-2 rounded-full">
                            <img src="https://ui-avatars.com/api/?name=Admin&background=0D8ABC&color=fff" 
                                alt="Profile" class="w-7 h-7 lg:w-8 lg:h-8 rounded-full">
                            <span class="ml-2 text-sm font-medium text-gray-700 hidden sm:block">Admin</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Content -->
            <div class="p-4 lg:p-6 space-y-6">
                <router-view></router-view>
            </div>
        </main>
    </div>
</template>