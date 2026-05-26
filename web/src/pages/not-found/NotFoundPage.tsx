import { Link, useRouteError } from 'react-router-dom'

function getErrorMessage(error: unknown) {
  if (error instanceof Error) {
    return error.message
  }

  return 'Route ban truy cap khong ton tai hoac da gap loi khi render.'
}

export function NotFoundPage() {
  const error = useRouteError()

  return (
    <div className="flex min-h-[60vh] items-center justify-center">
      <div className="w-full max-w-xl rounded-[28px] border border-[var(--border-soft)] bg-[var(--surface-elevated)] p-8 text-center shadow-[var(--shadow-soft)]">
        <p className="text-sm font-semibold tracking-[0.3em] text-[var(--text-muted)] uppercase">
          404 / Route error
        </p>
        <h2 className="mt-4 text-3xl font-semibold text-[var(--text-primary)]">
          Trang ban tim khong co trong base hien tai.
        </h2>
        <p className="mt-4 text-sm leading-6 text-[var(--text-secondary)]">
          {getErrorMessage(error)}
        </p>
        <Link
          to="/"
          className="mt-6 inline-flex rounded-full bg-[var(--accent)] px-5 py-3 text-sm font-semibold text-slate-950 transition hover:opacity-90"
        >
          Quay ve trang tong quan
        </Link>
      </div>
    </div>
  )
}
