import { createBrowserRouter } from 'react-router-dom'
import { ForgotPasswordPage } from '@/pages/auth/ForgotPasswordPage'
import { LoginPage } from '@/pages/auth/LoginPage'
import { RegisterPage } from '@/pages/auth/RegisterPage'
import { ResetPasswordPage } from '@/pages/auth/ResetPasswordPage'
import { VerifyOtpPage } from '@/pages/auth/VerifyOtpPage'
import { HomePage } from '@/pages/home/HomePage'
import { NotFoundPage } from '@/pages/not-found/NotFoundPage'
import { AppShell } from '@/shared/components/layout/AppShell'

export const router = createBrowserRouter([
  {
    path: '/',
    element: <AppShell />,
    children: [
      { index: true, element: <HomePage /> },
      { path: 'login', element: <LoginPage /> },
      { path: 'register', element: <RegisterPage /> },
      { path: 'forgot-password', element: <ForgotPasswordPage /> },
      { path: 'forgot-password/otp', element: <VerifyOtpPage /> },
      { path: 'forgot-password/reset', element: <ResetPasswordPage /> },
    ],
    errorElement: <NotFoundPage />,
  },
  {
    path: '*',
    element: <NotFoundPage />,
  },
])
