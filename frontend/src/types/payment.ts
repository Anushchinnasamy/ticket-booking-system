// Matches payment-service's DTOs exactly.
export type PaymentStatus = 'INITIATED' | 'SUCCESS' | 'FAILED' | 'REFUNDED'

export interface ChargeRequest {
  bookingIds: string[]
  amount: number
}

export interface ChargeResponse {
  paymentId: string
  bookingIds: string[]
  amount: number
  currency: 'INR'
  status: PaymentStatus
  razorpayOrderId: string
  razorpayKeyId: string
}

export interface VerifyRequest {
  razorpayOrderId: string
  razorpayPaymentId: string
  razorpaySignature: string
}

export interface PaymentResponse {
  id: string
  bookingIds: string[]
  amount: number
  currency: string
  status: PaymentStatus
  razorpayOrderId: string
  razorpayPaymentId?: string
  createdAt: string
}
