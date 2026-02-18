import React, { useRef, useEffect } from 'react';
import { useSphere } from '@react-three/cannon';
import { useFrame, useThree } from '@react-three/fiber';
import { useFBX } from '@react-three/drei';
import { Vector3, Euler, Quaternion, MathUtils, Object3D } from 'three';
import { useStore } from '../store';
import { useMemo } from 'react';

// Keys for flips — detected via keydown events
const flipState = { left: false, right: false, forward: false, backward: false };

function WindParticles({ velRef }) {
    const mesh = useRef();
    const count = 80;
    const dummy = useMemo(() => new Object3D(), []);
    const particles = useMemo(() => new Array(count).fill().map(() => ({
        pos: new Vector3((Math.random() - 0.5) * 30, (Math.random() - 0.5) * 20, (Math.random() - 0.5) * 20),
        speed: 0.5 + Math.random(),
        len: 1 + Math.random() * 3
    })), []);

    useFrame((state, delta) => {
        if (!velRef.current || !mesh.current) return;
        const vel = velRef.current;
        const speed = Math.sqrt(vel[0] ** 2 + vel[1] ** 2 + vel[2] ** 2);

        if (speed < 4) {
            mesh.current.visible = false;
            return;
        }
        mesh.current.visible = true;
        mesh.current.material.opacity = Math.min((speed - 4) / 40, 0.5);

        // Position mesh at camera
        mesh.current.position.copy(state.camera.position);

        // Rotate to align with movement direction (so lines stream past)
        // velocity is world vector. We look at (pos + vel) so -Z faces movement
        const lookTgt = mesh.current.position.clone().add(new Vector3(vel[0], vel[1], vel[2]));
        mesh.current.lookAt(lookTgt);

        particles.forEach((p, i) => {
            // Move particles in +Z direction (streaming past camera)
            p.pos.z += speed * p.speed * delta * 1.5;
            if (p.pos.z > 10) p.pos.z = -30; // Reset far ahead

            dummy.position.copy(p.pos);
            // Orient line along Z axis
            dummy.rotation.x = Math.PI / 2;
            dummy.scale.set(1, p.len + speed * 0.1, 1); // Stretch based on speed
            dummy.updateMatrix();
            mesh.current.setMatrixAt(i, dummy.matrix);
        });
        mesh.current.instanceMatrix.needsUpdate = true;
    });

    return (
        <instancedMesh ref={mesh} args={[null, null, count]}>
            <cylinderGeometry args={[0.03, 0.03, 1]} />
            <meshBasicMaterial color="white" transparent opacity={0} depthWrite={false} />
        </instancedMesh>
    );
}

