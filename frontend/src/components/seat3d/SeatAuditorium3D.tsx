import { useEffect, useMemo, useState } from 'react'
import { Canvas } from '@react-three/fiber'
import { computeSeatLayout } from './layout'
import { SeatInstances } from './SeatInstances'
import { CameraRig } from './CameraRig'
import type { SeatResponse } from '../../types/seat'

interface SeatAuditorium3DProps {
  rows: readonly (readonly [string, SeatResponse[]])[]
  selectedIds: Set<string>
  lockingIds: Set<string>
  onSeatClick: (seat: SeatResponse) => void
  reducedMotion: boolean
}

export default function SeatAuditorium3D({ rows, selectedIds, lockingIds, onSeatClick, reducedMotion }: SeatAuditorium3DProps) {
  const layout = useMemo(() => computeSeatLayout(rows), [rows])
  const [previewSeatId, setPreviewSeatId] = useState<string | null>(null)

  useEffect(() => {
    if (previewSeatId && !selectedIds.has(previewSeatId)) setPreviewSeatId(null)
  }, [previewSeatId, selectedIds])

  // Canvas is lazy-mounted (behind Suspense, toggled on by the user), and its
  // ResizeObserver-based auto-sizing can miss that first layout pass, leaving
  // the drawing buffer at the browser's 300x150 canvas default. Nudge it a
  // few times over the following second so it picks up the real container
  // size once R3F's observer has actually attached.
  useEffect(() => {
    const delays = [50, 150, 400, 900]
    const timers = delays.map((ms) => setTimeout(() => window.dispatchEvent(new Event('resize')), ms))
    return () => timers.forEach(clearTimeout)
  }, [])

  const previewPlaced = previewSeatId ? layout.placed.find((p) => p.seat.id === previewSeatId) : undefined
  const lastSelectedId = [...selectedIds].at(-1)

  const overviewPosition: [number, number, number] = [0, layout.lastRowY + 3.6, layout.lastRowZ + 5.2]
  const overviewTarget: [number, number, number] = [0, layout.lastRowY * 0.3, layout.lastRowZ * 0.35]
  const screenTarget: [number, number, number] = [0, 1.1, layout.screenZ]
  const widestRow = Math.max(...rows.map(([, seats]) => seats.length), 1)

  return (
    <div className="relative h-[520px] w-full max-w-[720px] overflow-hidden rounded-2xl bg-[#08080a]">
      <Canvas camera={{ position: overviewPosition, fov: 50, near: 0.1, far: 60 }} dpr={[1, 1.5]}>
        <color attach="background" args={['#08080a']} />
        <fog attach="fog" args={['#08080a', 6, 16]} />
        <ambientLight intensity={0.55} />
        <directionalLight position={[3, 6, 4]} intensity={0.9} />
        <pointLight position={[0, 1.4, layout.screenZ - 0.3]} intensity={1.2} color="#F5F5F7" distance={6} />

        <mesh position={[0, 1.1, layout.screenZ]}>
          <planeGeometry args={[Math.min(widestRow * 0.5, 8), 1.3]} />
          <meshStandardMaterial color="#F5F5F7" emissive="#F5F5F7" emissiveIntensity={0.35} />
        </mesh>

        <SeatInstances placed={layout.placed} selectedIds={selectedIds} lockingIds={lockingIds} onSeatClick={onSeatClick} />

        <CameraRig
          overviewPosition={overviewPosition}
          overviewTarget={overviewTarget}
          previewPosition={previewPlaced ? previewPlaced.position : null}
          previewTarget={screenTarget}
          reducedMotion={reducedMotion}
        />
      </Canvas>

      <div className="absolute bottom-4 right-4">
        {previewSeatId ? (
          <button
            onClick={() => setPreviewSeatId(null)}
            className="rounded-lg bg-surface/90 px-4 py-2 text-xs font-semibold text-text-primary backdrop-blur cursor-pointer"
          >
            &larr; Back to overview
          </button>
        ) : (
          lastSelectedId && (
            <button
              onClick={() => setPreviewSeatId(lastSelectedId)}
              className="rounded-lg bg-accent/90 px-4 py-2 text-xs font-semibold text-text-primary backdrop-blur cursor-pointer"
            >
              Preview my view
            </button>
          )
        )}
      </div>

      <div className="absolute left-4 top-4 text-[11px] text-text-secondary">Drag to look around</div>
    </div>
  )
}
