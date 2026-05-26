import { z } from 'zod'

const emailSchema = z.string().trim().email('Please enter a valid email address.')
const phoneSchema = z
  .string()
  .trim()
  .regex(/^\+?[0-9]{9,15}$/, 'Please enter a valid phone number.')

export const loginFormSchema = z.object({
  identifier: z
    .string()
    .trim()
    .min(1, 'Please enter your email or phone number.')
    .refine(
      (value) => emailSchema.safeParse(value).success || phoneSchema.safeParse(value).success,
      'Please enter a valid email or phone number.',
    ),
  password: z.string().min(8, 'Password must be at least 8 characters.'),
})

export const registerFormSchema = z
  .object({
    firstName: z.string().trim().min(1, 'Please enter your first name.'),
    lastName: z.string().trim().min(1, 'Please enter your last name.'),
    email: emailSchema,
    phone: phoneSchema,
    password: z.string().min(8, 'Password must be at least 8 characters.'),
    confirmPassword: z.string().min(1, 'Please confirm your password.'),
    acceptTerms: z.boolean(),
  })
  .refine((value) => value.acceptTerms, {
    message: 'Please accept the terms of service and privacy policy.',
    path: ['acceptTerms'],
  })
  .refine((value) => value.password === value.confirmPassword, {
    message: 'Passwords do not match.',
    path: ['confirmPassword'],
  })

export type LoginFormValues = z.infer<typeof loginFormSchema>
export type RegisterFormValues = z.infer<typeof registerFormSchema>

export type FormErrors<T extends string> = Partial<Record<T, string>>

export function getFieldErrors<T extends string>(error: z.ZodError): FormErrors<T> {
  const flattened = error.flatten().fieldErrors
  const entries = Object.entries(flattened).map(([key, value]) => [
    key,
    value?.[0] ?? '',
  ])

  return Object.fromEntries(entries) as FormErrors<T>
}
