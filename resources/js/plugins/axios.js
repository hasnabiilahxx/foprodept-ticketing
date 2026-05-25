import axios from 'axios'
import Cookies from 'js-cookie'

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

const token = getStoredToken()

axios.defaults.baseURL = import.meta.env.VITE_API_BASE_URL || '/api'
axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'
axios.defaults.headers.common['Accept'] = 'application/json'

if (token) {
    axios.defaults.headers.common['Authorization'] = `Bearer ${token}`
}

axios.interceptors.request.use(
    config => {
        const token = getStoredToken()
        if (token) {
            config.headers.Authorization = `Bearer ${token}`
        }

        return config
    },
)


export const axiosInstance = axios
