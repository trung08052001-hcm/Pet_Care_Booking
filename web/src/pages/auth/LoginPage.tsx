import { useEffect, useMemo, useState, type ChangeEvent, type FormEvent } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import {
  AuthDivider,
  AuthField,
  SocialButtons,
} from '@/features/auth/components/AuthControls'
import { useLogin } from '@/features/auth/hooks/use-login'
import {
  getFieldErrors,
  loginFormSchema,
  type FormErrors,
  type LoginFormValues,
} from '@/features/auth/lib/auth.validators'
import { useAuthStore } from '@/features/auth/store/auth.store'
import { getApiErrorMessage } from '@/shared/lib/http/get-api-error-message'

const loginImage =
  'https://images.unsplash.com/photo-1518717758536-85ae29035b6d?auto=format&fit=crop&w=900&q=80'

export function LoginPage() {
  const navigate = useNavigate()
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated)
  const loginMutation = useLogin()
  const [form, setForm] = useState<LoginFormValues>({
    identifier: '',
    password: '',
  })
  const [errors, setErrors] = useState<FormErrors<keyof LoginFormValues>>({})

  const apiError = useMemo(
    () => (loginMutation.isError ? getApiErrorMessage(loginMutation.error) : null),
    [loginMutation.error, loginMutation.isError],
  )

  useEffect(() => {
    if (isAuthenticated) {
      navigate('/', { replace: true })
    }
  }, [isAuthenticated, navigate])

  function handleChange(
    event: ChangeEvent<HTMLInputElement>,
    field: keyof LoginFormValues,
  ) {
    setForm((previous) => ({
      ...previous,
      [field]: event.target.value,
    }))
    setErrors((previous) => ({
      ...previous,
      [field]: undefined,
    }))
  }

  function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()

    const parsed = loginFormSchema.safeParse(form)
    if (!parsed.success) {
      setErrors(getFieldErrors<keyof LoginFormValues>(parsed.error))
      return
    }

    setErrors({})
    loginMutation.mutate(parsed.data, {
      onSuccess: () => {
        navigate('/', { replace: true })
      },
    })
  }

  return (
    <section className="grid flex-1 items-center gap-6 py-3 lg:grid-cols-[0.9fr_1.1fr] lg:py-8">
      <aside className="hidden rounded-[34px] bg-[#204f50] p-8 shadow-[var(--shadow-soft)] lg:flex lg:min-h-[720px] lg:items-center lg:justify-center">
        <div className="relative">
          <div className="absolute inset-x-6 top-8 bottom-6 rounded-[40px] bg-black/18 blur-2xl" />
          <div className="relative w-[260px] rounded-[42px] border-[10px] border-[#171717] bg-[#0f0f0f] p-2 shadow-[0_24px_50px_rgba(0,0,0,0.32)]">
            <div className="mx-auto mt-1 h-5 w-28 rounded-full bg-[#151515]" />
            <div
              className="mt-3 overflow-hidden rounded-[30px] bg-cover bg-center"
              style={{ backgroundImage: `url(${loginImage})` }}
            >
              <div className="flex min-h-[470px] items-end bg-[linear-gradient(180deg,rgba(255,255,255,0.08)_0%,rgba(0,0,0,0.55)_100%)] p-5">
                <div>
                  <p className="max-w-[180px] text-3xl leading-tight font-semibold text-white">
                    Dedicated care for your furry family.
                  </p>
                  <p className="mt-3 text-xs leading-5 text-white/80">
                    Comfort, routine and loving attention for every stay.
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </aside>

      <div className="mx-auto flex w-full max-w-[420px] items-center">
        <div className="w-full rounded-[34px] bg-[var(--surface-elevated)] p-6 shadow-[var(--shadow-soft)] md:p-8">
          <p className="text-xs font-semibold tracking-[0.2em] text-[var(--text-muted)] uppercase">
            Welcome back
          </p>
          <h1 className="mt-3 text-4xl font-semibold tracking-tight text-[var(--text-primary)]">
            Log in
          </h1>
          <p className="mt-3 text-sm leading-7 text-[var(--text-secondary)]">
            Sign in to manage your bookings, care updates and your pet&apos;s
            daily routine.
          </p>

          <form className="mt-8 space-y-4" onSubmit={handleSubmit}>
            {apiError ? (
              <div className="rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-600">
                {apiError}
              </div>
            ) : null}

            <AuthField
              label="Email or phone number"
              type="text"
              name="identifier"
              autoComplete="username"
              placeholder="you@example.com or 0901234567"
              value={form.identifier}
              onChange={(event) => handleChange(event, 'identifier')}
              error={errors.identifier}
            />
            <AuthField
              label="Password"
              type="password"
              name="password"
              autoComplete="current-password"
              placeholder="Enter your password"
              value={form.password}
              onChange={(event) => handleChange(event, 'password')}
              error={errors.password}
            />

            <div className="flex items-center justify-between gap-4">
              <label className="flex items-center gap-3 text-sm text-[var(--text-secondary)]">
                <input
                  type="checkbox"
                  className="h-4 w-4 rounded border-[var(--border-soft)] accent-[var(--accent)]"
                />
                Remember me
              </label>

              <Link
                to="/forgot-password"
                className="text-sm font-semibold text-[var(--accent-strong)] transition hover:opacity-80"
              >
                Forgot password?
              </Link>
            </div>

            <button
              type="submit"
              disabled={loginMutation.isPending}
              className="w-full rounded-xl bg-[var(--accent)] px-5 py-3 text-sm font-semibold text-[var(--accent-contrast)] shadow-[0_14px_24px_rgba(245,140,62,0.25)]"
            >
              {loginMutation.isPending ? 'Signing in...' : 'Login'}
            </button>
          </form>

          <p className="mt-5 text-center text-sm text-[var(--text-secondary)]">
            No account yet?{' '}
            <Link
              to="/register"
              className="font-semibold text-[var(--accent-strong)]"
            >
              Create one
            </Link>
          </p>

          <div className="mt-6">
            <AuthDivider label="or continue with" />
          </div>

          <div className="mt-6">
            <SocialButtons />
          </div>

          <p className="mt-8 text-center text-xs leading-6 text-[var(--text-muted)]">
            Trusted care, instant updates and premium support for every pet.
          </p>
        </div>
      </div>
    </section>
  )
}
