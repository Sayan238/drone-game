import React, { useRef, useMemo, useLayoutEffect } from 'react';
import { useFrame } from '@react-three/fiber';
import * as THREE from 'three';

export default function Updraft({ position, height, width }) {
    const mesh = useRef();
    const dummy = useMemo(() => new THREE.Object3D(), []);

    // Generate particles
    const particles = useMemo(() => {
        const temp = [];
        const count = Math.floor(height * width * 0.5); // Density
        for (let i = 0; i < count; i++) {
            const x = (Math.random() - 0.5) * width;
            const z = (Math.random() - 0.5) * width;
            const y = Math.random() * height;
            const speed = 0.5 + Math.random() * 1.5; // Upward speed
            const scale = 0.5 + Math.random();
            temp.push({ x, y, z, speed, scale });
        }
        return temp;
    }, [height, width]);

    useFrame((state, delta) => {
        if (!mesh.current) return;

        particles.forEach((p, i) => {
            // Move UP
            p.y += p.speed * 10 * delta;

            // Loop
            if (p.y > height) {
                p.y = 0;
                p.x = (Math.random() - 0.5) * width;
                p.z = (Math.random() - 0.5) * width;
            }

            dummy.position.set(position[0] + p.x, position[1] + p.y, position[2] + p.z);

            // Rectangular shape scaling
            dummy.scale.set(p.scale, p.scale * 2, p.scale);

            dummy.rotation.y += delta; // Spin slightly

            dummy.updateMatrix();
            mesh.current.setMatrixAt(i, dummy.matrix);
        });

        mesh.current.instanceMatrix.needsUpdate = true;
    });

    return (
        <instancedMesh ref={mesh} args={[null, null, particles.length]}>
            <boxGeometry args={[0.5, 0.5, 0.5]} />
            <meshStandardMaterial
                color="#00ffff"
                emissive="#00aaaa"
                emissiveIntensity={0.5}
                transparent
                opacity={0.6}
                roughness={0.1}
            />
        </instancedMesh>
    );
}
