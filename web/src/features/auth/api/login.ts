import { apiClient } from '@/shared/lib/http/api-client'
import { authResponseSchema, type AuthSession, type LoginPayload } from '@/features/auth/api/auth.types'

export async function login(payload: LoginPayload): Promise<AuthSession> {
  const response = await apiClient.post('/auth/login', payload)
  return authResponseSchema.parse(response.data).data
}
