import { defineStore } from "pinia"
import { axiosInstance } from "@/plugins/axios"
import { handleError } from "@/helpers/errorHelper"

export const useCategoryStore = defineStore("category", {
    state: () => ({
        categories: [],
        loading: false,
        error: null,
    }),

    actions: {
        async fetchCategories() {
            this.loading = true
            try {
                const response = await axiosInstance.get('/categories')
                this.categories = response.data.data
            } catch (error) {
                this.error = handleError(error)
            } finally {
                this.loading = false
            }
        }
    }
})