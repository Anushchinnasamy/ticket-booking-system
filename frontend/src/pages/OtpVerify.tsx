import { useState } from 'react'
import { useLocation, useNavigate, Link } from 'react-router-dom'
import { requestOtp, verifyOtp, AuthError } from '../api/auth'
import { PosterCollagePanel } from '../components/PosterCollagePanel'
import { OtpInput } from '../components/OtpInput'
import { useCountdown } from '../hooks/useCountdown'

const OTP_TTL_MINUTES = 5 // user-service application.yml: otp.ttl-minutes

export function OtpVerify() {
  const navigate = useNavigate()
  const location = useLocation()
  const from = (location.state as { from?: { pathname: string; search?: string; state?: unknown } } | null)?.from

  const [step, setStep] = useState<'email' | 'code'>('email')
  const [email, setEmail] = useState('')
  const [code, setCode] = useState('')
  const [sentAt, setSentAt] = useState<Date | null>(null)
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [fallbackNotice, setFallbackNotice] = useState(false)

  const resendCountdown = useCountdown(sentAt ? new Date(sentAt.getTime() + OTP_TTL_MINUTES * 60_000) : null)

  async function handleSendCode(e: React.FormEvent) {
    e.preventDefault()
    setSubmitting(true)
    setError(null)
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
      navigate((from?.pathname ?? '/') + (from?.search ?? ''), { state: from?.state, replace: true })
    } catch (err) {
      setError(err instanceof AuthError ? err.message : 'Something went wrong — please try again.')
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="flex min-h-screen bg-bg text-text-primary">
      <PosterCollagePanel />

      <div className="flex flex-1 items-center justify-center px-4 sm:px-6">
        {step === 'email' ? (
          <form onSubmit={handleSendCode} className="flex w-full max-w-[380px] flex-col gap-5">
            <div>
              <div className="font-display text-[28px] font-extrabold tracking-tight">Log in with a code</div>
              <div className="mt-2 text-[13.5px] text-text-secondary">We'll email you a 6-digit code — no password needed.</div>
            </div>

            {error && <div className="rounded-lg border border-danger/35 bg-danger/10 px-3.5 py-2.5 text-[13px] text-danger">{error}</div>}

            <div className="flex flex-col gap-1.5">
              <label className="text-xs font-semibold text-text-secondary">Email</label>
              <input
                type="email"
                required
                autoFocus
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="you@example.com"
                className="rounded-[10px] border border-border bg-surface px-4 py-3 text-sm text-text-primary placeholder:text-text-muted focus:border-accent focus:outline-none"
              />
            </div>

            <button
              type="submit"
              disabled={submitting}
              className="mt-1 rounded-xl bg-accent py-3.5 text-[15px] font-bold shadow-[0_10px_26px_rgba(226,55,68,0.35)] disabled:cursor-not-allowed disabled:opacity-60 cursor-pointer"
            >
              {submitting ? 'Sending…' : 'Send Code'}
            </button>

            <Link to="/login" className="text-center text-[12.5px] font-semibold text-text-secondary cursor-pointer">&larr; Back to password login</Link>
          </form>
        ) : (
          <form onSubmit={handleVerify} className="flex w-full max-w-[380px] flex-col gap-6">
            <div>
              <div className="font-display text-[28px] font-extrabold tracking-tight">Enter the code</div>
              <div className="mt-2 text-[13.5px] text-text-secondary">
                We sent a 6-digit code to <span className="font-semibold text-text-primary">{email}</span>
              </div>
            </div>

            {error && <div className="rounded-lg border border-danger/35 bg-danger/10 px-3.5 py-2.5 text-[13px] text-danger">{error}</div>}
            {fallbackNotice && (
              <div className="rounded-lg border border-gold/30 bg-accent-dim px-3.5 py-2.5 text-[13px] text-gold">
                Couldn't reach the auth API — signed in with a simulated session for local testing.
              </div>
            )}

            <OtpInput value={code} onChange={setCode} disabled={submitting} />

            <div className="text-[12.5px] text-text-secondary">
              {resendCountdown.expired ? (
                <button type="button" onClick={handleResend} className="font-semibold text-accent cursor-pointer">Resend code</button>
              ) : (
                <>Didn't get it? Resend in <span className="font-semibold text-gold font-variant-numeric-tabular">{resendCountdown.label}</span></>
              )}
            </div>

            <button
              type="submit"
              disabled={submitting || code.length !== 6}
              className="rounded-xl bg-accent py-3.5 text-[15px] font-bold shadow-[0_10px_26px_rgba(226,55,68,0.35)] disabled:cursor-not-allowed disabled:opacity-60 cursor-pointer"
            >
              {submitting ? 'Verifying…' : 'Verify & Continue'}
            </button>

            <button type="button" onClick={() => setStep('email')} className="text-center text-[12.5px] font-semibold text-text-secondary cursor-pointer">
              &larr; Use a different email
            </button>
          </form>
        )}
      </div>
    </div>
  )
}
