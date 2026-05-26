import { ReactQueryDevtools } from '@tanstack/react-query-devtools'
import { QueryClientProvider } from '@tanstack/react-query'
import { useEffect, type PropsWithChildren } from 'react'
import { queryClient } from '@/shared/lib/query/query-client'
import { useUiStore } from '@/shared/store/ui.store'

function ThemeSync() {
  const theme = useUiStore((state) => state.theme)

  useEffect(() => {
    document.documentElement.dataset.theme = theme
  }, [theme])

  return null
}

export function AppProviders({ children }: PropsWithChildren) {
  return (
    <QueryClientProvider client={queryClient}>
      <ThemeSync />
      {children}
      {import.meta.env.DEV ? (
        <ReactQueryDevtools initialIsOpen={false} />
      ) : null}
    </QueryClientProvider>
  )
}
