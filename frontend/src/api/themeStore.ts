// Persists dark/light choice as a `data-theme` attribute on <html>, which
// index.css keys its light-palette overrides off — same subscribable
// localStorage pattern as cityStore.
const STORAGE_KEY = 'reelrow.theme'
export type Theme = 'dark' | 'light'

type Listener = () => void
const listeners = new Set<Listener>()

function apply(theme: Theme) {
  document.documentElement.setAttribute('data-theme', theme)
}

export function getTheme(): Theme {
  return (localStorage.getItem(STORAGE_KEY) as Theme | null) ?? 'dark'
}

export function setTheme(theme: Theme): void {
  localStorage.setItem(STORAGE_KEY, theme)
  apply(theme)
  listeners.forEach((l) => l())
}

export function toggleTheme(): void {
  setTheme(getTheme() === 'dark' ? 'light' : 'dark')
}

export function subscribeTheme(listener: Listener): () => void {
  listeners.add(listener)
  return () => listeners.delete(listener)
}

// Runs once at module load (imported from main.tsx) so the correct theme is
// on <html> before first paint — avoids a flash of the wrong palette.
apply(getTheme())
