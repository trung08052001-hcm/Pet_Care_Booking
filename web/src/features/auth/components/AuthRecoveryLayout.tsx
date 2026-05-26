import type { PropsWithChildren } from 'react'
import { Link } from 'react-router-dom'

interface AuthRecoveryLayoutProps extends PropsWithChildren {
  step: number
  title: string
  description: string
  badge: string
  asideTitle: string
  asideDescription: string
}

export function AuthRecoveryLayout({
  step,
  title,
  description,
  badge,
  asideTitle,
  asideDescription,
  children,
}: AuthRecoveryLayoutProps) {
  return (
    <section className="grid flex-1 items-center gap-6 py-3 lg:grid-cols-[0.92fr_1.08fr] lg:py-8">
      <aside className="hidden min-h-[720px] overflow-hidden rounded-[34px] bg-[linear-gradient(180deg,#f6d3a7_0%,#c98143_55%,#8e4c18_100%)] shadow-[var(--shadow-soft)] lg:block">
        <div className="flex h-full flex-col justify-between p-8 text-white">
          <div>
            <p className="text-[11px] font-semibold tracking-[0.22em] text-white/75 uppercase">
              Password recovery
            </p>
            <h2 className="mt-4 max-w-xs text-4xl leading-tight font-semibold">
              {asideTitle}
            </h2>
            <p className="mt-4 max-w-sm text-sm leading-7 text-white/85">
              {asideDescription}
            </p>
          </div>

          <div className="rounded-[28px] border border-white/18 bg-white/10 p-5 backdrop-blur">
            <div className="flex items-center gap-2">
              {[1, 2, 3].map((item) => (
                <div
                  key={item}
                  className={`h-2 flex-1 rounded-full ${item <= step ? 'bg-white' : 'bg-white/30'}`}
                />
              ))}
            </div>
            <p className="mt-4 text-sm font-medium text-white/90">
              Step {step} of 3
            </p>
            <p className="mt-2 text-xs leading-6 text-white/75">
              Secure access recovery for your PawSitive Care account.
            </p>
          </div>
        </div>
      </aside>

      <div className="mx-auto flex w-full max-w-[460px] items-center">
        <div className="w-full rounded-[34px] bg-[var(--surface-elevated)] p-6 shadow-[var(--shadow-soft)] md:p-8">
          <p className="text-xs font-semibold tracking-[0.2em] text-[var(--text-muted)] uppercase">
            {badge}
          </p>
          <h1 className="mt-3 text-4xl font-semibold tracking-tight text-[var(--text-primary)]">
            {title}
          </h1>
          <p className="mt-3 text-sm leading-7 text-[var(--text-secondary)]">
            {description}
          </p>

          <div className="mt-8">{children}</div>

          <div className="mt-8 flex items-center justify-between border-t border-[var(--border-soft)] pt-5 text-sm text-[var(--text-secondary)]">
            <Link
              to="/login"
              className="font-medium transition hover:text-[var(--accent-strong)]"
            >
              Back to login
            </Link>
            <span>Need help? Contact support</span>
          </div>
        </div>
      </div>
    </section>
  )
}
