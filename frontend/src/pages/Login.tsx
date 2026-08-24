import { useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { requestOtp } from '../api/auth'
import { LoginHero } from '../components/auth/LoginHero'
import { ThemeToggle } from '../components/ThemeToggle'

const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

export function Login() {
  const navigate = useNavigate()
  const location = useLocation()
  const from = (location.state as { from?: { pathname: string; search?: string; state?: unknown } } | null)?.from

  const [email, setEmail] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [emailError, setEmailError] = useState<string | null>(null)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()

    if (!EMAIL_PATTERN.test(email)) {
      setEmailError('Invalid email address')
      return
    }
    setEmailError(null)
    setSubmitting(true)
    await requestOtp(email)
    navigate('/verify-otp', { state: { email, from } })
  }

  return (
    <div className="relative flex min-h-screen flex-col text-text-primary lg:flex-row">
      <LoginHero />

      <div className="relative z-10 flex flex-1 items-center justify-center px-4 py-10 sm:px-6">
        <div className="absolute right-5 top-5 hidden lg:block">
          <ThemeToggle />
        </div>

        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className="relative w-full max-w-[480px] rounded-[22px] border border-border bg-surface/70 p-8 shadow-[0_20px_60px_rgba(0,0,0,0.35)] backdrop-blur-2xl sm:p-11"
        >
          <form onSubmit={handleSubmit} className="flex flex-col gap-5">
            <div>
              <div className="font-display text-[30px] font-bold tracking-tight">Welcome Back</div>
              <div className="mt-2 text-[13.5px] text-text-secondary">Enter your email and we'll send you a one-time login code.</div>
            </div>

            <div className="flex flex-col gap-1.5">
              <label htmlFor="login-email" className="text-xs font-semibold text-text-secondary">
                Email Address
              </label>
              <div
                className={`flex items-center gap-2.5 rounded-[12px] border bg-white/[0.035] px-4 py-3.5 transition-colors duration-200 focus-within:border-accent focus-within:shadow-[0_0_0_3px_rgba(245,166,35,0.10)] ${
                  emailError ? 'border-danger' : 'border-border'
                }`}
              >
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="flex-shrink-0 text-text-muted">
                  <rect x="2" y="4" width="20" height="16" rx="2" /><path d="m22 6-10 7L2 6" />
                </svg>
                <input
                  id="login-email"
                  type="email"
                  required
                  autoFocus
                  autoComplete="off"
                  placeholder="Enter your email"
                  value={email}
                  onChange={(e) => {
                    setEmail(e.target.value)
                    if (emailError) setEmailError(null)
                  }}
                  aria-invalid={!!emailError}
                  aria-describedby={emailError ? 'login-email-error' : undefined}
                  className="w-full bg-transparent text-sm text-text-primary placeholder:text-text-muted outline-none!"
                />
              </div>
              {emailError && (
                <span id="login-email-error" className="text-xs text-danger">
                  {emailError}
                </span>
              )}
            </div>

            <button
              type="submit"
              disabled={submitting}
              className="group mt-1 flex cursor-pointer items-center justify-center gap-2 rounded-xl bg-accent py-3.5 text-[15px] font-bold text-obsidian shadow-[0_8px_30px_rgba(245,166,35,0.30)] transition-[filter,transform] duration-200 hover:-translate-y-0.5 hover:brightness-110 disabled:cursor-not-allowed disabled:opacity-60 disabled:hover:translate-y-0"
            >
              {submitting ? (
                <>
                  <span className="h-4 w-4 animate-spin rounded-full border-2 border-obsidian/25 border-t-obsidian" />
                  Sending code…
                </>
              ) : (
                <>
                  Send Code
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2.4} strokeLinecap="round" strokeLinejoin="round" className="transition-transform duration-200 group-hover:translate-x-0.5">
                    <path d="M5 12h14M13 6l6 6-6 6" />
                  </svg>
                </>
              )}
            </button>

            <div className="text-center text-xs text-text-muted">We'll email you a 6-digit code — no password needed.</div>
          </form>
        </motion.div>
      </div>
    </div>
  )
}
