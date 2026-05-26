import { Link } from 'react-router-dom'

const footerLinks = [
  { to: '/#about', label: 'About us' },
  { to: '/#services', label: 'Services' },
  { to: '/#contact', label: 'Contact' },
  { to: '/#reviews', label: 'Reviews' },
]

const authLinks = [
  { to: '/login', label: 'Login' },
  { to: '/register', label: 'Register' },
  { to: '/forgot-password', label: 'Reset password' },
]

export function SiteFooter() {
  return (
    <footer id="blog" className="border-t border-[var(--border-soft)]">
      <div className="mx-auto flex max-w-6xl flex-col gap-6 px-5 py-8 text-sm text-[var(--text-secondary)] lg:flex-row lg:items-end lg:justify-between lg:px-6">
        <div>
          <p className="font-semibold text-[var(--text-primary)]">
            PawSitive Care
          </p>
          <p className="mt-2 max-w-sm text-xs leading-6">
            Premium daycare, grooming and wellness support for pets who deserve
            thoughtful care.
          </p>
        </div>

        <div className="grid gap-6 sm:grid-cols-2">
          <div>
            <p className="text-xs font-semibold tracking-[0.18em] uppercase">
              Explore
            </p>
            <div className="mt-3 flex flex-col gap-2 text-xs">
              {footerLinks.map((item) => (
                <Link
                  key={item.to}
                  to={item.to}
                  className="hover:text-[var(--text-primary)]"
                >
                  {item.label}
                </Link>
              ))}
            </div>
          </div>

          <div>
            <p className="text-xs font-semibold tracking-[0.18em] uppercase">
              Account
            </p>
            <div className="mt-3 flex flex-col gap-2 text-xs">
              {authLinks.map((item) => (
                <Link
                  key={item.to}
                  to={item.to}
                  className="hover:text-[var(--text-primary)]"
                >
                  {item.label}
                </Link>
              ))}
            </div>
          </div>
        </div>
      </div>
    </footer>
  )
}
