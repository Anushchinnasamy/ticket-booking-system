import type { SeatResponse } from '../../types/seat'

const SEAT_SPACING = 0.55
const AISLE_GAP = 0.4
const ROW_SPACING = 0.85
const RISE_PER_ROW = 0.28

export interface PlacedSeat {
  seat: SeatResponse
  position: [number, number, number]
}

export interface SeatLayout {
  placed: PlacedSeat[]
  /** center of the whole seating block, useful for camera targeting */
  center: [number, number, number]
  lastRowZ: number
  lastRowY: number
  screenZ: number
}

/** Lays seats out on a raked (rising) floor — row 0 nearest the screen and lowest, later rows further back and higher. */
export function computeSeatLayout(rows: readonly (readonly [string, SeatResponse[]])[]): SeatLayout {
  const placed: PlacedSeat[] = []

  rows.forEach(([, seats], rowIndex) => {
    const mid = Math.floor(seats.length / 2)
    const xs: number[] = []
    let cursor = 0
    seats.forEach((_, i) => {
      if (i === mid) cursor += AISLE_GAP
      xs.push(cursor)
      cursor += SEAT_SPACING
    })
    const offset = (xs[0] + xs[xs.length - 1]) / 2
    const y = rowIndex * RISE_PER_ROW
    const z = rowIndex * ROW_SPACING

    seats.forEach((seat, i) => {
      placed.push({ seat, position: [xs[i] - offset, y, z] })
    })
  })

  const lastRowIndex = Math.max(0, rows.length - 1)
  const lastRowZ = lastRowIndex * ROW_SPACING
  const lastRowY = lastRowIndex * RISE_PER_ROW

  return {
    placed,
    center: [0, lastRowY / 2, lastRowZ / 2],
    lastRowZ,
    lastRowY,
    screenZ: -2,
  }
}
