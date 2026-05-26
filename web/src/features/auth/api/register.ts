import { apiClient } from '@/shared/lib/http/api-client'
import {
  authResponseSchema,
  type AuthSession,
  type RegisterPayload,
} from '@/features/auth/api/auth.types'

export async function register(payload: RegisterPayload): Promise<AuthSession> {
  const response = await apiClient.post('/auth/register', payload)
  return authResponseSchema.parse(response.data).data
}
