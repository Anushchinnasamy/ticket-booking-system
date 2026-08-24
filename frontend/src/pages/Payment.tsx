import { useEffect, useRef, useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { chargeBookings, failPayment, verifyPayment } from '../api/payments'
import { openRazorpayCheckout } from '../lib/razorpay'
import { isAuthenticated } from '../api/authStore'

interface PaymentSeat {
  bookingId: string
  label: string
  price: number
}

interface PaymentState {
  eventId?: string
  showId: string
  eventTitle?: string
  venueName?: string
  startTime?: string
  seats: PaymentSeat[]
  total: number
}

type CheckoutStatus = 'idle' | 'charging' | 'awaiting-checkout' | 'verifying' | 'success' | 'failed'

const STATUS_LABEL: Record<CheckoutStatus, string> = {
  idle: 'Not started',
  charging: 'Creating order…',
  'awaiting-checkout': 'Waiting on checkout…',
  verifying: 'Confirming…',
  success: 'Paid',
  failed: 'Failed',
}

export function Payment() {
  const location = useLocation()
  const navigate = useNavigate()
  const state = location.state as PaymentState | null

  const seats = state?.seats ?? []

  const [status, setStatus] = useState<CheckoutStatus>('idle')
  const [errorMessage, setErrorMessage] = useState<string | null>(null)
  // one idempotency key for the whole cart, generated once and reused on retry
  // so a retried charge returns the same Razorpay order instead of a new one
  const idempotencyKey = useRef(crypto.randomUUID())

  useEffect(() => {
    if (!isAuthenticated()) {
      navigate('/login', { state: { from: location } })
    }
  }, [])

  async function startCheckout() {
    if (!state) return
    setErrorMessage(null)
    setStatus('charging')

    const bookingIds = seats.map((s) => s.bookingId)

    let chargeResult
    try {
      chargeResult = await chargeBookings(bookingIds, state.total, idempotencyKey.current)
    } catch (err) {
      setStatus('failed')
      setErrorMessage(err instanceof Error ? err.message : 'Could not start checkout.')
      return
    }

    const { charge, isFallback } = chargeResult

    if (isFallback) {
      // No live gateway to talk to — simulate the checkout+verify round trip
      // so the flow stays demoable offline. The real path below is untouched.
      setStatus('verifying')
      await new Promise((r) => setTimeout(r, 1100))
      setStatus('success')
      goToConfirmation()
      return
    }

    setStatus('awaiting-checkout')
    const outcome = await openRazorpayCheckout({
      key: charge.razorpayKeyId,
      amount: Math.round(state.total * 100),
      currency: 'INR',
      name: 'TickIT',
      description: `${state.eventTitle ?? 'Booking'} — ${seats.length} seat${seats.length === 1 ? '' : 's'} (${seats.map((s) => s.label).join(', ')})`,
      order_id: charge.razorpayOrderId,
      theme: { color: '#F5A623' },
    })

    if (outcome.kind === 'success') {
      setStatus('verifying')
      try {
        const verified = await verifyPayment(charge.paymentId, {
          razorpayOrderId: outcome.response.razorpay_order_id,
          razorpayPaymentId: outcome.response.razorpay_payment_id,
          razorpaySignature: outcome.response.razorpay_signature,
        })
        if (verified.status === 'SUCCESS') {
          setStatus('success')
          goToConfirmation()
        } else {
          setStatus('failed')
          setErrorMessage('Payment could not be verified.')
        }
      } catch (err) {
        setStatus('failed')
        setErrorMessage(err instanceof Error ? err.message : 'Verification failed.')
      }
      return
    }

    if (outcome.kind === 'dismissed') {
      await failPayment(charge.paymentId, 'user_cancelled')
      setStatus('failed')
      setErrorMessage('Checkout was closed before completing.')
    } else {
      setStatus('failed')
      setErrorMessage("Couldn't load the payment widget.")
    }
  }

  function goToConfirmation() {
    navigate(`/bookings/${state!.seats[0].bookingId}/confirmation`, {
      state: {
        seats: state!.seats,
        showId: state!.showId,
        eventId: state!.eventId,
        eventTitle: state!.eventTitle,
        venueName: state!.venueName,
        startTime: state!.startTime,
        total: state!.total,
      },
    })
  }

  if (!state || seats.length === 0) {
    return (
      <div className="flex min-h-[60vh] flex-col items-center justify-center gap-3 text-center">
        <div className="font-display text-lg font-bold">Nothing to pay for</div>
        <p className="max-w-sm text-sm text-text-secondary">This page needs seats selected first — go pick some.</p>
        <button onClick={() => navigate('/')} className="mt-2 rounded-xl bg-accent px-6 py-3 text-sm font-semibold text-obsidian cursor-pointer">
          Back to Home
        </button>
      </div>
    )
  }

  const busy = status === 'charging' || status === 'awaiting-checkout' || status === 'verifying'

  return (
    <div className="flex flex-col items-center px-6 py-12">
      <div className="flex w-full max-w-[440px] flex-col gap-6">
        <div>
          <div className="font-display text-2xl font-extrabold tracking-tight">Complete your payment</div>
          <p className="mt-1.5 text-[13px] text-text-secondary">
            One secure checkout for all {seats.length} seat{seats.length === 1 ? '' : 's'} — cards, UPI, netbanking, and wallets via Razorpay.
          </p>
        </div>

        {/* Cream editorial surface (plan section 1: "Cream is useful for
            editorial detail/payment surfaces") — a calmer, receipt-like
            moment against the seat page's darker energy. */}
        <div className="flex flex-col gap-2.5 rounded-2xl bg-cinema-cream p-5 text-obsidian">
          {seats.map((seat) => (
            <div key={seat.bookingId} className="flex items-center justify-between">
              <div className="text-sm font-semibold">Seat {seat.label}</div>
              <div className="font-variant-numeric-tabular text-sm text-obsidian/65">₹{seat.price}</div>
            </div>
          ))}
          <div className="mt-1 flex justify-between border-t border-obsidian/15 pt-3 text-[15px] font-bold">
            <span>Total</span>
            <span className="font-variant-numeric-tabular">₹{state.total}</span>
          </div>
        </div>

        {status !== 'idle' && (
          <div className="flex items-center gap-3 rounded-xl bg-surface px-4 py-3">
            <StatusIcon status={status} />
            <div className="text-sm">
              <div className="font-semibold">{STATUS_LABEL[status]}</div>
              {errorMessage && <div className="text-xs text-danger">{errorMessage}</div>}
            </div>
          </div>
        )}

        {status === 'success' ? (
          <div className="rounded-xl bg-success/10 px-4 py-3 text-center text-sm font-semibold text-success">
            Payment successful — redirecting to your ticket…
          </div>
        ) : (
          <button
            onClick={startCheckout}
            disabled={busy}
            className="rounded-xl bg-accent py-4 text-[15px] font-bold text-obsidian shadow-[0_10px_26px_rgba(245,166,35,0.35)] disabled:cursor-not-allowed disabled:opacity-60 cursor-pointer"
          >
            {status === 'failed' ? `Retry — Pay ₹${state.total}` : busy ? 'Processing…' : `Pay ₹${state.total}`}
          </button>
        )}
      </div>
    </div>
  )
}

function StatusIcon({ status }: { status: CheckoutStatus }) {
  if (status === 'success') {
    return (
      <div className="flex h-7 w-7 flex-shrink-0 items-center justify-center rounded-full bg-success/15">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#2ECC71" strokeWidth={3} strokeLinecap="round" strokeLinejoin="round"><path d="M20 6L9 17l-5-5" /></svg>
      </div>
    )
  }
  if (status === 'failed') {
    return (
      <div className="flex h-7 w-7 flex-shrink-0 items-center justify-center rounded-full bg-danger/15">
        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#FF4D4D" strokeWidth={3} strokeLinecap="round" strokeLinejoin="round"><path d="M18 6L6 18M6 6l12 12" /></svg>
      </div>
    )
  }
  return (
    <div className="flex h-7 w-7 flex-shrink-0 items-center justify-center rounded-full bg-accent-dim">
      <div className="h-3 w-3 animate-spin rounded-full border-2 border-gold/40 border-t-gold" />
    </div>
  )
}
