import React, { useState } from 'react';
import Gate from './Gate';
import { useStore } from '../store';

export default function Level() {
    const { setTotalGates } = useStore();

    const [gates] = useState(() => {
        const arr = [];
        const GATE_COUNT = 20;

        for (let i = 0; i < GATE_COUNT; i++) {
            // Spread over a much larger area — up to 700 units deep
            const z = -40 - (i * 60);
            // Wider winding path across the expanded map
            const x = Math.sin(i * 0.45) * 60 + Math.cos(i * 0.2) * 20;
            // More height variation
            const y = 12 + Math.sin(i * 0.35) * 8 + Math.cos(i * 0.6) * 4;

            arr.push({
                position: [x, y, z],
                rotation: [0, Math.sin(i * 0.3) * 0.4, Math.sin(i * 0.2) * 0.5]
            });
        }
        return arr;
    });

    React.useEffect(() => {
        setTotalGates(gates.length);
    }, [gates, setTotalGates]);


    return (
        <group>
            {gates.map((data, i) => (
                <Gate key={`gate-${i}`} position={data.position} rotation={data.rotation} />
            ))}
        </group>
    );
}
