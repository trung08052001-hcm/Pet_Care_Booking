import { Link } from 'react-router-dom'
import { useAuthStore } from '@/features/auth/store/auth.store'
import { env } from '@/shared/config/env'

const navItems = [
  { to: '/#services', label: 'Services' },
  { to: '/#reviews', label: 'Reviews' },
  { to: '/#blog', label: 'Blog' },
  { to: '/#about', label: 'About Us' },
]

export function SiteHeader() {
  const session = useAuthStore((state) => state.session)
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated)
  const clearSession = useAuthStore((state) => state.clearSession)

  return (
    <header className="sticky top-0 z-20 border-b border-[var(--border-soft)] bg-[color:var(--surface-primary)]/90 backdrop-blur">
      <div className="mx-auto flex max-w-6xl items-center justify-between gap-4 px-5 py-4 lg:px-6">
        <Link to="/" className="flex items-center gap-2 text-sm font-semibold">
          <span className="flex h-8 w-8 items-center justify-center rounded-full bg-[var(--accent-soft)] text-[var(--accent-strong)]">
            P
          </span>
          <span>{env.appName}</span>
        </Link>

        <nav className="hidden items-center gap-7 text-sm text-[var(--text-secondary)] md:flex">
          {navItems.map((item) => (
            <Link
              key={item.to}
              to={item.to}
              className="transition hover:text-[var(--text-primary)]"
            >
              {item.label}
            </Link>
          ))}
        </nav>

        {isAuthenticated && session ? (
          <div className="flex items-center gap-3">
            <div className="hidden text-right sm:block">
              <p className="text-sm font-semibold text-[var(--text-primary)]">
                {session.user.fullName}
              </p>
              <p className="text-xs text-[var(--text-secondary)]">
                {session.user.email}
              </p>
            </div>
            <button
              type="button"
              onClick={clearSession}
              className="rounded-full border border-[var(--border-strong)] px-5 py-2 text-sm font-medium text-[var(--text-primary)] transition hover:bg-white/70"
            >
              Sign out
            </button>
          </div>
        ) : (
          <div className="flex items-center gap-3">
            <Link
              to="/login"
              className="hidden rounded-full border border-[var(--border-strong)] px-5 py-2 text-sm font-medium text-[var(--text-primary)] transition hover:bg-white/70 sm:inline-flex"
            >
              Sign in
            </Link>
            <Link
              to="/register"
              className="rounded-full bg-[var(--accent)] px-5 py-2 text-sm font-semibold text-[var(--accent-contrast)] shadow-[0_10px_24px_rgba(245,140,62,0.26)] transition hover:translate-y-[-1px]"
            >
              Book Now
            </Link>
          </div>
        )}
      </div>
    </header>
  )
}
