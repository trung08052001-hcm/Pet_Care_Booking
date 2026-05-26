import { z } from 'zod'

const dashboardSummarySchema = z.object({
  metrics: z.array(
    z.object({
      label: z.string(),
      value: z.string(),
      hint: z.string(),
    }),
  ),
  checklist: z.array(z.string()),
})

export type DashboardSummary = z.infer<typeof dashboardSummarySchema>

const summarySeed: DashboardSummary = {
  metrics: [
    {
      label: 'Routing',
      value: 'React Router',
      hint: 'San sang cho dashboard, auth va nested layout.',
    },
    {
      label: 'Server state',
      value: 'TanStack Query',
      hint: 'Xu ly cache, loading, retry va invalidation.',
    },
    {
      label: 'Client state',
      value: 'Zustand',
      hint: 'Phu hop cho UI state, auth state va preferences.',
    },
    {
      label: 'UI system',
      value: 'Tailwind CSS',
      hint: 'Di nhanh luc build feature nhung van giu duoc consistency.',
    },
  ],
  checklist: [
    'Tao feature moi trong src/features theo domain.',
    'Dat query logic trong api va hook gan feature.',
    'Dung src/shared cho component, lib, config duoc tai su dung.',
    'Quan ly env bang file .env va prefix VITE_.',
  ],
}

export async function getDashboardSummary(): Promise<DashboardSummary> {
  await new Promise((resolve) => window.setTimeout(resolve, 250))

  return dashboardSummarySchema.parse(summarySeed)
}
