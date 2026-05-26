import { z } from 'zod'

export const authUserSchema = z.object({
  id: z.string(),
  fullName: z.string(),
  email: z.string().email(),
  phone: z.string().nullable(),
  role: z.string(),
  authProvider: z.string(),
  isActive: z.boolean(),
  acceptedTermsAt: z.string().nullable(),
  lastLoginAt: z.string().nullable(),
  createdAt: z.string().nullable(),
  updatedAt: z.string().nullable(),
})

export const authTokensSchema = z.object({
  tokenType: z.string(),
  accessToken: z.string(),
  refreshToken: z.string(),
})

export const authSessionSchema = z.object({
  user: authUserSchema,
  tokens: authTokensSchema,
})

export const authResponseSchema = z.object({
  success: z.boolean(),
  message: z.string(),
  data: authSessionSchema,
})

export type AuthUser = z.infer<typeof authUserSchema>
export type AuthTokens = z.infer<typeof authTokensSchema>
export type AuthSession = z.infer<typeof authSessionSchema>
export type AuthResponse = z.infer<typeof authResponseSchema>

export interface LoginPayload {
  identifier: string
  password: string
}

export interface RegisterPayload {
  fullName: string
  email: string
  phone: string
  password: string
  confirmPassword: string
  acceptTerms: boolean
}
