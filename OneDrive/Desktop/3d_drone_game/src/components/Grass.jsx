import React, { useRef, useMemo } from 'react';
import { useFrame, useThree } from '@react-three/fiber';
import * as THREE from 'three';
import { getTerrainHeight, isRiver } from '../utils/terrainLogic';

function seededRand(seed) {
    let s = seed;
    return () => { s = (s * 16807) % 2147483647; return (s - 1) / 2147483646; };
}

// ── Vertex shader: 5-segment bent blade ─────────────────────────────
const vertexShader = /* glsl */`
    attribute vec3  aOffset;
    attribute float aRot;
    attribute float aScale;
    attribute float aPhase;
    attribute vec3  aColor;

    uniform float uTime;
    uniform vec3  uCamPos;

    varying vec2  vUv;
    varying float vFade;
    varying vec3  vColor;

    void main() {
        vUv    = uv;
        vColor = aColor;

        // Wind — quadratic so only tip sways
        float wind = sin(uTime * 1.8 + aOffset.x * 0.05 + aOffset.z * 0.05 + aPhase) * 0.22
                   + sin(uTime * 3.2 + aPhase * 1.3) * 0.07;
        wind *= uv.y * uv.y;

        // Bend blade slightly forward (natural lean)
        float bend = uv.y * uv.y * 0.15;

        // Rotate blade around Y
        float c = cos(aRot), s = sin(aRot);
        vec3 pos = position * aScale;
        vec3 r;
        r.x = pos.x * c - pos.z * s;
        r.y = pos.y;
        r.z = pos.x * s + pos.z * c;

        // Apply wind + bend
        r.x += (wind + bend) * c;
        r.z += (wind + bend) * s;

        r += aOffset;

        // LOD fade
        float dist = length(uCamPos.xz - aOffset.xz);
        vFade = 1.0 - smoothstep(150.0, 250.0, dist);

        gl_Position = projectionMatrix * modelViewMatrix * vec4(r, 1.0);
    }
`;

// ... fragment shader unchanged ...
// ── Fragment shader: color gradient + AO + alpha taper ──────────────
const fragmentShader = /* glsl */`
    varying vec2  vUv;
    varying float vFade;
    varying vec3  vColor;

    void main() {
        if (vFade < 0.01) discard;

        // Alpha: taper at tip, solid at base
        float alpha = smoothstep(1.0, 0.6, vUv.y) * smoothstep(0.0, 0.08, vUv.x) * smoothstep(1.0, 0.92, vUv.x);
        alpha = max(alpha, 0.0);
        if (alpha < 0.05) discard;

        // AO: darker at base
        float ao = 0.3 + vUv.y * 0.7;

        // Color: interpolate from per-blade base color to bright tip
        vec3 tipColor = vColor * 1.6 + vec3(0.05, 0.12, 0.0);
        vec3 col = mix(vColor * ao, tipColor, vUv.y * vUv.y);

        gl_FragColor = vec4(col, alpha * vFade);
    }
`;


