import { defineStore } from "pinia"
import { axiosInstance } from "@/plugins/axios"
import { handleError } from "@/helpers/errorHelper"
import router from "@/router"
import Cookies from "js-cookie"

const getStoredToken = () => {
    const cookieToken = Cookies.get('token')

    if (cookieToken) {
        return cookieToken
    }

    if (typeof window !== 'undefined') {
        return window.localStorage.getItem('token')
    }

    return null
}

const setStoredToken = (token) => {
    Cookies.set('token', token, { path: '/', sameSite: 'Lax' })

    if (typeof window !== 'undefined') {
        window.localStorage.setItem('token', token)
    }
}

const clearStoredToken = () => {
    Cookies.remove('token', { path: '/' })

    if (typeof window !== 'undefined') {
        window.localStorage.removeItem('token')
    }
}

const setAuthorizationHeader = (token) => {
    axiosInstance.defaults.headers.common.Authorization = `Bearer ${token}`
}

const clearAuthorizationHeader = () => {
    delete axiosInstance.defaults.headers.common.Authorization
}

export const useAuthStore = defineStore("auth", {
    state: () => ({
        user: null,
        currentUser: null,
        tokenValue: getStoredToken(),
        loading: false,
        error: null,
        success: null,
    }),

    getters: {
        token: (state) => state.tokenValue || getStoredToken(),
        isAuthenticated: (state) => !!state.user || !!state.tokenValue || !!getStoredToken(),
    },

    actions: {
        async login(credentials) {
            this.loading = true
            this.error = null

            try {
                const response = await axiosInstance.post('/login', credentials)

                const token = response.data.data.token
                const user = response.data.data.user

                setStoredToken(token)
                setAuthorizationHeader(token)

                this.user = user
                this.currentUser = user
                this.tokenValue = token
                this.error = null
                this.success = response.data.message

                await router.push({
                    name: user.role === 'admin' ? 'admin.dashboard' : 'app.dashboard',
                })

                return true
            } catch (error) {
                this.error = handleError(error)
                return false
            } finally {
                this.loading = false
            }
        },

        async register(credentials) {
            this.loading = true
            this.error = null

            try {
                const response = await axiosInstance.post('/register', credentials)

                this.success = response.data.message

                return true
            } catch (error) {
                if (error.response?.data?.errors) {
                    this.error = error.response.data.errors
                } else if (error.response?.status === 422) {
                    this.error = { general: [error.response.data.message] }
                } else {
                    this.error = handleError(error)
                }

                return false
            } finally {
                this.loading = false
            }
        },

        async logout() {
            this.loading = true

            try {
                const response = await axiosInstance.post('/logout')
                this.success = response.data.message
            } catch (error) {
                this.error = handleError(error)
            } finally {
                clearStoredToken()
                clearAuthorizationHeader()

                this.user = null
                this.currentUser = null
                this.tokenValue = null
                this.loading = false

                router.push({ name: 'login' })
            }
        },

        async changePassword(payload) {
            this.loading = true
            this.error = null

            try {
                const response = await axiosInstance.post('/change-password', payload)

                this.success = response.data.message
                return true
            } catch (error) {
                if (error.response?.data?.errors) {
                    this.error = error.response.data.errors
                } else if (error.response?.status === 422) {
                    this.error = { general: [error.response.data.message] }
                } else {
                    this.error = handleError(error)
                }

                return false
            } finally {
                this.loading = false
            }
        },

        async me() {
            try {
                const response = await axiosInstance.get('/me')
                const user = response.data.data || response.data

                this.user = user
                this.currentUser = user

                return this.currentUser
            } catch (error) {
                clearStoredToken()
                clearAuthorizationHeader()

                this.user = null
                this.currentUser = null
                this.tokenValue = null

                throw error
            }
        },

        async checkAuth() {
            this.loading = true
            this.error = null

            try {
                const token = getStoredToken()

                if (!token) {
                    throw new Error('Unauthenticated')
                }

                this.tokenValue = token
                setAuthorizationHeader(token)

                return await this.me()
            } catch (error) {
                this.error = error.message === 'Unauthenticated'
                    ? 'Unauthenticated'
                    : handleError(error)

                throw error
            } finally {
                this.loading = false
            }
        },
    },
})
