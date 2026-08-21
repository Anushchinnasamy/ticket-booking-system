// Thin typed wrapper around Razorpay's real Checkout.js widget (not a mock —
// payment-service integrates with genuine Razorpay test-mode orders).

export interface RazorpaySuccessResponse {
  razorpay_payment_id: string
  razorpay_order_id: string
  razorpay_signature: string
}

interface RazorpayOptions {
  key: string
  amount: number // paise
  currency: string
  name: string
  description?: string
  order_id: string
  prefill?: { name?: string; email?: string; contact?: string }
  theme?: { color?: string }
  handler: (response: RazorpaySuccessResponse) => void
  modal?: { ondismiss?: () => void }
}

interface RazorpayInstance {
  open: () => void
}

declare global {
  interface Window {
    Razorpay?: new (options: RazorpayOptions) => RazorpayInstance
  }
}

const SCRIPT_URL = 'https://checkout.razorpay.com/v1/checkout.js'
let loadPromise: Promise<boolean> | null = null

function loadCheckoutScript(): Promise<boolean> {
  if (window.Razorpay) return Promise.resolve(true)
  if (loadPromise) return loadPromise

  loadPromise = new Promise((resolve) => {
    const script = document.createElement('script')
    script.src = SCRIPT_URL
    script.onload = () => resolve(true)
    script.onerror = () => resolve(false)
    document.body.appendChild(script)
  })
  return loadPromise
}

export type RazorpayOutcome =
  | { kind: 'success'; response: RazorpaySuccessResponse }
  | { kind: 'dismissed' }
  | { kind: 'script-load-failed' }

export async function openRazorpayCheckout(options: Omit<RazorpayOptions, 'handler' | 'modal'>): Promise<RazorpayOutcome> {
  const loaded = await loadCheckoutScript()
  if (!loaded || !window.Razorpay) return { kind: 'script-load-failed' }

  return new Promise((resolve) => {
    const instance = new window.Razorpay!({
      ...options,
      handler: (response) => resolve({ kind: 'success', response }),
      modal: { ondismiss: () => resolve({ kind: 'dismissed' }) },
    })
    instance.open()
  })
}