// ── Build blade geometry: 5-segment quad strip ───────────────────────
function buildBladesGeo(count) {
    const SEGS = 3;
    const VERTS_PER_BLADE = (SEGS + 1) * 2; // 12 verts
    const TRIS_PER_BLADE = SEGS * 2;        // 10 tris

    const positions = new Float32Array(count * VERTS_PER_BLADE * 3);
    const uvs = new Float32Array(count * VERTS_PER_BLADE * 2);
    const indices = new Uint32Array(count * TRIS_PER_BLADE * 3);
    const aOffset = new Float32Array(count * VERTS_PER_BLADE * 3);
    const aRot = new Float32Array(count * VERTS_PER_BLADE);
    const aScale = new Float32Array(count * VERTS_PER_BLADE);
    const aPhase = new Float32Array(count * VERTS_PER_BLADE);
    const aColor = new Float32Array(count * VERTS_PER_BLADE * 3);

    // Build one blade template (5-segment quad strip, tapers to tip)
    const bladeVerts = [];
    const bladeUVs = [];
    for (let s = 0; s <= SEGS; s++) {
        const t = s / SEGS;
        const w = (1 - t) * 0.12; // Wider blades for volume
        bladeVerts.push([-w, t, 0], [w, t, 0]);
        bladeUVs.push([0, t], [1, t]);
    }
    const bladeIdx = [];
    for (let s = 0; s < SEGS; s++) {
        const b = s * 2;
        bladeIdx.push(b, b + 1, b + 2, b + 1, b + 3, b + 2);
    }

    const rand = seededRand(99);
    const MAP_HALF = 600; // Updated to match Terrain
    const offsets = [];
    let placed = 0, attempts = 0;

    while (placed < count && attempts < count * 6) {
        attempts++;
        const x = (rand() - 0.5) * MAP_HALF * 2;
        const z = (rand() - 0.5) * MAP_HALF * 2;

        // Don't spawn in river
        if (isRiver(x, z)) continue;

        const h = getTerrainHeight(x, z);

        // Height constraints: Above water (0.6) and below high rock (25)
        if (h < 0.6 || h > 25) continue;

        // Also avoid very center spawn (landing pad?)
        if (Math.sqrt(x * x + z * z) < 15) continue;

        offsets.push({ x, y: h - 2.8, z }); // Bury deeper to prevent floating
        placed++;
    }

    for (let b = 0; b < offsets.length; b++) {
        const { x, y, z } = offsets[b];
        const rot = rand() * Math.PI * 2;
        const scale = 0.8 + rand() * 1.0; // Taller grass
        const phase = rand() * Math.PI * 2;

        // Per-blade color: dark green to medium green
        const hue = 0.28 + rand() * 0.08;
        const sat = 0.55 + rand() * 0.3;
        const lit = 0.12 + rand() * 0.12;
        const col = new THREE.Color().setHSL(hue, sat, lit);

        const vBase = b * VERTS_PER_BLADE;
        for (let v = 0; v < VERTS_PER_BLADE; v++) {
            const vi = (vBase + v) * 3;
            const ui = (vBase + v) * 2;
            positions[vi] = bladeVerts[v][0];
            positions[vi + 1] = bladeVerts[v][1];
            positions[vi + 2] = bladeVerts[v][2];
            uvs[ui] = bladeUVs[v][0];
            uvs[ui + 1] = bladeUVs[v][1];
            aOffset[vi] = x;
            aOffset[vi + 1] = y;
            aOffset[vi + 2] = z;
            aRot[vBase + v] = rot;
            aScale[vBase + v] = scale;
            aPhase[vBase + v] = phase;
            aColor[vi] = col.r;
            aColor[vi + 1] = col.g;
            aColor[vi + 2] = col.b;
        }

        const iBase = b * TRIS_PER_BLADE * 3;
        for (let t = 0; t < bladeIdx.length; t++) {
            indices[iBase + t] = vBase + bladeIdx[t];
        }
    }

    const geo = new THREE.BufferGeometry();
    geo.setAttribute('position', new THREE.BufferAttribute(positions, 3));
    geo.setAttribute('uv', new THREE.BufferAttribute(uvs, 2));
    geo.setAttribute('aOffset', new THREE.BufferAttribute(aOffset, 3));
    geo.setAttribute('aRot', new THREE.BufferAttribute(aRot, 1));
    geo.setAttribute('aScale', new THREE.BufferAttribute(aScale, 1));
    geo.setAttribute('aPhase', new THREE.BufferAttribute(aPhase, 1));
    geo.setAttribute('aColor', new THREE.BufferAttribute(aColor, 3));
    geo.setIndex(new THREE.BufferAttribute(indices, 1));
    return geo;
}

const BLADE_COUNT = 45000;

export default function Grass() {
    const { camera } = useThree();
    const meshRef = useRef();

    const geometry = useMemo(() => buildBladesGeo(BLADE_COUNT), []);

    const material = useMemo(() => new THREE.ShaderMaterial({
        vertexShader,
        fragmentShader,
        uniforms: {
            uTime: { value: 0 },
            uCamPos: { value: new THREE.Vector3() },
        },
        side: THREE.DoubleSide,
        transparent: true,
        depthWrite: false,
    }), []);

    useFrame((state) => {
        material.uniforms.uTime.value = state.clock.getElapsedTime();
        material.uniforms.uCamPos.value.copy(camera.position);
    });

    return (
        <mesh
            ref={meshRef}
            geometry={geometry}
            material={material}
            frustumCulled={false}
        />
    );
}
