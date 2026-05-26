# Product Web Starter

Base web React duoc setup theo kieu du an product nho-va-vua, de ban co the mo rong thanh dashboard, admin, SaaS app hoac internal tool.

## Stack

- `Vite + React 19 + TypeScript`
- `React Router` cho page va layout
- `TanStack Query` cho server state
- `Zustand` cho client state
- `Tailwind CSS v4` cho UI
- `ESLint + Prettier` cho code quality
- `Zod` cho env/schema validation

## Run project

```bash
npm install
npm run dev
```

## Scripts

```bash
npm run dev
npm run build
npm run lint
npm run lint:fix
npm run typecheck
npm run format
npm run check
```

## Folder structure

```txt
src/
  app/        # router, providers, bootstrap
  features/   # domain-level logic
  pages/      # route pages
  shared/     # shared components, config, libs, stores
  styles/     # global styles
```

## Env

Tao file `.env` tu `.env.example`:

```bash
VITE_APP_NAME=Product Web Starter
VITE_API_BASE_URL=https://api.example.com
```

## Cach mo rong tiep

1. Tao feature moi trong `src/features/<feature-name>`.
2. Dat API client/query trong folder feature do.
3. Tao page trong `src/pages` va dang ky route tai `src/app/router.tsx`.
4. Dua component tai su dung vao `src/shared/components`.

## Goi y cho ban

Neu ban moi quen ReactJS, hay bat dau theo thu tu nay:

1. Hieu `src/app/router.tsx` de biet route duoc khai bao o dau.
2. Xem `src/pages/home/HomePage.tsx` de hieu mot page duoc render ra sao.
3. Xem `src/features/dashboard/api/get-dashboard-summary.ts` de thay cach tach logic async khoi UI.
4. Xem `src/shared/store/ui.store.ts` de hieu cach quan ly state nho bang Zustand.
