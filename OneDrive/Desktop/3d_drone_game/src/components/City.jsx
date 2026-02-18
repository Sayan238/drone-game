import React, { useLayoutEffect, useRef, useMemo } from 'react';
import { InstancedMesh, Object3D, Color } from 'three';

const COUNT = 200; // Number of buildings
const SIZE = 200; // City spread

export default function City() {
    const meshRef = useRef();

    // Generate building data
    const buildings = useMemo(() => {
        const temp = [];
        for (let i = 0; i < COUNT; i++) {
            const x = (Math.random() - 0.5) * SIZE;
            const z = (Math.random() - 0.5) * SIZE;
            const y = Math.random() * 20; // Height variation
            // Avoid center (drone start area)
            if (Math.abs(x) < 10 && Math.abs(z) < 10) continue;
            temp.push({ x, z, y, scaleY: Math.random() * 10 + 5 });
        }
        return temp;
    }, []);

    useLayoutEffect(() => {
        if (!meshRef.current) return;
        const tempObject = new Object3D();
        const color = new Color();

        buildings.forEach((data, i) => {
            tempObject.position.set(data.x, data.y / 2 - 10, data.z); // Center vertically based on height
            tempObject.scale.set(Math.random() * 5 + 2, data.scaleY, Math.random() * 5 + 2);
            tempObject.updateMatrix();
            meshRef.current.setMatrixAt(i, tempObject.matrix);

            // Random Neon Colors
            const isNeon = Math.random() > 0.8;
            if (isNeon) color.setHSL(Math.random(), 1, 0.5);
            else color.set('#111');

            meshRef.current.setColorAt(i, color);
        });
        meshRef.current.instanceMatrix.needsUpdate = true;
        if (meshRef.current.instanceColor) meshRef.current.instanceColor.needsUpdate = true;
    }, [buildings]);

    return (
        <group>
            {/* Floor - Deep void with grid */}
            <gridHelper args={[200, 50, '#ff00ff', '#222']} position={[0, -10, 0]} />

            {/* Instanced Buildings */}
            <instancedMesh ref={meshRef} args={[null, null, COUNT]} castShadow receiveShadow>
                <boxGeometry args={[1, 1, 1]} />
                <meshStandardMaterial color="#222" roughness={0.1} metalness={0.9} />
            </instancedMesh>
        </group>
    );
}
