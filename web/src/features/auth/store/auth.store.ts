import { create } from 'zustand'
import { createJSONStorage, persist } from 'zustand/middleware'
import type { AuthSession } from '@/features/auth/api/auth.types'
import {
  clearApiClientAuthToken,
  setApiClientAuthToken,
} from '@/shared/lib/http/api-client'

interface AuthState {
  session: AuthSession | null
  isAuthenticated: boolean
  setSession: (session: AuthSession) => void
  clearSession: () => void
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      session: null,
      isAuthenticated: false,
      setSession: (session) => {
        setApiClientAuthToken(session.tokens.accessToken)
        set({
          session,
          isAuthenticated: true,
        })
      },
      clearSession: () => {
        clearApiClientAuthToken()
        set({
          session: null,
          isAuthenticated: false,
        })
      },
    }),
    {
      name: 'pawsitive-auth',
      storage: createJSONStorage(() => localStorage),
      onRehydrateStorage: () => (state) => {
        const accessToken = state?.session?.tokens.accessToken

        if (accessToken) {
          setApiClientAuthToken(accessToken)
          return
        }

        clearApiClientAuthToken()
      },
    },
  ),
)
