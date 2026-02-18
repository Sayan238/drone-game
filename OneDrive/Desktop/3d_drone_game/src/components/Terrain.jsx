import React, { useMemo } from 'react';
import { useHeightfield } from '@react-three/cannon';
import * as THREE from 'three';

import { getTerrainHeight, getRiverPath, getRiverSurfaceY } from '../utils/terrainLogic';

// Terrain constants
const MAP_SIZE = 1200;
const SEGMENTS = 180;
const ELEMENT_SIZE = MAP_SIZE / SEGMENTS;

export default function Terrain() {
    // Generate height data for physics
    const { heights, elementSize } = useMemo(() => {
        const data = [];
        // Cannon.js heightfield axis setup:
        // By default, creates grid in X-Z plane (if rotated -PI/2).
        // It iterates X then Y (which maps to Z in world).

        // We sweep x from -600 to 600, z from 600 to -600 (or -600 to 600).
        // Cannon Heightfield origin is at position.
        // We will position at [-600, -2, -600] (back-left corner).

        for (let i = 0; i <= SEGMENTS; i++) {
            const row = [];
            const x = (i / SEGMENTS) * MAP_SIZE - (MAP_SIZE / 2);
            for (let j = 0; j <= SEGMENTS; j++) {
                // Cannon Z axis corresponds to loop j.
                const z = (j / SEGMENTS) * MAP_SIZE - (MAP_SIZE / 2);
                // data[i][j] is height at (i, j).
                const h = getTerrainHeight(x, z);
                row.push(h);
            }
            data.push(row);
        }
        return { heights: data, elementSize: MAP_SIZE / SEGMENTS };
    }, []);

    const [ref] = useHeightfield(() => ({
        args: [heights, { elementSize: ELEMENT_SIZE }],
        // Note: Cannon Heightfield rotation usually aligns such that data[0][0] is at position.
        // We need to match coordinates carefully.
        position: [-MAP_SIZE / 2, -2, MAP_SIZE / 2],
        rotation: [-Math.PI / 2, 0, 0],
        friction: 0.1
    }), null, [heights]);

    const { geometry, riverGeometry } = useMemo(() => {
        // Reduced resolution to prevent crash (black screen)
        const geo = new THREE.PlaneGeometry(MAP_SIZE, MAP_SIZE, SEGMENTS, SEGMENTS);
        const count = geo.attributes.position.count;
        const colors = new Float32Array(count * 3);
        const positions = geo.attributes.position;

        const snowColor = new THREE.Color('#ffffff');
        const rockHighColor = new THREE.Color('#5a5a5a');
        const rockLowColor = new THREE.Color('#3d3d3d');
        const grassColor = new THREE.Color('#2d5a27');
        const dirtColor = new THREE.Color('#4a4036');
        const sandColor = new THREE.Color('#e0cda5');
        const riverBedColor = new THREE.Color('#2e2620');

        for (let i = 0; i < count; i++) {
            const x = positions.getX(i);
            const y = positions.getY(i); // Z in world

            const height = getTerrainHeight(x, y);
            positions.setZ(i, height);

            // Vertex Coloring
            const riverCenter = getRiverPath(y);
            const distToRiver = Math.abs(x - riverCenter);
            let col;
            if (distToRiver < 16) {
                col = riverBedColor;
            } else if (height > 55) {
                col = snowColor;
            } else if (height > 35) {
                const t = (height - 35) / 20;
                col = rockHighColor.clone().lerp(snowColor, t);
            } else if (height > 15) {
                const t = (height - 15) / 20;
                col = rockLowColor.clone().lerp(rockHighColor, t);
            } else if (height > 5) {
                const t = (height - 5) / 10;
                col = grassColor.clone().lerp(rockLowColor, t);
            } else if (height > 2) {
                col = dirtColor.clone().lerp(grassColor, 0.7);
            } else {
                col = sandColor;
            }

            colors[i * 3] = col.r;
            colors[i * 3 + 1] = col.g;
            colors[i * 3 + 2] = col.b;
        }

        geo.computeVertexNormals();
        geo.setAttribute('color', new THREE.BufferAttribute(colors, 3));

        // Generate River Water Mesh (Strip)
        const riverGeo = new THREE.PlaneGeometry(30, MAP_SIZE, 10, 200);
        const rPos = riverGeo.attributes.position;
        for (let i = 0; i < rPos.count; i++) {
            const rx = rPos.getX(i);
            const ry = rPos.getY(i); // Z
            const pathX = getRiverPath(ry);
            const surfaceY = getRiverSurfaceY(ry);
            rPos.setX(i, pathX + rx);
            rPos.setZ(i, surfaceY);
        }
        riverGeo.computeVertexNormals();

        return { geometry: geo, riverGeometry: riverGeo };
    }, []);

    return (
        <group>
            {/* Main terrain mesh */}
            <mesh rotation={[-Math.PI / 2, 0, 0]} position={[0, -2, 0]} receiveShadow>
                <primitive object={geometry} attach="geometry" />
                <meshStandardMaterial
                    vertexColors
                    roughness={0.85}
                    metalness={0.05}
                    envMapIntensity={0.4}
                />
            </mesh>

            {/* River Water Mesh */}
            <mesh rotation={[-Math.PI / 2, 0, 0]} position={[0, -2.0, 0]}>
                <primitive object={riverGeometry} attach="geometry" />
                <meshStandardMaterial
                    color="#0066cc"
                    roughness={0.05}
                    metalness={0.3}
                    transparent
                    opacity={0.9}
                    emissive="#001133"
                    emissiveIntensity={0.2}
                />
            </mesh>

            {/* Lake Water plane */}
            <mesh rotation={[-Math.PI / 2, 0, 0]} position={[0, -1.2, 0]}>
                <planeGeometry args={[10000, 10000]} />
                <meshStandardMaterial
                    color="#2080cc"
                    roughness={0.08}
                    metalness={0.4}
                    transparent
                    opacity={0.75}
                    envMapIntensity={1.0}
                />
            </mesh>
        </group>
    );
}
