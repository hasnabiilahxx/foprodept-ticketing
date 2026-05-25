import { defineStore } from "pinia";
import { axiosInstance } from '@/plugins/axios';
import { handleError } from "@/helpers/errorHelper";
import router from "@/router";

export const useTicketStore = defineStore("ticket", {
    state: () => ({
        tickets: [],
        recentTickets: [],
        categories: [],
        pagination: {
            current_page: 1,
            last_page: 1,
            per_page: 10,
            total: 0,
        },
        loading: false,
        loadingfetch: false,
        error: null,
        success: null,
        sortBy: 'created_at', // default sort by newest
        sortOrder: 'desc', // desc = newest first, asc = oldest first
    }),

    actions: {
        async fetchTickets(params) {
            this.loadingFetch = true
            
            try {
                const response = await axiosInstance.get('ticket', { params: {
                        ...params,
                        sort_by: this.sortBy,
                        sort_order: this.sortOrder,
                    } 
                })

                this.tickets = response.data.data
                // simpan meta pagination
                if (response.data.meta) {
                    this.pagination = response.data.meta
                }
            } catch (error) {
                console.log('fetch error (silent):', error)
            } finally {
                this.loadingFetch = false
            }
        },

        async setSortBy(column) {
            // Kalau click kolom yang sama, toggle asc/desc
            if (this.sortBy === column) {
                this.sortOrder = this.sortOrder === 'asc' ? 'desc' : 'asc'
            } else {
                // Kalau click kolom berbeda, default desc
                this.sortBy = column
                this.sortOrder = 'desc'
            }

            // Fetch dengan sort baru
            await this.fetchTickets({ page: 1 })
        },

        async fetchTicket(code) {
            this.loadingfetch = true

            try {
                const response = await axiosInstance.get(`ticket/${code}`)

                return response.data.data
            } catch (error) {
                this.error = handleError(error)
            } finally {
                this.loading = false
            }
        },

        async fetchRecentTickets() {
            try {
                const response = await axiosInstance.get('ticket', { params: { limit: 4 } })
                this.recentTickets = response.data.data
            } catch (error) {
                console.log('fetch recent tickets error:', error)
            }
        },

        async createTicket(payload) {
            this.loading = true

            try {
                const response = await axiosInstance.post("/ticket", payload)

                this.success = response.data.message

                return true 
            } catch (error) {
                console.log('CREATE TICKET ERROR:', error.response) 

                this.error = handleError(error)
                return false 
            } finally {
                this.loading = false
            }
        },

        async createTicketReply(code, payload) {
            this.loading = true

            try {
                const response = await axiosInstance.post(`ticket-reply/${code}`, payload)

                this.success = response.data.message
                return response.data.data
            } catch (error) {
                this.error = handleError(error)
            } finally {
                this.loading = false
            }
        },

        async fetchCategories() {
            try {
                const response = await axiosInstance.get('/categories')

                console.log('CATEGORIES:', response.data) // 👈 DEBUG

                this.categories = response.data.data
            } catch (error) {
                this.error = handleError(error)
            }
        }
    }
})