import { useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { AnimatePresence, motion, useReducedMotion } from 'framer-motion'
import { requestOtp, verifyOtp, AuthError } from '../api/auth'
import { LoginHero } from '../components/auth/LoginHero'
import { ThemeToggle } from '../components/ThemeToggle'
import { OtpInput } from '../components/OtpInput'
import { useCountdown } from '../hooks/useCountdown'

const OTP_TTL_MINUTES = 5 // user-service application.yml: otp.ttl-minutes
const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

export function OtpVerify() {
  const navigate = useNavigate()
  const location = useLocation()
  const routeState = location.state as { from?: { pathname: string; search?: string; state?: unknown }; email?: string } | null
  const from = routeState?.from
  const prefilledEmail = routeState?.email

  const [step, setStep] = useState<'email' | 'code'>(prefilledEmail ? 'code' : 'email')
  const [email, setEmail] = useState(prefilledEmail ?? '')
  const [emailError, setEmailError] = useState<string | null>(null)
  const [code, setCode] = useState('')
  const [sentAt, setSentAt] = useState<Date | null>(prefilledEmail ? new Date() : null)
  const [submitting, setSubmitting] = useState(false)
  const [success, setSuccess] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [fallbackNotice, setFallbackNotice] = useState(false)
  const prefersReducedMotion = useReducedMotion()

  const resendCountdown = useCountdown(sentAt ? new Date(sentAt.getTime() + OTP_TTL_MINUTES * 60_000) : null)

  function goToDestination() {
    navigate((from?.pathname ?? '/') + (from?.search ?? ''), { state: from?.state, replace: true })
  }

  async function handleSendCode(e: React.FormEvent) {
    e.preventDefault()
    if (!EMAIL_PATTERN.test(email)) {
      setEmailError('Invalid email address')
      return
    }
    setEmailError(null)
    setSubmitting(true)
    await requestOtp(email)
    setSentAt(new Date())
    setStep('code')
    setSubmitting(false)
  }

  async function handleResend() {
    if (!resendCountdown.expired) return
    setError(null)
    await requestOtp(email)
    setSentAt(new Date())
    setCode('')
  }

  async function handleVerify(e: React.FormEvent) {
    e.preventDefault()
    if (code.length !== 6) return
    setSubmitting(true)
    setError(null)
    try {
      const { isFallback } = await verifyOtp(email, code)
      if (isFallback) setFallbackNotice(true)
      if (prefersReducedMotion) {
        goToDestination()
        return
      }
      setSuccess(true)
      setTimeout(goToDestination, 750)
    } catch (err) {
      setError(err instanceof AuthError ? err.message : 'Connection failed. Please try again.')
      setSubmitting(false)
    }
  }

  return (
    <div className="relative flex min-h-screen flex-col text-text-primary lg:flex-row">
      <LoginHero />

      <div className="relative z-10 flex flex-1 items-center justify-center px-4 py-10 sm:px-6">
        <div className="absolute right-5 top-5 hidden lg:block">
          <ThemeToggle />
        </div>

        <div className="relative w-full max-w-[480px] rounded-[22px] border border-border bg-surface/70 p-8 shadow-[0_20px_60px_rgba(0,0,0,0.35)] backdrop-blur-2xl sm:p-11">
          <AnimatePresence mode="wait">
            {success ? (
              <motion.div
                key="success"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                className="flex flex-col items-center gap-3 py-10 text-center"
              >
                <div className="flex h-14 w-14 items-center justify-center rounded-full bg-accent-dim text-gold">
                  <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2.4} strokeLinecap="round" strokeLinejoin="round">
                    <path d="M20 6 9 17l-5-5" />
                  </svg>
                </div>
                <div className="font-display text-xl font-bold">Welcome back</div>
                <div className="text-[13.5px] text-text-secondary">Taking you to TickIT…</div>
              </motion.div>
            ) : step === 'email' ? (
              <motion.form key="email" onSubmit={handleSendCode} initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="flex flex-col gap-5">
                <div>
                  <div className="font-display text-[30px] font-bold tracking-tight">Log in with a code</div>
                  <div className="mt-2 text-[13.5px] text-text-secondary">We'll email you a 6-digit code — no password needed.</div>
                </div>

                <div className="flex flex-col gap-1.5">
                  <label htmlFor="otp-email" className="text-xs font-semibold text-text-secondary">
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
                      id="otp-email"
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
                      aria-describedby={emailError ? 'otp-email-error' : undefined}
                      className="w-full bg-transparent text-sm text-text-primary placeholder:text-text-muted outline-none!"
                    />
                  </div>
                  {emailError && (
                    <span id="otp-email-error" className="text-xs text-danger">
                      {emailError}
                    </span>
                  )}
                </div>

                <button
                  type="submit"
                  disabled={submitting}
                  className="mt-1 rounded-xl bg-accent py-3.5 text-[15px] font-bold text-obsidian shadow-[0_8px_30px_rgba(245,166,35,0.30)] transition-[filter,transform] duration-200 hover:-translate-y-0.5 hover:brightness-110 disabled:cursor-not-allowed disabled:opacity-60 disabled:hover:translate-y-0 cursor-pointer"
                >
                  {submitting ? 'Sending…' : 'Send Code'}
                </button>
              </motion.form>
            ) : (
              <motion.form key="code" onSubmit={handleVerify} initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="flex flex-col gap-6">
                <div>
                  <div className="font-display text-[30px] font-bold tracking-tight">Enter the code</div>
                  <div className="mt-2 text-[13.5px] text-text-secondary">
                    We sent a 6-digit code to <span className="font-semibold text-text-primary">{email}</span>
                  </div>
                </div>

                {error && (
                  <div role="alert" className="rounded-lg border border-danger/35 bg-danger/10 px-3.5 py-2.5 text-[13px] text-danger">
                    {error}
                  </div>
                )}
                {fallbackNotice && (
                  <div className="rounded-lg border border-gold/30 bg-accent-dim px-3.5 py-2.5 text-[13px] text-gold">
                    Couldn't reach the auth API — signed in with a simulated session for local testing.
                  </div>
                )}

                <OtpInput value={code} onChange={setCode} disabled={submitting} />

                <div className="text-[12.5px] text-text-secondary">
                  {resendCountdown.expired ? (
                    <button type="button" onClick={handleResend} className="font-semibold text-gold cursor-pointer">Resend code</button>
                  ) : (
                    <>Didn't get it? Resend in <span className="font-semibold text-gold font-variant-numeric-tabular">{resendCountdown.label}</span></>
                  )}
                </div>

                <button
                  type="submit"
                  disabled={submitting || code.length !== 6}
                  className="rounded-xl bg-accent py-3.5 text-[15px] font-bold text-obsidian shadow-[0_8px_30px_rgba(245,166,35,0.30)] transition-[filter,transform] duration-200 hover:-translate-y-0.5 hover:brightness-110 disabled:cursor-not-allowed disabled:opacity-60 disabled:hover:translate-y-0 cursor-pointer"
                >
                  {submitting ? 'Verifying…' : 'Verify & Continue'}
                </button>

                <button type="button" onClick={() => setStep('email')} className="text-center text-[12.5px] font-semibold text-text-secondary cursor-pointer">
                  &larr; Use a different email
                </button>
              </motion.form>
            )}
          </AnimatePresence>
        </div>
      </div>
    </div>
  )
}
