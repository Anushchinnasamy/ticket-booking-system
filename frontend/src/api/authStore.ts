import type { AuthResponse } from '../types/auth'

const STORAGE_KEY = 'reelrow.auth'

interface StoredAuth {
  accessToken: string
  refreshToken: string
  expiresAt: number // epoch ms
}

function read(): StoredAuth | null {
  const raw = localStorage.getItem(STORAGE_KEY)
  if (!raw) return null
  try {
    return JSON.parse(raw) as StoredAuth
  } catch {
    return null
  }
}

export function saveAuth(auth: AuthResponse): void {
  const stored: StoredAuth = {
    accessToken: auth.accessToken,
    refreshToken: auth.refreshToken,
    expiresAt: Date.now() + auth.expiresInSeconds * 1000,
  }
  localStorage.setItem(STORAGE_KEY, JSON.stringify(stored))
}

export function clearAuth(): void {
  localStorage.removeItem(STORAGE_KEY)
}

export function getAccessToken(): string | null {
  return read()?.accessToken ?? null
}

export function getRefreshToken(): string | null {
  return read()?.refreshToken ?? null
}

export function isAccessTokenExpired(): boolean {
  const stored = read()
  if (!stored) return true
  return Date.now() >= stored.expiresAt - 10_000 // refresh 10s early
}

export function isAuthenticated(): boolean {
  return read() !== null
}
