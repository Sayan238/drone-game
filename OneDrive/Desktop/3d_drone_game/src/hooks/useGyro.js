import { useEffect } from 'react';
import { useStore } from '../store';

/**
 * useGyro — reads DeviceOrientation and maps tilt to drone controls.
 * gamma = left/right tilt  → left/right
 * beta  = forward/back tilt → forward/backward
 * Only active when gyroEnabled is true in the store.
 */
export function useGyro() {
    const gyroEnabled = useStore((s) => s.gyroEnabled);
    const setControls = useStore((s) => s.setControls);

    useEffect(() => {
        if (!gyroEnabled) {
            // Clear any gyro-set controls when disabled
            setControls({ forward: false, backward: false, left: false, right: false });
            return;
        }

        const DEAD = 5;   // degrees dead-zone
        const MAX = 25;  // degrees for full tilt

        const handleOrientation = (e) => {
            const gamma = e.gamma ?? 0; // left/right  -90..90
            const beta = e.beta ?? 0; // front/back  -180..180

            setControls({
                left: gamma < -DEAD,
                right: gamma > DEAD,
                forward: beta > DEAD && beta < MAX + 30,
                backward: beta < -DEAD,
            });
        };

        // iOS 13+ requires permission
        if (typeof DeviceOrientationEvent !== 'undefined' &&
            typeof DeviceOrientationEvent.requestPermission === 'function') {
            DeviceOrientationEvent.requestPermission()
                .then((perm) => {
                    if (perm === 'granted') {
                        window.addEventListener('deviceorientation', handleOrientation);
                    }
                })
                .catch(console.error);
        } else {
            window.addEventListener('deviceorientation', handleOrientation);
        }

        return () => window.removeEventListener('deviceorientation', handleOrientation);
    }, [gyroEnabled]);
}
