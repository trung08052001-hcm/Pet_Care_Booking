import axios from 'axios'
import { env } from '@/shared/config/env'

export const apiClient = axios.create({
  baseURL: env.apiBaseUrl,
  timeout: 10_000,
  headers: {
    'Content-Type': 'application/json',
  },
})

export function setApiClientAuthToken(token: string) {
  apiClient.defaults.headers.common.Authorization = `Bearer ${token}`
}

export function clearApiClientAuthToken() {
  delete apiClient.defaults.headers.common.Authorization
}
