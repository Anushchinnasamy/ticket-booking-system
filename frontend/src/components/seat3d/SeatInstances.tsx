import { useLayoutEffect, useMemo, useRef, useState } from 'react'
import * as THREE from 'three'
import type { ThreeEvent } from '@react-three/fiber'
import type { PlacedSeat } from './layout'

const COLORS = {
  available: new THREE.Color('#2ECC71'),
  availableHover: new THREE.Color('#5EE79A'),
  selected: new THREE.Color('#E23744'),
  locking: new THREE.Color('#E2374488'),
  lockedByOther: new THREE.Color('#FF4D4D'),
  booked: new THREE.Color('#3A3A3E'),
}

interface SeatInstancesProps {
  placed: PlacedSeat[]
  selectedIds: Set<string>
  lockingIds: Set<string>
  onSeatClick: (seat: PlacedSeat['seat']) => void
}

export function SeatInstances({ placed, selectedIds, lockingIds, onSeatClick }: SeatInstancesProps) {
  const meshRef = useRef<THREE.InstancedMesh>(null)
  const [hovered, setHovered] = useState<number | null>(null)

  const dummy = useMemo(() => new THREE.Object3D(), [])

  useLayoutEffect(() => {
    const mesh = meshRef.current
    if (!mesh) return
    placed.forEach(({ position }, i) => {
      dummy.position.set(position[0], position[1] + 0.14, position[2])
      dummy.updateMatrix()
      mesh.setMatrixAt(i, dummy.matrix)
    })
    mesh.instanceMatrix.needsUpdate = true
  }, [placed, dummy])

  useLayoutEffect(() => {
    const mesh = meshRef.current
    if (!mesh) return
    placed.forEach(({ seat }, i) => {
      let color: THREE.Color
      if (selectedIds.has(seat.id)) {
        color = lockingIds.has(seat.id) ? COLORS.locking : COLORS.selected
      } else if (seat.status === 'BOOKED') {
        color = COLORS.booked
      } else if (seat.status === 'LOCKED') {
        color = COLORS.lockedByOther
      } else {
        color = i === hovered ? COLORS.availableHover : COLORS.available
      }
      mesh.setColorAt(i, color)
    })
    if (mesh.instanceColor) mesh.instanceColor.needsUpdate = true
  }, [placed, selectedIds, lockingIds, hovered])

  function isClickable(seat: PlacedSeat['seat']) {
    return seat.status === 'AVAILABLE' || selectedIds.has(seat.id)
  }

  function handlePointerOver(e: ThreeEvent<PointerEvent>) {
    const id = e.instanceId
    if (id === undefined) return
    const target = placed[id]
    if (!target || !isClickable(target.seat)) return
    e.stopPropagation()
    setHovered(id)
    document.body.style.cursor = 'pointer'
  }

  function handlePointerOut() {
    setHovered(null)
    document.body.style.cursor = 'auto'
  }

  function handleClick(e: ThreeEvent<MouseEvent>) {
    const id = e.instanceId
    if (id === undefined) return
    const target = placed[id]
    if (!target || !isClickable(target.seat)) return
    e.stopPropagation()
    onSeatClick(target.seat)
  }

  return (
    <instancedMesh
      ref={meshRef}
      args={[undefined, undefined, placed.length]}
      onClick={handleClick}
      onPointerOver={handlePointerOver}
      onPointerOut={handlePointerOut}
    >
      <boxGeometry args={[0.42, 0.28, 0.42]} />
      <meshStandardMaterial roughness={0.5} metalness={0.05} />
    </instancedMesh>
  )
}
