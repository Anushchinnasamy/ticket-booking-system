import { authFetch } from './auth'

const API_BASE = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080'

export class TicketError extends Error {}

/**
 * The QR-carrying ticket only exists once TicketService generates it
 * asynchronously off the booking-confirmed Kafka event — there can be a brief
 * gap between payment succeeding and the PDF/share link actually being
 * fetchable. Polls a HEAD request until it 200s (or gives up).
 */
export async function waitForTicketReady(bookingId: string, { attempts = 8, intervalMs = 1500 } = {}): Promise<boolean> {
  for (let i = 0; i < attempts; i++) {
    try {
      const res = await authFetch(new URL(`/bookings/${bookingId}/ticket`, API_BASE), { method: 'HEAD', signal: AbortSignal.timeout(12000) })
      if (res.ok) return true
    } catch {
      // treated as "not ready yet" — offline/unreachable also lands here
    }
    await new Promise((r) => setTimeout(r, intervalMs))
  }
  return false
}

/**
 * GET /bookings/{id}/ticket returns a raw PDF, not JSON — fetched as a blob
 * (via authFetch, since it's owner-gated) rather than a plain <a href>, which
 * wouldn't carry the Authorization header.
 */
export async function downloadTicketPdf(bookingId: string): Promise<void> {
  const res = await authFetch(new URL(`/bookings/${bookingId}/ticket`, API_BASE), { signal: AbortSignal.timeout(15000) })
  if (!res.ok) throw new TicketError(res.status === 404 ? 'Ticket is still being generated — try again in a moment.' : `Could not fetch ticket (${res.status})`)

  const blob = await res.blob()
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = `ticket-${bookingId}.pdf`
  document.body.appendChild(a)
  a.click()
  a.remove()
  setTimeout(() => URL.revokeObjectURL(url), 10_000)
}

/**
 * POST /bookings/{id}/share creates a time-limited public link (GET /t/{token},
 * unauthenticated, server-rendered — shows the real QR). The returned
 * shareUrl is relative ("/t/...").
 */
export async function createShareLink(bookingId: string): Promise<string> {
  const res = await authFetch(new URL(`/bookings/${bookingId}/share`, API_BASE), { method: 'POST', signal: AbortSignal.timeout(12000) })
  if (!res.ok) throw new TicketError(res.status === 404 ? 'Ticket is still being generated — try again in a moment.' : `Could not create a share link (${res.status})`)
  const body: { shareUrl: string } = await res.json()
  return new URL(body.shareUrl, API_BASE).toString()
}

/**
 * POST /bookings/tickets/combined returns ONE PDF spanning every seat in the
 * booking group — one page per seat, each with its own QR, but a single
 * file/download instead of a separate ticket per seat.
 */
export async function downloadCombinedTicketPdf(bookingIds: string[]): Promise<void> {
  const res = await authFetch(new URL('/bookings/tickets/combined', API_BASE), {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ bookingIds }),
    signal: AbortSignal.timeout(15000),
  })
  if (!res.ok) throw new TicketError(res.status === 404 ? 'Ticket is still being generated — try again in a moment.' : `Could not fetch ticket (${res.status})`)

  const blob = await res.blob()
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = `tickets-${bookingIds[0]}.pdf`
  document.body.appendChild(a)
  a.click()
  a.remove()
  setTimeout(() => URL.revokeObjectURL(url), 10_000)
}

/**
 * POST /bookings/tickets/combined/share issues a share token per booking and
 * returns ONE combined public link (GET /t/group/{tokens}) listing every
 * seat's QR on one page — the group equivalent of {@link createShareLink}.
 */
export async function createCombinedShareLink(bookingIds: string[]): Promise<string> {
  const res = await authFetch(new URL('/bookings/tickets/combined/share', API_BASE), {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ bookingIds }),
    signal: AbortSignal.timeout(12000),
  })
  if (!res.ok) throw new TicketError(res.status === 404 ? 'Ticket is still being generated — try again in a moment.' : `Could not create a share link (${res.status})`)
  const body: { shareUrl: string } = await res.json()
  return new URL(body.shareUrl, API_BASE).toString()
}
