import React, { useRef, useMemo } from 'react';
import { useFrame } from '@react-three/fiber';
import { Object3D, Vector3 } from 'three';

export default function Waterfall({ position, height = 40, width = 5 }) {
    const mesh = useRef();
    const count = 400; // Particle count
    const dummy = useMemo(() => new Object3D(), []);

    // Particles: x (width), y (height relative to bottom), z (depth)
    const particles = useMemo(() => new Array(count).fill().map(() => ({
        // Spread x +/- width/2
        x: (Math.random() - 0.5) * width,
        // Start anywhere along height
        y: Math.random() * height,
        // Small depth variation
        z: (Math.random() - 0.5) * 2,
        // Drop speed
        speed: 0.5 + Math.random() * 0.8,
        // Offset for wave effect
        offset: Math.random() * 100
    })), [width, height]);

    useFrame((state, delta) => {
        if (!mesh.current) return;

        particles.forEach((p, i) => {
            // Move down
            p.y -= p.speed * 60 * delta; // Speed up

            // Loop
            if (p.y < 0) {
                p.y = height;
                p.x = (Math.random() - 0.5) * width; // Respawn random x
            }

            // Wiggle x/z slightly for turbulence
            const wiggle = Math.sin(state.clock.elapsedTime * 5 + p.offset) * 0.1;

            dummy.position.set(
                position[0] + p.x + wiggle,
                position[1] + p.y,
                position[2] + p.z
            );

            // Stretch based on speed (simulates motion blur)
            dummy.scale.set(0.3, 2.5 + p.speed * 2, 0.3);

            dummy.updateMatrix();
            mesh.current.setMatrixAt(i, dummy.matrix);
        });
        mesh.current.instanceMatrix.needsUpdate = true;
    });

    return (
        <group>
            {/* Falling Water */}
            <instancedMesh ref={mesh} args={[null, null, count]}>
                <boxGeometry args={[1, 1, 1]} />
                <meshStandardMaterial
                    color="#aaddff"
                    emissive="#0044aa"
                    emissiveIntensity={0.5}
                    transparent
                    opacity={0.7}
                    roughness={0.1}
                />
            </instancedMesh>

            {/* Splash Base (Simple glow for now) */}
            <pointLight position={[position[0], position[1] + 2, position[2]]} color="#aaddff" intensity={1} distance={20} />
            <mesh position={[position[0], position[1] + 0.5, position[2]]} rotation={[-Math.PI / 2, 0, 0]}>
                <circleGeometry args={[width * 1.5, 16]} />
                <meshBasicMaterial color="#eeffff" transparent opacity={0.4} depthWrite={false} />
            </mesh>
        </group>
    );
}
