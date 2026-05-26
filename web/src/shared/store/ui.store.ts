import { create } from 'zustand'
import { createJSONStorage, persist } from 'zustand/middleware'

type Theme = 'dark' | 'light'

interface UiState {
  theme: Theme
  toggleTheme: () => void
}

export const useUiStore = create<UiState>()(
  persist(
    (set, get) => ({
      theme: 'light',
      toggleTheme: () =>
        set({
          theme: get().theme === 'dark' ? 'light' : 'dark',
        }),
    }),
    {
      name: 'product-web-ui',
      storage: createJSONStorage(() => localStorage),
    },
  ),
)
