// Persists the user's selected city and lets any component subscribe to
// changes (Header's picker, Home/Search's fetch effects) without a global
// state library — same localStorage-backed pattern as authStore.
const STORAGE_KEY = 'reelrow.city'
const DEFAULT_CITY = 'Bengaluru'

type Listener = () => void
const listeners = new Set<Listener>()

export function getCity(): string {
  return localStorage.getItem(STORAGE_KEY) ?? DEFAULT_CITY
}

export function setCity(city: string): void {
  localStorage.setItem(STORAGE_KEY, city)
  listeners.forEach((l) => l())
}

export function subscribeCity(listener: Listener): () => void {
  listeners.add(listener)
  return () => listeners.delete(listener)
}
