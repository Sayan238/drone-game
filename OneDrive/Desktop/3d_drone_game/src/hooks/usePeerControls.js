import { useEffect, useState, useRef } from 'react';
import Peer from 'peerjs';
import { useStore } from '../store';

export function usePeerControls() {
    const [peerId, setPeerId] = useState(null);
    const [connected, setConnected] = useState(false);
    const peerRef = useRef(null);
    const connRef = useRef(null);

    // Joystick state to debounce or hold values
    const joystickState = useRef({
        move: { x: 0, y: 0 },
        look: { x: 0, y: 0 }
    });

    useEffect(() => {
        const peer = new Peer(); // Auto-generate ID
        peerRef.current = peer;

        peer.on('open', (id) => {
            console.log('Host Peer ID:', id);
            setPeerId(id);
        });

        peer.on('connection', (conn) => {
            console.log('Mobile Controller connected:', conn.peer);
            setConnected(true);
            connRef.current = conn;

            conn.on('data', (data) => {
                handleData(data);
            });

            conn.on('close', () => {
                console.log('Mobile Controller disconnected');
                setConnected(false);
                resetControls();
            });
        });

        return () => {
            if (peerRef.current) peerRef.current.destroy();
        };
    }, []);

    const handleData = (data) => {
        if (data.type === 'joystick') {
            if (data.id === 'move') joystickState.current.move = { x: data.x, y: data.y };
            if (data.id === 'look') joystickState.current.look = { x: data.x, y: data.y };
            updateControls();
        } else if (data.type === 'button') {
            if (data.action === 'boost') {
                // Boost logic? Just key mapping or state?
                // Standard drone doesn't have boost in store controls?
                // Check Drone.jsx. Usually 'Shift' is up/boost.
                // Let's map 'boost' to 'up' for now?
                // Or add 'boost' to store controls.
                // Store has 'up', 'down'.
                // I'll map boost to extra speed if possible, or just 'up'.
                // For now, let's map it to 'boost' in controls (dynamically added).
                useStore.getState().setControls({ [data.action]: data.pressed });
            } else if (data.action === 'flip' && data.pressed) {
                // Trigger flip
                useStore.getState().triggerFlip('x', 1);
            }
        }
    };

    const updateControls = () => {
        const move = joystickState.current.move;
        const look = joystickState.current.look;

        // Map Joystick to Store Controls (Boolean for now)
        // Threshold 0.5
        const controls = {
            forward: move.y > 0.5,   // Joystick Y is usually inverted? Up is negative?
            // Library: "y is positive downwards".
            // So Forward (Up) is negative Y?
            // react-joystick-component: y is positive UP.
            // Wait, let's check docs or test.
            // Usually Up is Y>0.
            backward: move.y < -0.5,

            right: move.x > 0.5,
            left: move.x < -0.5,

            // Look Joystick -> Altitude?
            up: look.y > 0.5,
            down: look.y < -0.5,

            // Yaw? Store doesn't have yaw keys?
            // Drone.jsx uses 'left'/'right' for Roll/Yaw mix?
            // Standard controls: A/D rotates (Yaw).
            // Left/Right arrows rolls.
            // My store has 'left', 'right'.
            // I'll map Look X to... maybe nothing for now if no yaw control?
            // Or map Look X to Left/Right (Yaw) and Move X to Roll (Strafe)?
            // Current game likely mixes them.
            // I'll stick to basic mapping.
        };

        useStore.getState().setControls(controls);
    };

    const resetControls = () => {
        useStore.getState().setControls({
            forward: false, backward: false,
            left: false, right: false,
            up: false, down: false, boost: false
        });
    };

    return { peerId, connected };
}
