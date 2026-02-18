import { useEffect, useRef } from 'react';
import { io } from 'socket.io-client';
import { useStore } from '../store';

/**
 * Connects the game to the local controller server.
 * When a phone sends control inputs, they are merged into the Zustand store
 * alongside any keyboard inputs already active.
 */
export function useSocketControls() {
    const socketRef = useRef(null);

    useEffect(() => {
        // Try to connect to the controller server on port 3001
        // If the server isn't running, this silently fails — game still works with keyboard
        const socket = io('http://localhost:3001', {
            reconnectionAttempts: 5,
            timeout: 3000,
        });
        socketRef.current = socket;

        socket.on('connect', () => {
            console.log('[Socket] Connected to controller server');
            socket.emit('register', 'game');
        });

        socket.on('registered', (data) => {
            console.log('[Socket] Registered as game client', data);
        });

        socket.on('controller-connected', () => {
            console.log('[Socket] Phone controller connected!');
        });

        socket.on('controller-disconnected', () => {
            console.log('[Socket] Phone controller disconnected');
            // Reset all phone-driven controls to false when phone disconnects
            useStore.getState().setControls({
                forward: false, backward: false,
                left: false, right: false,
                up: false, down: false, boost: false,
            });
        });

        // Merge phone controls into the store
        // Keyboard controls from useControls() also write to the same store,
        // so both input methods work simultaneously.
        socket.on('controls', (phoneControls) => {
            useStore.getState().setControls(phoneControls);
        });

        // Phone flip button → trigger flip in drone
        socket.on('flip', ({ axis, dir }) => {
            useStore.getState().triggerFlip(axis, dir);
        });

        socket.on('connect_error', () => {
            // Server not running — silently ignore, keyboard still works
        });

        return () => {
            socket.disconnect();
        };
    }, []);
}
