import React, { useState } from 'react';
import { useBox } from '@react-three/cannon';
import { useFrame } from '@react-three/fiber';
import { useStore } from '../store';

export default function Obstacle({ position }) {
    const useEnergy = useStore((state) => state.useEnergy);

    const [ref, api] = useBox(() => ({
        mass: 10, // Heavy obstacle
        position,
        angularDamping: 0.5,
        linearDamping: 0.5,
        onCollide: (e) => {
            if (e.body.userData?.name === 'drone') {
                useEnergy(10); // Damage on potential crash logic
                // Apply impulse to push drone away?
                // Physics handles collision response naturally
            }
        }
    }));

    useFrame((state) => {
        // Slowly rotate
        api.angularVelocity.set(0, 0.5, 0);
    });

    return (
        <mesh ref={ref} castShadow receiveShadow>
            <boxGeometry args={[2, 2, 2]} />
            <meshStandardMaterial color="red" emissive="red" emissiveIntensity={0.5} wireframe />
        </mesh>
    );
}
