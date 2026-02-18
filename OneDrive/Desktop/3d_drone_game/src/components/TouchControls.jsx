import React from 'react';
import { Joystick } from 'react-joystick-component';
import { useStore } from '../store';

export default function TouchControls() {
    const { setControls } = useStore();

    const handleMove = (e) => {
        setControls({
            forward: e.y > 0.2,
            backward: e.y < -0.2,
            left: e.x < -0.2,
            right: e.x > 0.2,
        });
    };

    const handleAscend = (e) => {
        setControls({
            up: e.y > 0.2,
            down: e.y < -0.2,
        });
    };

    const handleStop = () => {
        setControls({
            forward: false, backward: false,
            left: false, right: false,
            up: false, down: false,
        });
    };

    return (
        <div style={{
            position: 'fixed',
            bottom: 0, left: 0, right: 0,
            height: '180px',
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            padding: '0 5vw',
            pointerEvents: 'auto',
            zIndex: 20,
            boxSizing: 'border-box',
        }}>
            {/* Left Joystick — Move */}
            <div style={{ flexShrink: 0 }}>
                <Joystick
                    size={100}
                    sticky={false}
                    baseColor="rgba(0,0,0,0.45)"
                    stickColor="rgba(0,255,255,0.85)"
                    move={handleMove}
                    stop={handleStop}
                />
                <div style={{ color: 'rgba(0,255,255,0.6)', fontSize: '11px', textAlign: 'center', marginTop: 4, fontFamily: 'monospace' }}>MOVE</div>
            </div>

            {/* Right Joystick — Altitude */}
            <div style={{ flexShrink: 0 }}>
                <Joystick
                    size={100}
                    sticky={false}
                    baseColor="rgba(0,0,0,0.45)"
                    stickColor="rgba(255,0,255,0.85)"
                    move={handleAscend}
                    stop={handleStop}
                />
                <div style={{ color: 'rgba(255,0,255,0.6)', fontSize: '11px', textAlign: 'center', marginTop: 4, fontFamily: 'monospace' }}>ALT</div>
            </div>
        </div>
    );
}
