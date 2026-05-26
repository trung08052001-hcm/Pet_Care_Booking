import type { FormEvent } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { AuthRecoveryLayout } from '@/features/auth/components/AuthRecoveryLayout'
import { AuthField } from '@/features/auth/components/AuthControls'

interface ResetPasswordLocationState {
  phone?: string
}

function handleSubmit(
  event: FormEvent<HTMLFormElement>,
  navigate: ReturnType<typeof useNavigate>,
) {
  event.preventDefault()
  void navigate('/login')
}

export function ResetPasswordPage() {
  const navigate = useNavigate()
  const location = useLocation()
  const state = location.state as ResetPasswordLocationState | null
  const phone = state?.phone ?? 'your verified number'

  return (
    <AuthRecoveryLayout
      step={3}
      badge="Create new password"
      title="Set a new password"
      description={`Your identity was verified with ${phone}. Create a strong new password and confirm it below.`}
      asideTitle="You are almost done."
      asideDescription="Choose a secure password with a mix of letters, numbers and symbols so your account stays protected."
    >
      <form
        className="space-y-4"
        onSubmit={(event) => handleSubmit(event, navigate)}
      >
        <AuthField
          label="New password"
          type="password"
          name="newPassword"
          autoComplete="new-password"
          placeholder="Create a new password"
        />
        <AuthField
          label="Confirm new password"
          type="password"
          name="confirmPassword"
          autoComplete="new-password"
          placeholder="Repeat your new password"
        />

        <ul className="rounded-2xl border border-[var(--border-soft)] bg-white/70 px-4 py-3 text-sm leading-7 text-[var(--text-secondary)]">
          <li>Use at least 8 characters.</li>
          <li>Include uppercase, lowercase and a number.</li>
          <li>A symbol will make it even stronger.</li>
        </ul>

        <button
          type="submit"
          className="w-full rounded-xl bg-[var(--accent)] px-5 py-3 text-sm font-semibold text-[var(--accent-contrast)] shadow-[0_14px_24px_rgba(245,140,62,0.25)]"
        >
          Save New Password
        </button>
      </form>
    </AuthRecoveryLayout>
  )
}
