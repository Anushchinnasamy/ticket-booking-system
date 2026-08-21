import { useSyncExternalStore } from 'react'
import { getCity, subscribeCity } from '../api/cityStore'

export function useCity(): string {
  return useSyncExternalStore(subscribeCity, getCity)
}
