import { Outlet } from 'react-router-dom'
import { SiteFooter } from '@/shared/components/layout/SiteFooter'
import { SiteHeader } from '@/shared/components/layout/SiteHeader'

export function AppShell() {
  return (
    <div className="min-h-screen bg-[var(--surface-primary)] text-[var(--text-primary)]">
      <SiteHeader />

      <main className="mx-auto flex min-h-[calc(100vh-73px)] w-full max-w-6xl flex-1 flex-col px-5 py-6 lg:px-6">
        <Outlet />
      </main>

      <SiteFooter />
    </div>
  )
}
