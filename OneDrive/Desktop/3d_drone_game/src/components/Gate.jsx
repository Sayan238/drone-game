import React, { useRef, useState } from 'react';
import { useBox } from '@react-three/cannon';
import { useFrame } from '@react-three/fiber';
import { useStore } from '../store';

export default function Gate({ position, rotation = [0, 0, 0], scale = [1, 1, 1] }) {
    const [active, setActive] = useState(true);
    const { passGate } = useStore();
    const glowRef = useRef();
    const ringRef = useRef();

    const [ref] = useBox(() => ({
        isTrigger: true,
        args: [4 * scale[0], 4 * scale[1], 1 * scale[2]],
        position,
        rotation,
        onCollide: (e) => {
            if (active && e.body.userData.name === 'drone') {
                setActive(false);
                passGate();
            }
        }
    }));

    const activeColor = '#00eeff';
    const inactiveColor = '#00ff88';
    const color = active ? activeColor : inactiveColor;
    const emissiveIntensity = active ? 3 : 1.5;

    useFrame((state) => {
        const t = state.clock.getElapsedTime();
        if (glowRef.current) {
            glowRef.current.intensity = active
                ? 3 + Math.sin(t * 4) * 1.5
                : 1.5;
        }
        if (ringRef.current && active) {
            ringRef.current.rotation.z = t * 1.2;
        }
    });

    const barMat = (
        <meshStandardMaterial
            color={color}
            emissive={color}
            emissiveIntensity={emissiveIntensity}
            roughness={0.1}
            metalness={0.8}
            envMapIntensity={1}
        />
    );

    return (
        <group ref={ref}>
            {/* Top bar */}
            <mesh position={[0, 2.25, 0]} castShadow>
                <boxGeometry args={[5.5, 0.35, 0.35]} />
                {barMat}
            </mesh>
            {/* Bottom bar */}
            <mesh position={[0, -2.25, 0]} castShadow>
                <boxGeometry args={[5.5, 0.35, 0.35]} />
                {barMat}
            </mesh>
            {/* Left post */}
            <mesh position={[-2.75, 0, 0]} castShadow>
                <boxGeometry args={[0.35, 4.85, 0.35]} />
                {barMat}
            </mesh>
            {/* Right post */}
            <mesh position={[2.75, 0, 0]} castShadow>
                <boxGeometry args={[0.35, 4.85, 0.35]} />
                {barMat}
            </mesh>

            {/* Corner accent spheres */}
            {[[-2.75, 2.25], [2.75, 2.25], [-2.75, -2.25], [2.75, -2.25]].map(([cx, cy], i) => (
                <mesh key={i} position={[cx, cy, 0]}>
                    <sphereGeometry args={[0.25, 12, 12]} />
                    <meshStandardMaterial color={color} emissive={color} emissiveIntensity={emissiveIntensity + 1} roughness={0.1} metalness={0.9} />
                </mesh>
            ))}

            {/* Spinning ring decoration */}
            {active && (
                <mesh ref={ringRef} rotation={[Math.PI / 2, 0, 0]}>
                    <torusGeometry args={[2.5, 0.06, 8, 64]} />
                    <meshStandardMaterial color={color} emissive={color} emissiveIntensity={2} roughness={0.1} metalness={0.9} />
                </mesh>
            )}

            {/* Inner glow plane */}
            {active && (
                <mesh>
                    <planeGeometry args={[5, 4.5]} />
                    <meshBasicMaterial color={color} opacity={0.06} transparent side={2} />
                </mesh>
            )}

            {/* Point light for gate glow */}
            <pointLight ref={glowRef} distance={12} color={color} intensity={3} />
        </group>
    );
}
