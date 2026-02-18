import React, { useRef, useMemo } from 'react';
import { useFrame, useThree } from '@react-three/fiber';
import * as THREE from 'three';
import { getTerrainHeight, isRiver } from '../utils/terrainLogic';

function seededRand(seed) {
    let s = seed;
    return () => { s = (s * 16807) % 2147483647; return (s - 1) / 2147483646; };
}

// ── Vertex shader: Same as grass but maybe less wind ─────────────────
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

        // Gentle Sway
        float wind = sin(uTime * 1.5 + aOffset.x * 0.1 + aPhase) * 0.1;
        wind *= uv.y;

        float c = cos(aRot), s = sin(aRot);
        vec3 pos = position * aScale;
        vec3 r;
        r.x = pos.x * c - pos.z * s;
        r.y = pos.y;
        r.z = pos.x * s + pos.z * c;

        r.x += wind * c;
        r.z += wind * s;
        r += aOffset;

        float dist = length(uCamPos.xz - aOffset.xz);
        vFade = 1.0 - smoothstep(100.0, 180.0, dist);

        gl_Position = projectionMatrix * modelViewMatrix * vec4(r, 1.0);
    }
`;

const fragmentShader = /* glsl */`
    varying vec2  vUv;
    varying float vFade;
    varying vec3  vColor;

    void main() {
        if (vFade < 0.01) discard;

        // Circle shape for "flower head" simple trick?
        // Or just colored blade. Let's stick to colored blade but brighter.
        
        float alpha = 1.0;
        if (alpha < 0.05) discard;

        // Gradient: Dark stem to bright flower top
        vec3 stem = vec3(0.1, 0.4, 0.1);
        
        // If y > 0.7, blend to flower color
        float t = smoothstep(0.6, 1.0, vUv.y);
        vec3 col = mix(stem, vColor, t);

        gl_FragColor = vec4(col, fade); // Ops, use vFade
        gl_FragColor.a = vFade;
    }
`;

// Fix fragment shader 'fade' typo
const fragmentShaderFixed = /* glsl */`
    varying vec2  vUv;
    varying float vFade;
    varying vec3  vColor;

    void main() {
        if (vFade < 0.01) discard;

        // Taper shape
        float shape = smoothstep(0.0, 0.2, vUv.x) * smoothstep(1.0, 0.8, vUv.x);
        if (shape < 0.1) discard;

        // Color: Green stem merging into bright flower color
        vec3 stem = vec3(0.1, 0.5, 0.1);
        float t = smoothstep(0.5, 0.9, vUv.y);
        vec3 col = mix(stem, vColor, t);

        // Make top pop
        if (vUv.y > 0.9) col += 0.2;

        gl_FragColor = vec4(col, vFade);
    }
`;

function buildFlowerGeo(count) {
    const SEGS = 1;
    const VERTS = 4;
    // Simple quad is enough for small flowers

    // Actually, use 2 crossed quads for volume?
    // Let's stick to 1 quad for performance, facing random direction is fine.

    const positions = [];
    const uvs = [];
    const indices = [];

    // Quad: -w,0  w,0  w,h  -w,h
    // 0 1 2, 0 2 3

    const tempPos = new Float32Array(count * 4 * 3);
    const tempUV = new Float32Array(count * 4 * 2);
    const tempInd = new Uint32Array(count * 6);

    // Attributes
    const aOffset = new Float32Array(count * 4 * 3);
    const aRot = new Float32Array(count * 4);
    const aScale = new Float32Array(count * 4);
    const aPhase = new Float32Array(count * 4);
    const aColor = new Float32Array(count * 4 * 3);

    const rand = seededRand(42); // Different seed
    const MAP_HALF = 600;

    let placed = 0;
    let attempt = 0;

    while (placed < count && attempt < count * 10) {
        attempt++;
        const x = (rand() - 0.5) * MAP_HALF * 2;
        const z = (rand() - 0.5) * MAP_HALF * 2;

        if (isRiver(x, z)) continue;
        const h = getTerrainHeight(x, z);
        if (h < 0.8 || h > 20) continue; // Pasture range

        // Flower Palette
        const r = rand();
        let col = new THREE.Color();
        if (r < 0.3) col.setHex(0xffffff); // White
        else if (r < 0.5) col.setHex(0xffdd00); // Yellow
        else if (r < 0.7) col.setHex(0xff3333); // Red
        else col.setHex(0xaa44ff); // Purple

        const scale = 0.5 + rand() * 0.5;
        const rot = rand() * Math.PI * 2;
        const phase = rand() * 10;

        const y = h - 2.0;

        // Fill buffers
        const vBase = placed * 4;
        const iBase = placed * 6;

        // Verts for Quad (local)
        // 0: -0.2, 0, 0
        // 1:  0.2, 0, 0
        // 2:  0.2, 1, 0
        // 3: -0.2, 1, 0
        const w = 0.2;

        tempPos.set([-w, 0, 0, w, 0, 0, w, 1, 0, -w, 1, 0], vBase * 3);
        tempUV.set([0, 0, 1, 0, 1, 1, 0, 1], vBase * 2);
        tempInd.set([vBase, vBase + 1, vBase + 2, vBase, vBase + 2, vBase + 3], iBase);

        for (let k = 0; k < 4; k++) {
            aOffset.set([x, y, z], (vBase + k) * 3);
            aRot[vBase + k] = rot;
            aScale[vBase + k] = scale;
            aPhase[vBase + k] = phase;
            aColor.set([col.r, col.g, col.b], (vBase + k) * 3);
        }
        placed++;
    }

    const geo = new THREE.BufferGeometry();
    geo.setAttribute('position', new THREE.BufferAttribute(tempPos, 3));
    geo.setAttribute('uv', new THREE.BufferAttribute(tempUV, 2));
    geo.setAttribute('aOffset', new THREE.BufferAttribute(aOffset, 3));
    geo.setAttribute('aRot', new THREE.BufferAttribute(aRot, 1));
    geo.setAttribute('aScale', new THREE.BufferAttribute(aScale, 1));
    geo.setAttribute('aPhase', new THREE.BufferAttribute(aPhase, 1));
    geo.setAttribute('aColor', new THREE.BufferAttribute(aColor, 3));
    geo.setIndex(new THREE.BufferAttribute(tempInd, 1));
    return geo;
}

const COUNT = 5000;

export default function Flowers() {
    const { camera } = useThree();
    const meshRef = useRef();
    const geometry = useMemo(() => buildFlowerGeo(COUNT), []);
    const material = useMemo(() => new THREE.ShaderMaterial({
        vertexShader,
        fragmentShader: fragmentShaderFixed,
        uniforms: {
            uTime: { value: 0 },
            uCamPos: { value: new THREE.Vector3() }
        },
        side: THREE.DoubleSide,
        transparent: true,
        depthWrite: false
    }), []);

    useFrame((state) => {
        material.uniforms.uTime.value = state.clock.getElapsedTime();
        material.uniforms.uCamPos.value.copy(camera.position);
    });

    return <mesh ref={meshRef} geometry={geometry} material={material} frustumCulled={false} />;
}
