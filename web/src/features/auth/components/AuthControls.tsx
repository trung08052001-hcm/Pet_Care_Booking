import type { InputHTMLAttributes, ReactNode } from 'react'

type AuthFieldProps = InputHTMLAttributes<HTMLInputElement> & {
  label: string
  trailing?: ReactNode
  error?: string
}

export function AuthField({
  label,
  trailing,
  error,
  className,
  ...props
}: AuthFieldProps) {
  return (
    <label className="block">
      <span className="mb-2 block text-xs font-semibold text-[var(--text-secondary)]">
        {label}
      </span>
      <div className="relative">
        <input
          {...props}
          aria-invalid={Boolean(error)}
          className={`h-11 w-full rounded-xl border bg-white/80 px-4 ${trailing ? 'pr-20' : ''} text-sm text-[var(--text-primary)] transition outline-none placeholder:text-[#b9a898] focus:border-[var(--accent)] focus:bg-white ${error ? 'border-red-300' : 'border-[var(--border-soft)]'} ${className ?? ''}`}
        />
        {trailing ? (
          <span className="absolute inset-y-0 right-4 flex items-center text-xs text-[var(--text-secondary)]">
            {trailing}
          </span>
        ) : null}
      </div>
      {error ? (
        <span className="mt-2 block text-xs font-medium text-red-500">{error}</span>
      ) : null}
    </label>
  )
}

export function AuthDivider({ label }: { label: string }) {
  return (
    <div className="flex items-center gap-3 text-xs text-[var(--text-muted)]">
      <div className="h-px flex-1 bg-[var(--border-soft)]" />
      <span>{label}</span>
      <div className="h-px flex-1 bg-[var(--border-soft)]" />
    </div>
  )
}

const providers = [
  { name: 'Google', mark: 'G' },
  { name: 'Zalo', mark: 'Z' },
]

export function SocialButtons() {
  return (
    <div className="grid gap-3 sm:grid-cols-2">
      {providers.map((provider) => (
        <button
          key={provider.name}
          type="button"
          className="flex items-center justify-center gap-2 rounded-xl border border-[var(--border-soft)] bg-white/75 px-4 py-3 text-sm font-medium text-[var(--text-primary)] transition hover:bg-white"
        >
          <span className="flex h-6 w-6 items-center justify-center rounded-full bg-[var(--surface-secondary)] text-xs font-bold">
            {provider.mark}
          </span>
          {provider.name}
        </button>
      ))}
    </div>
  )
}
