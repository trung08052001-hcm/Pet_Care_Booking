import { z } from 'zod'

const envSchema = z.object({
  VITE_APP_NAME: z.string().min(1).optional(),
  VITE_API_BASE_URL: z.string().url().optional(),
})

const parsedEnv = envSchema.safeParse(import.meta.env)

if (!parsedEnv.success && import.meta.env.DEV) {
  console.warn(
    'Invalid env config detected:',
    parsedEnv.error.flatten().fieldErrors,
  )
}

export const env = {
  appName: parsedEnv.success
    ? (parsedEnv.data.VITE_APP_NAME ?? 'PawSitive Care')
    : 'PawSitive Care',
  apiBaseUrl: parsedEnv.success
    ? (parsedEnv.data.VITE_API_BASE_URL ?? 'http://localhost:5000/api/v1')
    : 'http://localhost:5000/api/v1',
}
