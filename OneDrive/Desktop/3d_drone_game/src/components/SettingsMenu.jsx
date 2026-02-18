import React, { useState } from 'react';
import { useStore } from '../store';

export default function SettingsMenu() {
    const [open, setOpen] = useState(false);
    const gyroEnabled = useStore((s) => s.gyroEnabled);
    const setGyroEnabled = useStore((s) => s.setGyroEnabled);

    const btnBase = {
        background: 'rgba(0,0,0,0.6)',
        border: '1.5px solid cyan',
        borderRadius: '8px',
        color: 'cyan',
        fontFamily: 'monospace',
        fontWeight: 'bold',
        cursor: 'pointer',
        padding: '8px 14px',
        fontSize: 'clamp(12px, 3.5vw, 16px)',
    };

    return (
        <div style={{
            position: 'fixed',
            top: '10px',
            right: '10px',
            zIndex: 30,
            pointerEvents: 'auto',
        }}>
            {/* Gear button */}
            <button
                onClick={() => setOpen((o) => !o)}
                style={{ ...btnBase, fontSize: '22px', padding: '6px 12px' }}
                title="Settings"
            >
                ⚙️
            </button>

            {/* Panel */}
            {open && (
                <div style={{
                    marginTop: '8px',
                    background: 'rgba(0,0,0,0.85)',
                    border: '1.5px solid cyan',
                    borderRadius: '12px',
                    padding: '16px',
                    minWidth: '200px',
                    boxShadow: '0 0 20px rgba(0,255,255,0.3)',
                }}>
                    <div style={{ color: 'cyan', fontSize: '14px', marginBottom: '12px', letterSpacing: '2px' }}>
                        ── SETTINGS ──
                    </div>

                    {/* Gyro Toggle */}
                    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '12px' }}>
                        <span style={{ color: '#fff', fontSize: 'clamp(12px, 3vw, 15px)', fontFamily: 'monospace' }}>
                            🌀 Gyro Steer
                        </span>
                        <button
                            onClick={() => setGyroEnabled(!gyroEnabled)}
                            style={{
                                ...btnBase,
                                borderColor: gyroEnabled ? '#00ff88' : 'cyan',
                                color: gyroEnabled ? '#00ff88' : 'cyan',
                                padding: '5px 14px',
                                minWidth: '60px',
                            }}
                        >
                            {gyroEnabled ? 'ON' : 'OFF'}
                        </button>
                    </div>

                    {gyroEnabled && (
                        <div style={{ color: 'rgba(0,255,136,0.7)', fontSize: '11px', marginTop: '8px', fontFamily: 'monospace' }}>
                            Tilt phone to steer.<br />
                            Use right stick for altitude.
                        </div>
                    )}

                    {/* Controls hint */}
                    <div style={{ borderTop: '1px solid rgba(0,255,255,0.2)', marginTop: '14px', paddingTop: '10px', color: 'rgba(255,255,255,0.5)', fontSize: '11px', fontFamily: 'monospace', lineHeight: '1.6' }}>
                        PC: WASD / Arrows<br />
                        Space = Up · Shift = Boost
                    </div>
                </div>
            )}
        </div>
    );
}
