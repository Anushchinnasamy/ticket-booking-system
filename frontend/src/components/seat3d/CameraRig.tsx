import { useRef } from 'react'
import { useFrame } from '@react-three/fiber'
import { OrbitControls } from '@react-three/drei'
import * as THREE from 'three'
import type { OrbitControls as OrbitControlsImpl } from 'three-stdlib'

interface CameraRigProps {
  overviewPosition: [number, number, number]
  overviewTarget: [number, number, number]
  previewPosition: [number, number, number] | null
  previewTarget: [number, number, number]
  reducedMotion: boolean
}

export function CameraRig({ overviewPosition, overviewTarget, previewPosition, previewTarget, reducedMotion }: CameraRigProps) {
  const controlsRef = useRef<OrbitControlsImpl>(null)
  const posTarget = useRef(new THREE.Vector3())
  const lookTarget = useRef(new THREE.Vector3())

  useFrame((state) => {
    const inPreview = previewPosition !== null
    const alpha = reducedMotion ? 1 : 0.08

    if (inPreview) {
      posTarget.current.set(previewPosition[0], previewPosition[1] + 0.55, previewPosition[2] + 0.2)
      lookTarget.current.set(...previewTarget)
      state.camera.position.lerp(posTarget.current, alpha)
      state.camera.lookAt(lookTarget.current)
      if (controlsRef.current) controlsRef.current.enabled = false
    } else {
      posTarget.current.set(...overviewPosition)
      state.camera.position.lerp(posTarget.current, alpha)
      if (controlsRef.current) {
        controlsRef.current.enabled = true
        controlsRef.current.target.lerp(new THREE.Vector3(...overviewTarget), alpha)
        controlsRef.current.update()
      }
    }
  })

  return (
    <OrbitControls
      ref={controlsRef}
      enablePan={false}
      enableDamping={!reducedMotion}
      dampingFactor={0.08}
      minDistance={3}
      maxDistance={9}
      minPolarAngle={Math.PI / 6}
      maxPolarAngle={Math.PI / 2.3}
      minAzimuthAngle={-0.6}
      maxAzimuthAngle={0.6}
    />
  )
}
