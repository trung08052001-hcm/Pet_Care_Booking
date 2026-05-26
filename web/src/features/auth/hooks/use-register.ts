import { useMutation } from '@tanstack/react-query'
import { register } from '@/features/auth/api/register'
import { useAuthStore } from '@/features/auth/store/auth.store'

export function useRegister() {
  const setSession = useAuthStore((state) => state.setSession)

  return useMutation({
    mutationFn: register,
    onSuccess: (session) => {
      setSession(session)
    },
  })
}
