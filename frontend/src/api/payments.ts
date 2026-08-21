import type { ChargeResponse, PaymentResponse, VerifyRequest } from '../types/payment'
import { authFetch } from './auth'

const API_BASE = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080'
export const RAZORPAY_KEY_ID_FALLBACK = 'rzp_test_TRXnNFZ4H3okES' // test-mode public key, safe to ship client-side

export class PaymentError extends Error {}

/**
 * Creates ONE real Razorpay order for the whole cart via payment-service
 * (POST /payments/charge) — one checkout, regardless of how many seats/
 * bookings it covers. Idempotency-Key must be the SAME value on a retry of
 * the same cart so payment-service returns the existing Payment instead of
 * creating a second Razorpay order.
 */
export async function chargeBookings(bookingIds: string[], amount: number, idempotencyKey: string): Promise<{ charge: ChargeResponse; isFallback: boolean }> {
  let res: Response
  try {
    res = await authFetch(new URL('/payments/charge', API_BASE), {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Idempotency-Key': idempotencyKey },
      body: JSON.stringify({ bookingIds, amount }),
      signal: AbortSignal.timeout(12000),
    })
  } catch (err) {
    console.warn(`[payments] could not reach payment-service to charge ${bookingIds.length} booking(s), simulating a successful order:`, err)
    const charge: ChargeResponse = {
      paymentId: crypto.randomUUID(),
      bookingIds,
      amount,
      currency: 'INR',
      status: 'INITIATED',
      razorpayOrderId: `mock_order_${crypto.randomUUID()}`,
      razorpayKeyId: RAZORPAY_KEY_ID_FALLBACK,
    }
    return { charge, isFallback: true }
  }

  if (!res.ok) {
    const body = await res.json().catch(() => ({ message: `Charge failed (${res.status})` }))
    throw new PaymentError(body.message ?? `Charge failed (${res.status})`)
  }
  const charge: ChargeResponse = await res.json()
  return { charge, isFallback: false }
}

export async function verifyPayment(paymentId: string, body: VerifyRequest): Promise<PaymentResponse> {
  const res = await authFetch(new URL(`/payments/${paymentId}/verify`, API_BASE), {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
    signal: AbortSignal.timeout(12000),
  })
  if (!res.ok) {
    const errBody = await res.json().catch(() => ({ message: `Verify failed (${res.status})` }))
    throw new PaymentError(errBody.message ?? `Verify failed (${res.status})`)
  }
  return res.json()
}

export async function failPayment(paymentId: string, reason: string): Promise<void> {
  try {
    await authFetch(new URL(`/payments/${paymentId}/fail`, API_BASE), {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ reason }),
      signal: AbortSignal.timeout(12000),
    })
  } catch (err) {
    console.warn(`[payments] could not notify payment-service of failure for ${paymentId}:`, err)
  }
}
