import type { AuthResponse, LoginRequest } from '../types/auth'
import { clearAuth, getAccessToken, getRefreshToken, isAccessTokenExpired, saveAuth } from './authStore'

const API_BASE = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080'

export class AuthError extends Error {}

/**
 * Shared by any endpoint that logs the user in (password or OTP) and returns
 * a real AuthResponse. Offline: there's no way to genuinely validate
 * credentials/OTPs without user-service, so it simulates success so the rest
 * of the app (which requires auth for booking/payment) stays testable.
 */
async function loginViaEndpoint(path: string, body: unknown): Promise<{ isFallback: boolean }> {
  let res: Response
  try {
    res = await fetch(new URL(path, API_BASE), {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
      signal: AbortSignal.timeout(12000),
    })
  } catch (err) {
    console.warn(`[auth] could not reach user-service (${path}), simulating a successful sign-in:`, err)
    saveAuth({ accessToken: 'mock-access-token', refreshToken: 'mock-refresh-token', tokenType: 'Bearer', expiresInSeconds: 900 })
    return { isFallback: true }
  }

  if (!res.ok) {
    const body = await res.json().catch(() => null)
    throw new AuthError(res.status === 401 ? 'Incorrect email, password, or code.' : (body?.message ?? `Sign-in failed (${res.status})`))
  }
  const auth: AuthResponse = await res.json()
  saveAuth(auth)
  return { isFallback: false }
}

export function login(request: LoginRequest): Promise<{ isFallback: boolean }> {
  return loginViaEndpoint('/auth/login', request)
}

export function verifyOtp(email: string, otp: string): Promise<{ isFallback: boolean }> {
  return loginViaEndpoint('/auth/otp/verify', { email, otp })
}

/** Always resolves — the backend deliberately returns 200 either way (anti-enumeration). */
export async function requestOtp(email: string): Promise<void> {
  try {
    await fetch(new URL('/auth/otp/request', API_BASE), {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email }),
      signal: AbortSignal.timeout(12000),
    })
  } catch (err) {
    console.warn('[auth] could not reach user-service to request an OTP (harmless offline — verify still works via the simulated sign-in):', err)
  }
}

/** Always resolves — same anti-enumeration behavior as requestOtp. */
export async function forgotPassword(email: string): Promise<void> {
  try {
    await fetch(new URL('/auth/forgot-password', API_BASE), {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email }),
      signal: AbortSignal.timeout(12000),
    })
  } catch (err) {
    console.warn('[auth] could not reach user-service to request a password reset:', err)
  }
}

export async function resetPassword(token: string, newPassword: string): Promise<void> {
  const res = await fetch(new URL('/auth/reset-password', API_BASE), {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ token, newPassword }),
    signal: AbortSignal.timeout(12000),
  })
  if (!res.ok) {
    const body = await res.json().catch(() => null)
    throw new AuthError(body?.message ?? 'That reset link is invalid or has expired.')
  }
}

export function logout(): void {
  clearAuth()
}

async function refresh(): Promise<boolean> {
  const refreshToken = getRefreshToken()
  if (!refreshToken) return false
  try {
    const res = await fetch(new URL('/auth/refresh', API_BASE), {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ refreshToken }),
    })
    if (!res.ok) return false
    const auth: AuthResponse = await res.json()
    saveAuth(auth)
    return true
  } catch {
    return false
  }
}

/**
 * fetch wrapper for endpoints that require `Authorization: Bearer <token>`
 * (booking creation, payment charge/verify). Refreshes the access token first
 * if it looks expired, and once more on an actual 401 in case the clocks disagree.
 */
export async function authFetch(input: string | URL, init: RequestInit = {}): Promise<Response> {
  if (isAccessTokenExpired()) await refresh()

  const withAuthHeader = (): RequestInit => ({
    ...init,
    headers: { ...init.headers, Authorization: `Bearer ${getAccessToken() ?? ''}` },
  })

  let res = await fetch(input, withAuthHeader())
  if (res.status === 401) {
    const refreshed = await refresh()
    if (refreshed) res = await fetch(input, withAuthHeader())
  }
  return res
}
