import React, { useRef, useState } from 'react';
import { useFrame } from '@react-three/fiber';
import { useSphere } from '@react-three/cannon';
import { useStore } from '../store';

export default function EnergyCore({ position }) {
    const isCollected = useRef(false);
    const [visible, setVisible] = useState(true);
    const addScore = useStore((state) => state.addScore);
    const addEnergy = useStore((state) => state.addEnergy);
    const groupRef = useRef();
    const innerRef = useRef();
    const outerRef = useRef();
    const lightRef = useRef();

    const [ref] = useSphere(() => ({
        args: [0.6],
        position,
        isTrigger: true,
        onCollide: (e) => {
            if (isCollected.current) return;
            if (e.body.userData?.name === 'drone') {
                isCollected.current = true;
                setVisible(false);
                addScore(100);
                addEnergy(20);
            }
        }
    }));

    useFrame((state) => {
        if (!visible) return;
        const t = state.clock.getElapsedTime();

        // Hover bob
        if (groupRef.current) {
            groupRef.current.position.y = Math.sin(t * 2.5) * 0.18;
        }
        // Inner spin
        if (innerRef.current) {
            innerRef.current.rotation.y += 0.04;
            innerRef.current.rotation.x += 0.02;
        }
        // Outer spin (opposite)
        if (outerRef.current) {
            outerRef.current.rotation.y -= 0.025;
            outerRef.current.rotation.z += 0.015;
        }
        // Pulsing light
        if (lightRef.current) {
            lightRef.current.intensity = 2.5 + Math.sin(t * 5) * 1.2;
        }
    });

    if (!visible) return null;

    return (
        <group ref={ref}>
            <group ref={groupRef}>
                {/* Core sphere */}
                <mesh>
                    <sphereGeometry args={[0.22, 16, 16]} />
                    <meshStandardMaterial
                        color="#ff9900"
                        emissive="#ff6600"
                        emissiveIntensity={4}
                        roughness={0.1}
                        metalness={0.3}
                    />
                </mesh>

                {/* Inner octahedron */}
                <mesh ref={innerRef}>
                    <octahedronGeometry args={[0.42, 0]} />
                    <meshStandardMaterial
                        color="#ffcc00"
                        emissive="#ff8800"
                        emissiveIntensity={3}
                        roughness={0.05}
                        metalness={0.8}
                        wireframe={false}
                        transparent
                        opacity={0.85}
                    />
                </mesh>

                {/* Outer wireframe cage */}
                <mesh ref={outerRef}>
                    <icosahedronGeometry args={[0.62, 1]} />
                    <meshStandardMaterial
                        color="#ffdd44"
                        emissive="#ffaa00"
                        emissiveIntensity={2}
                        wireframe
                        transparent
                        opacity={0.6}
                    />
                </mesh>

                {/* Orbital ring 1 */}
                <mesh rotation={[Math.PI / 2, 0, 0]}>
                    <torusGeometry args={[0.55, 0.03, 8, 48]} />
                    <meshStandardMaterial color="#ffcc00" emissive="#ff8800" emissiveIntensity={3} roughness={0.1} metalness={0.9} />
                </mesh>

                {/* Orbital ring 2 */}
                <mesh rotation={[0, 0, Math.PI / 3]}>
                    <torusGeometry args={[0.55, 0.03, 8, 48]} />
                    <meshStandardMaterial color="#ffcc00" emissive="#ff8800" emissiveIntensity={3} roughness={0.1} metalness={0.9} />
                </mesh>

                {/* Glow light */}
                <pointLight ref={lightRef} distance={5} color="#ff8800" intensity={2.5} />
            </group>
        </group>
    );
}