export default function Drone() {
    const { camera } = useThree();

    const [ref, api] = useSphere(() => ({
        mass: 1,
        position: [0, 5, 0],
        linearDamping: 0.88,
        angularDamping: 0.99,
        args: [0.5],
        userData: { name: 'drone' }
    }));

    const posRef = useRef(new Vector3(0, 5, 0));
    const velRef = useRef([0, 0, 0]);
    const yawRef = useRef(0);

    // Visual tilt (smooth, not physics)
    const pitchRef = useRef(0); // forward/back tilt
    const rollRef = useRef(0); // left/right tilt

    // Flip state
    const flipRef = useRef(null); // { axis: 'x'|'z', dir: 1|-1, progress: 0 }

    useEffect(() => api.position.subscribe((p) => posRef.current.set(p[0], p[1], p[2])), []);
    useEffect(() => api.velocity.subscribe((v) => (velRef.current = v)), []);

    // Listen for flip keys (Q = roll left, E = roll right, double-tap handled via rapid press)
    useEffect(() => {
        const lastPress = {};
        const DOUBLE_TAP = 350; // ms

        const onKey = (e) => {
            const key = e.key.toLowerCase();
            const now = Date.now();

            // Single-press flip triggers: Q / E / double W / double S
            if (key === 'q' && !flipRef.current) {
                flipRef.current = { axis: 'z', dir: -1, progress: 0 };
            }
            if (key === 'e' && !flipRef.current) {
                flipRef.current = { axis: 'z', dir: 1, progress: 0 };
            }
            // Double-tap W = front flip, double-tap S = back flip
            if (key === 'w' || key === 'arrowup') {
                if (lastPress[key] && now - lastPress[key] < DOUBLE_TAP && !flipRef.current) {
                    flipRef.current = { axis: 'x', dir: 1, progress: 0 };
                }
                lastPress[key] = now;
            }
            if (key === 's' || key === 'arrowdown') {
                if (lastPress[key] && now - lastPress[key] < DOUBLE_TAP && !flipRef.current) {
                    flipRef.current = { axis: 'x', dir: -1, progress: 0 };
                }
                lastPress[key] = now;
            }
        };
        window.addEventListener('keydown', onKey);
        return () => window.removeEventListener('keydown', onKey);
    }, []);

    const model = useFBX('/models/drone.fbx');
    const modelRef = useRef();

    // Auto-detect propellers
    const propellers = useRef([]);
    useEffect(() => {
        const found = [];
        model.traverse((child) => {
            const name = child.name.toLowerCase();
            if (
                name.includes('prop') ||
                name.includes('rotor') ||
                name.includes('blade') ||
                name.includes('fan') ||
                name.includes('wing')
            ) {
                found.push(child);
            }
        });
        propellers.current = found;
    }, [model]);

    useFrame((state, delta) => {
        const { forward, backward, left, right, up, down, boost } = useStore.getState().controls;

        const speed = boost ? 28 : 16;
        const turnRate = 2.2;

        // Spin props
        const propSpeed = boost ? 30 : 20;
        propellers.current.forEach((prop, i) => {
            prop.rotation.y += propSpeed * delta * (i % 2 === 0 ? 1 : -1);
        });

        // ── Yaw ─────────────────────────────────────────────────────
        if (left) yawRef.current += turnRate * delta;
        if (right) yawRef.current -= turnRate * delta;

        // ── Check store for mobile-triggered flip ────────────────────
        const { pendingFlip, clearFlip } = useStore.getState();
        if (pendingFlip && !flipRef.current) {
            flipRef.current = { axis: pendingFlip.axis, dir: pendingFlip.dir, progress: 0 };
            clearFlip();
        }

        // ── Flip animation ──────────────────────────────────────────
        if (flipRef.current) {
            const flip = flipRef.current;
            const flipSpeed = 6.5; // radians per second
            flip.progress += flipSpeed * delta;

            if (modelRef.current) {
                if (flip.axis === 'z') {
                    modelRef.current.rotation.z = flip.dir * flip.progress;
                } else {
                    modelRef.current.rotation.x = flip.dir * flip.progress;
                }
            }

            if (flip.progress >= Math.PI * 2) {
                flipRef.current = null;
                if (modelRef.current) {
                    modelRef.current.rotation.x = 0;
                    modelRef.current.rotation.z = 0;
                }
            }
        }

        // ── Smooth visual tilt (FPV feel) ────────────────────────────
        if (!flipRef.current && modelRef.current) {
            const targetPitch = forward ? -0.28 : backward ? 0.22 : 0;
            const targetRoll = left ? 0.20 : right ? -0.20 : 0;

            pitchRef.current = MathUtils.lerp(pitchRef.current, targetPitch, delta * 6);
            rollRef.current = MathUtils.lerp(rollRef.current, targetRoll, delta * 6);

            modelRef.current.rotation.x = pitchRef.current;
            modelRef.current.rotation.z = rollRef.current;
        }

        // ── Physics velocity ─────────────────────────────────────────
        const fwdX = -Math.sin(yawRef.current);
        const fwdZ = -Math.cos(yawRef.current);

        let vx = 0, vy = 0, vz = 0;
        if (forward) { vx += fwdX * speed; vz += fwdZ * speed; }
        if (backward) { vx -= fwdX * speed; vz -= fwdZ * speed; }
        if (up) vy = speed;
        if (down) vy = -speed;

        // Strafe (left/right movement while turning)
        const strafeX = -Math.cos(yawRef.current);
        const strafeZ = Math.sin(yawRef.current);

        const cur = velRef.current;
        api.velocity.set(
            (forward || backward) ? vx : cur[0],
            (up || down) ? vy : cur[1],
            (forward || backward) ? vz : cur[2]
        );

        // Apply yaw quaternion to physics body
        const targetQuat = new Quaternion().setFromEuler(new Euler(0, yawRef.current, 0));
        api.quaternion.set(targetQuat.x, targetQuat.y, targetQuat.z, targetQuat.w);
        api.angularVelocity.set(0, 0, 0);

        // ── FPV Camera — low angle behind drone ─────────────────────
        const pos = posRef.current;

        // Camera sits low and close behind — FPV style
        const camDist = 5.5;
        const camHeight = 1.8;
        const camTargetX = pos.x + Math.sin(yawRef.current) * camDist;
        const camTargetZ = pos.z + Math.cos(yawRef.current) * camDist;

        camera.position.lerp(
            new Vector3(camTargetX, pos.y + camHeight, camTargetZ),
            delta * 7
        );

        // Look slightly ahead of drone for FPV feel
        const lookAheadX = pos.x - Math.sin(yawRef.current) * 2;
        const lookAheadZ = pos.z - Math.cos(yawRef.current) * 2;
        camera.lookAt(lookAheadX, pos.y - 0.3, lookAheadZ);
    });

    // Audio
    useEffect(() => {
        const audioCtx = new (window.AudioContext || window.webkitAudioContext)();
        const oscillator = audioCtx.createOscillator();
        const gainNode = audioCtx.createGain();
        oscillator.connect(gainNode);
        gainNode.connect(audioCtx.destination);
        oscillator.type = 'sawtooth';
        oscillator.frequency.value = 100;
        gainNode.gain.value = 0.015;
        oscillator.start();

        const interval = setInterval(() => {
            const vel = velRef.current;
            const spd = Math.sqrt(vel[0] ** 2 + vel[1] ** 2 + vel[2] ** 2);
            oscillator.frequency.setTargetAtTime(100 + spd * 8, audioCtx.currentTime, 0.1);
        }, 100);

        return () => { clearInterval(interval); oscillator.stop(); audioCtx.close(); };
    }, []);

    return (
        <group ref={ref}>
            <group ref={modelRef} rotation={[0, Math.PI, 0]}>
                <primitive
                    object={model}
                    scale={0.002}
                    castShadow
                    receiveShadow
                />
            </group>
            {/* Glow lights */}
            <pointLight intensity={3} distance={8} color="#00eeff" position={[0, 0.3, 0]} />
            <pointLight intensity={1.5} distance={3} color="#00eeff" position={[0.6, 0.1, 0.6]} />
            <pointLight intensity={1.5} distance={3} color="#00eeff" position={[-0.6, 0.1, 0.6]} />
            <pointLight intensity={1.5} distance={3} color="#00eeff" position={[0.6, 0.1, -0.6]} />
            <pointLight intensity={1.5} distance={3} color="#00eeff" position={[-0.6, 0.1, -0.6]} />
            <pointLight intensity={1.2} distance={6} color="#ffcc88" position={[0, -0.5, 0]} />
            <WindParticles velRef={velRef} />
        </group>
    );
}
