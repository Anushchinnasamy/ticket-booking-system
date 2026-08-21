import { useSyncExternalStore } from 'react'
import { getTheme, subscribeTheme, type Theme } from '../api/themeStore'

export function useTheme(): Theme {
  return useSyncExternalStore(subscribeTheme, getTheme)
}
