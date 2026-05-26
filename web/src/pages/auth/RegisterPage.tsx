import { useEffect, useMemo, useState, type ChangeEvent, type FormEvent } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import {
  AuthDivider,
  AuthField,
  SocialButtons,
} from '@/features/auth/components/AuthControls'
import { useRegister } from '@/features/auth/hooks/use-register'
import {
  getFieldErrors,
  registerFormSchema,
  type FormErrors,
  type RegisterFormValues,
} from '@/features/auth/lib/auth.validators'
import { useAuthStore } from '@/features/auth/store/auth.store'
import { getApiErrorMessage } from '@/shared/lib/http/get-api-error-message'

const registerImage =
  'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=1200&q=80'

export function RegisterPage() {
  const navigate = useNavigate()
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated)
  const registerMutation = useRegister()
  const [form, setForm] = useState<RegisterFormValues>({
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    password: '',
    confirmPassword: '',
    acceptTerms: false,
  })
  const [errors, setErrors] = useState<FormErrors<keyof RegisterFormValues>>({})

  const apiError = useMemo(
    () =>
      registerMutation.isError
        ? getApiErrorMessage(registerMutation.error)
        : null,
    [registerMutation.error, registerMutation.isError],
  )

  useEffect(() => {
    if (isAuthenticated) {
      navigate('/', { replace: true })
    }
  }, [isAuthenticated, navigate])

  function handleChange(
    event: ChangeEvent<HTMLInputElement>,
    field: keyof RegisterFormValues,
  ) {
    const value =
      field === 'acceptTerms' ? event.target.checked : event.target.value

    setForm((previous) => ({
      ...previous,
      [field]: value,
    }))
    setErrors((previous) => ({
      ...previous,
      [field]: undefined,
    }))
  }

  function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()

    const parsed = registerFormSchema.safeParse(form)
    if (!parsed.success) {
      setErrors(getFieldErrors<keyof RegisterFormValues>(parsed.error))
      return
    }

    setErrors({})
    registerMutation.mutate(
      {
        fullName: `${parsed.data.firstName} ${parsed.data.lastName}`.trim(),
        email: parsed.data.email,
        phone: parsed.data.phone,
        password: parsed.data.password,
        confirmPassword: parsed.data.confirmPassword,
        acceptTerms: parsed.data.acceptTerms,
      },
      {
        onSuccess: () => {
          navigate('/', { replace: true })
        },
      },
    )
  }

  return (
    <section className="grid flex-1 gap-6 py-3 lg:grid-cols-[0.95fr_1.05fr] lg:py-8">
      <aside className="relative hidden overflow-hidden rounded-[34px] shadow-[var(--shadow-soft)] lg:block">
        <div
          className="absolute inset-0 bg-cover bg-center"
          style={{ backgroundImage: `url(${registerImage})` }}
        />
        <div className="absolute inset-0 bg-[linear-gradient(180deg,rgba(30,17,10,0.05)_0%,rgba(59,32,14,0.65)_100%)]" />
        <div className="relative flex min-h-[720px] items-end p-8">
          <div className="max-w-xs text-white">
            <p className="text-[11px] font-semibold tracking-[0.22em] text-white/70 uppercase">
              PawSitive Care
            </p>
            <h2 className="mt-3 text-4xl leading-tight font-semibold">
              A safe haven for your best friend.
            </h2>
            <p className="mt-4 text-sm leading-7 text-white/80">
              Join our family of pet parents and caregivers to easily book
              stays, grooming and wellness support.
            </p>
          </div>
        </div>
      </aside>

      <div className="mx-auto flex w-full max-w-[460px] items-center">
        <div className="w-full rounded-[34px] bg-[var(--surface-elevated)] p-6 shadow-[var(--shadow-soft)] md:p-8">
          <p className="text-xs font-semibold tracking-[0.2em] text-[var(--text-muted)] uppercase">
            Join our community
          </p>
          <h1 className="mt-3 text-4xl font-semibold tracking-tight text-[var(--text-primary)]">
            Sign up
          </h1>
          <p className="mt-3 text-sm leading-7 text-[var(--text-secondary)]">
            Create your account to book services, save pet profiles and receive
            personalized care updates.
          </p>

          <form className="mt-8 space-y-4" onSubmit={handleSubmit}>
            {apiError ? (
              <div className="rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-600">
                {apiError}
              </div>
            ) : null}

            <div className="grid gap-4 sm:grid-cols-2">
              <AuthField
                label="First name"
                name="firstName"
                autoComplete="given-name"
                placeholder="John"
                value={form.firstName}
                onChange={(event) => handleChange(event, 'firstName')}
                error={errors.firstName}
              />
              <AuthField
                label="Last name"
                name="lastName"
                autoComplete="family-name"
                placeholder="Doe"
                value={form.lastName}
                onChange={(event) => handleChange(event, 'lastName')}
                error={errors.lastName}
              />
            </div>

            <AuthField
              label="Email address"
              type="email"
              name="email"
              autoComplete="email"
              placeholder="john@example.com"
              value={form.email}
              onChange={(event) => handleChange(event, 'email')}
              error={errors.email}
            />

            <AuthField
              label="Phone number"
              type="tel"
              name="phone"
              autoComplete="tel"
              placeholder="+84 987 654 321"
              value={form.phone}
              onChange={(event) => handleChange(event, 'phone')}
              error={errors.phone}
            />

            <div className="grid gap-4 sm:grid-cols-2">
              <AuthField
                label="Password"
                type="password"
                name="password"
                autoComplete="new-password"
                placeholder="Create password"
                value={form.password}
                onChange={(event) => handleChange(event, 'password')}
                error={errors.password}
              />
              <AuthField
                label="Confirm password"
                type="password"
                name="confirmPassword"
                autoComplete="new-password"
                placeholder="Repeat password"
                value={form.confirmPassword}
                onChange={(event) => handleChange(event, 'confirmPassword')}
                error={errors.confirmPassword}
              />
            </div>

            <label className="flex items-start gap-3 text-sm leading-6 text-[var(--text-secondary)]">
              <input
                type="checkbox"
                className="mt-1 h-4 w-4 rounded border-[var(--border-soft)] accent-[var(--accent)]"
                checked={form.acceptTerms}
                onChange={(event) => handleChange(event, 'acceptTerms')}
              />
              <span>
                I agree to the terms of service and privacy policy. I also want
                to receive occasional care tips and offers.
              </span>
            </label>
            {errors.acceptTerms ? (
              <p className="text-sm font-medium text-red-500">{errors.acceptTerms}</p>
            ) : null}

            <button
              type="submit"
              disabled={registerMutation.isPending}
              className="w-full rounded-xl bg-[var(--accent)] px-5 py-3 text-sm font-semibold text-[var(--accent-contrast)] shadow-[0_14px_24px_rgba(245,140,62,0.25)]"
            >
              {registerMutation.isPending ? 'Creating account...' : 'Sign Up'}
            </button>
          </form>

          <p className="mt-5 text-center text-sm text-[var(--text-secondary)]">
            Already a member?{' '}
            <Link
              to="/login"
              className="font-semibold text-[var(--accent-strong)]"
            >
              Sign in
            </Link>
          </p>

          <div className="mt-6">
            <AuthDivider label="or sign up with" />
          </div>

          <div className="mt-6">
            <SocialButtons />
          </div>
        </div>
      </div>
    </section>
  )
}
