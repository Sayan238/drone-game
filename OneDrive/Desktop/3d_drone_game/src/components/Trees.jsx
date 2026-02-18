import React, { useLayoutEffect, useRef, useMemo } from 'react';
import { Object3D, Color, MeshStandardMaterial } from 'three';

import { getTerrainHeight, isRiver } from '../utils/terrainLogic';

const TREE_COUNT = 9000;
const MAP_SIZE = 1200;

function seededRand(seed) {
    let s = seed;
    return () => { s = (s * 16807) % 2147483647; return (s - 1) / 2147483646; };
}

export default function Trees() {
    const trunkRef = useRef();
    const foliage1Ref = useRef();
    const foliage2Ref = useRef();
    const foliage3Ref = useRef();
    const snowRef = useRef();

    const trees = useMemo(() => {
        const rand = seededRand(123);
        const arr = [];
        let attempts = 0;
        while (arr.length < TREE_COUNT && attempts < TREE_COUNT * 4) {
            attempts++;
            const x = (rand() - 0.5) * MAP_SIZE;
            const z = (rand() - 0.5) * MAP_SIZE;
            const dist = Math.sqrt(x * x + z * z);
            if (dist < 30) continue; // Clear spawn

            // Don't spawn in river
            if (isRiver(x, z)) continue;

            const h = getTerrainHeight(x, z);

            // Height constraints: Above water (2.0) and below deep snow peaks (55)
            // Trees grow up to 50ish.
            if (h < 2.0 || h > 50) continue;

            // Prevent trees on very steep slopes? (Approximated by noise derivative or just random fail)
            // Simple random fail for now
            if (rand() > 0.85) continue;

            const trunkH = 1.6 + rand() * 4.4; // Taller trees
            const foliageR = 1.0 + rand() * 2.5;
            const yBase = h - 2.5; // Bury trunk deeper to fix floating on low-poly terrain
            const greenShift = rand();
            const leanX = (rand() - 0.5) * 0.1; // More lean on slopes
            const leanZ = (rand() - 0.5) * 0.1;
            const rotY = rand() * Math.PI * 2;
            const isHigh = h > 35; // Snowy trees at high altitude

            arr.push({ x, z, yBase, trunkH, foliageR, greenShift, leanX, leanZ, rotY, isHigh });
        }
        return arr;
    }, []);

    useLayoutEffect(() => {
        const dummy = new Object3D();

        // ── Trunks ──────────────────────────────────────────────────
        if (trunkRef.current) {
            trees.forEach((t, i) => {
                dummy.position.set(t.x, t.yBase + t.trunkH / 2, t.z);
                dummy.scale.set(1, t.trunkH, 1);
                dummy.rotation.set(t.leanX, t.rotY, t.leanZ);
                dummy.updateMatrix();
                trunkRef.current.setMatrixAt(i, dummy.matrix);

                const bark = new Color();
                bark.setHSL(0.07, 0.45, 0.22 + t.greenShift * 0.12);
                trunkRef.current.setColorAt(i, bark);
            });
            trunkRef.current.instanceMatrix.needsUpdate = true;
            trunkRef.current.instanceColor.needsUpdate = true;
        }

        // ── Lower foliage ────────────────────────────────────────────
        if (foliage1Ref.current) {
            trees.forEach((t, i) => {
                dummy.position.set(t.x, t.yBase + t.trunkH + t.foliageR * 0.5, t.z);
                dummy.scale.set(t.foliageR, t.foliageR * 1.3, t.foliageR);
                dummy.rotation.set(0, t.rotY, 0);
                dummy.updateMatrix();
                foliage1Ref.current.setMatrixAt(i, dummy.matrix);

                const col = new Color();
                // Darker, richer pine green
                col.setHSL(0.27 + t.greenShift * 0.05, 0.5 + t.greenShift * 0.2, 0.15 + t.greenShift * 0.1);
                foliage1Ref.current.setColorAt(i, col);
            });
            foliage1Ref.current.instanceMatrix.needsUpdate = true;
            foliage1Ref.current.instanceColor.needsUpdate = true;
        }

        // ── Mid foliage ──────────────────────────────────────────────
        if (foliage2Ref.current) {
            trees.forEach((t, i) => {
                const r2 = t.foliageR * 0.70;
                dummy.position.set(t.x, t.yBase + t.trunkH + t.foliageR * 1.4, t.z);
                dummy.scale.set(r2, r2 * 1.4, r2);
                dummy.rotation.set(0, t.rotY + 0.4, 0);
                dummy.updateMatrix();
                foliage2Ref.current.setMatrixAt(i, dummy.matrix);

                const col = new Color();
                col.setHSL(0.29 + t.greenShift * 0.05, 0.55 + t.greenShift * 0.2, 0.18 + t.greenShift * 0.1);
                foliage2Ref.current.setColorAt(i, col);
            });
            foliage2Ref.current.instanceMatrix.needsUpdate = true;
            foliage2Ref.current.instanceColor.needsUpdate = true;
        }

        // ── Top spike ────────────────────────────────────────────────
        if (foliage3Ref.current) {
            trees.forEach((t, i) => {
                const r3 = t.foliageR * 0.38;
                dummy.position.set(t.x, t.yBase + t.trunkH + t.foliageR * 2.3, t.z);
                dummy.scale.set(r3, r3 * 1.8, r3);
                dummy.rotation.set(0, t.rotY + 0.8, 0);
                dummy.updateMatrix();
                foliage3Ref.current.setMatrixAt(i, dummy.matrix);

                const col = new Color();
                col.setHSL(0.31 + t.greenShift * 0.05, 0.6 + t.greenShift * 0.2, 0.22 + t.greenShift * 0.1);
                foliage3Ref.current.setColorAt(i, col);
            });
            foliage3Ref.current.instanceMatrix.needsUpdate = true;
            foliage3Ref.current.instanceColor.needsUpdate = true;
        }

        // ── Snow caps ────────────────────────────────────────────────
        if (snowRef.current) {
            trees.forEach((t, i) => {
                if (t.isHigh) {
                    const rs = t.foliageR * 0.32;
                    dummy.position.set(t.x, t.yBase + t.trunkH + t.foliageR * 2.6, t.z);
                    dummy.scale.set(rs, rs * 0.5, rs);
                    dummy.rotation.set(0, 0, 0);
                } else {
                    dummy.scale.set(0, 0, 0);
                    dummy.position.set(0, -9999, 0);
                }
                dummy.updateMatrix();
                snowRef.current.setMatrixAt(i, dummy.matrix);
            });
            snowRef.current.instanceMatrix.needsUpdate = true;
        }
    }, [trees]);

    return (
        <group>
            {/* Trunks — brown */}
            <instancedMesh ref={trunkRef} args={[null, null, TREE_COUNT]} castShadow receiveShadow>
                <cylinderGeometry args={[0.15, 0.30, 1, 5]} />
                <meshStandardMaterial roughness={0.95} metalness={0.0} />
            </instancedMesh>

            {/* Lower foliage — dark green */}
            <instancedMesh ref={foliage1Ref} args={[null, null, TREE_COUNT]} castShadow receiveShadow>
                <coneGeometry args={[1, 1, 8]} />
                <meshStandardMaterial roughness={0.88} metalness={0.0} envMapIntensity={0.5} />
            </instancedMesh>

            {/* Mid foliage — medium green */}
            <instancedMesh ref={foliage2Ref} args={[null, null, TREE_COUNT]} castShadow receiveShadow>
                <coneGeometry args={[1, 1, 8]} />
                <meshStandardMaterial roughness={0.85} metalness={0.0} envMapIntensity={0.5} />
            </instancedMesh>

            {/* Top spike — bright green */}
            <instancedMesh ref={foliage3Ref} args={[null, null, TREE_COUNT]} castShadow receiveShadow>
                <coneGeometry args={[1, 1, 5]} />
                <meshStandardMaterial roughness={0.82} metalness={0.0} envMapIntensity={0.6} />
            </instancedMesh>

            {/* Snow caps — white */}
            <instancedMesh ref={snowRef} args={[null, null, TREE_COUNT]} castShadow>
                <coneGeometry args={[1, 0.6, 5]} />
                <meshStandardMaterial color="#ddeeff" roughness={0.5} metalness={0.0} envMapIntensity={0.8} />
            </instancedMesh>
        </group>
    );
}
