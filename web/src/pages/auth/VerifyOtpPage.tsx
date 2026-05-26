import type { FormEvent } from 'react'
import { Link, useLocation, useNavigate } from 'react-router-dom'
import { AuthRecoveryLayout } from '@/features/auth/components/AuthRecoveryLayout'

interface VerifyOtpLocationState {
  phone?: string
}

function handleSubmit(
  event: FormEvent<HTMLFormElement>,
  navigate: ReturnType<typeof useNavigate>,
  phone: string,
) {
  event.preventDefault()

  void navigate('/forgot-password/reset', {
    state: {
      phone,
    },
  })
}

export function VerifyOtpPage() {
  const navigate = useNavigate()
  const location = useLocation()
  const state = location.state as VerifyOtpLocationState | null
  const phone = state?.phone ?? '+84 9xx xxx xxx'

  return (
    <AuthRecoveryLayout
      step={2}
      badge="Verify OTP"
      title="Enter verification code"
      description={`We sent a 6-digit code to ${phone}. Please enter it below to continue resetting your password.`}
      asideTitle="One more step to verify you."
      asideDescription="For your security, the reset flow only continues after the OTP is confirmed successfully."
    >
      <form
        className="space-y-5"
        onSubmit={(event) => handleSubmit(event, navigate, phone)}
      >
        <div>
          <span className="mb-2 block text-xs font-semibold text-[var(--text-secondary)]">
            OTP code
          </span>
          <div className="grid grid-cols-6 gap-2 md:gap-3">
            {Array.from({ length: 6 }, (_, index) => (
              <input
                key={index}
                inputMode="numeric"
                maxLength={1}
                aria-label={`OTP digit ${index + 1}`}
                className="h-12 rounded-xl border border-[var(--border-soft)] bg-white/80 text-center text-lg font-semibold text-[var(--text-primary)] transition outline-none focus:border-[var(--accent)] focus:bg-white"
              />
            ))}
          </div>
        </div>

        <div className="flex items-center justify-between text-sm text-[var(--text-secondary)]">
          <span>Code expires in 01:30</span>
          <Link
            to="/forgot-password"
            className="font-medium text-[var(--accent-strong)]"
          >
            Resend OTP
          </Link>
        </div>

        <button
          type="submit"
          className="w-full rounded-xl bg-[var(--accent)] px-5 py-3 text-sm font-semibold text-[var(--accent-contrast)] shadow-[0_14px_24px_rgba(245,140,62,0.25)]"
        >
          Verify OTP
        </button>
      </form>
    </AuthRecoveryLayout>
  )
}
