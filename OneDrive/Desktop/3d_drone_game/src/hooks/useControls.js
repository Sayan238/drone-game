import { useState, useEffect } from 'react';

export const useControls = () => {
    const [controls, setControls] = useState({
        forward: false,
        backward: false,
        left: false,
        right: false,
        up: false,
        down: false,
        drift: false, // Drift/Slide mode?
        boost: false,
    });

    useEffect(() => {
        const handleKeyDown = (e) => {
            switch (e.code) {
                case 'KeyW': setControls((c) => ({ ...c, forward: true })); break;
                case 'KeyS': setControls((c) => ({ ...c, backward: true })); break;
                case 'KeyA': setControls((c) => ({ ...c, left: true })); break;
                case 'KeyD': setControls((c) => ({ ...c, right: true })); break;
                case 'Space': setControls((c) => ({ ...c, up: true })); break;
                case 'ControlLeft': setControls((c) => ({ ...c, down: true })); break;
                case 'ShiftLeft': setControls((c) => ({ ...c, boost: true })); break;
                default: break;
            }
        };

        const handleKeyUp = (e) => {
            switch (e.code) {
                case 'KeyW': setControls((c) => ({ ...c, forward: false })); break;
                case 'KeyS': setControls((c) => ({ ...c, backward: false })); break;
                case 'KeyA': setControls((c) => ({ ...c, left: false })); break;
                case 'KeyD': setControls((c) => ({ ...c, right: false })); break;
                case 'Space': setControls((c) => ({ ...c, up: false })); break;
                case 'ControlLeft': setControls((c) => ({ ...c, down: false })); break;
                case 'ShiftLeft': setControls((c) => ({ ...c, boost: false })); break;
                default: break;
            }
        };

        window.addEventListener('keydown', handleKeyDown);
        window.addEventListener('keyup', handleKeyUp);
        return () => {
            window.removeEventListener('keydown', handleKeyDown);
            window.removeEventListener('keyup', handleKeyUp);
        };
    }, []);

    return controls;
};
