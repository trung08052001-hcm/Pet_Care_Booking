import type { FormEvent } from 'react'
import { useNavigate } from 'react-router-dom'
import { AuthRecoveryLayout } from '@/features/auth/components/AuthRecoveryLayout'
import { AuthField } from '@/features/auth/components/AuthControls'

function handleSubmit(
  event: FormEvent<HTMLFormElement>,
  navigate: ReturnType<typeof useNavigate>,
) {
  event.preventDefault()

  const formData = new FormData(event.currentTarget)
  const phoneValue = formData.get('phone')
  const phone = typeof phoneValue === 'string' ? phoneValue.trim() : ''

  void navigate('/forgot-password/otp', {
    state: {
      phone: phone || '+84 9xx xxx xxx',
    },
  })
}

export function ForgotPasswordPage() {
  const navigate = useNavigate()

  return (
    <AuthRecoveryLayout
      step={1}
      badge="Forgot password"
      title="Reset via phone number"
      description="Enter the phone number linked to your account. We will send a one-time verification code to continue."
      asideTitle="Recover your account safely."
      asideDescription="Use your registered phone number to verify ownership and continue to the next step."
    >
      <form
        className="space-y-4"
        onSubmit={(event) => handleSubmit(event, navigate)}
      >
        <AuthField
          label="Phone number"
          type="tel"
          name="phone"
          autoComplete="tel"
          placeholder="+84 987 654 321"
        />

        <button
          type="submit"
          className="w-full rounded-xl bg-[var(--accent)] px-5 py-3 text-sm font-semibold text-[var(--accent-contrast)] shadow-[0_14px_24px_rgba(245,140,62,0.25)]"
        >
          Continue
        </button>
      </form>
    </AuthRecoveryLayout>
  )
}
