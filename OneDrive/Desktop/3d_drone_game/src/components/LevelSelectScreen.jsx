import React, { useState } from 'react';
import { useStore } from '../store';

const LEVELS = [
    {
        id: 1,
        name: 'EASY',
        subtitle: 'Training Grounds',
        icon: '🌿',
        color: '#00ff88',
        glow: 'rgba(0,255,136,0.3)',
        border: 'rgba(0,255,136,0.5)',
        gates: 8,
        desc: 'Wide gates, gentle curves. Perfect for beginners.',
        tag: 'BEGINNER',
    },
    {
        id: 2,
        name: 'MEDIUM',
        subtitle: 'Mountain Circuit',
        icon: '⛰️',
        color: '#00eeff',
        glow: 'rgba(0,238,255,0.3)',
        border: 'rgba(0,238,255,0.5)',
        gates: 12,
        desc: 'Tighter gates, altitude changes, winding paths.',
        tag: 'INTERMEDIATE',
    },
    {
        id: 3,
        name: 'HARD',
        subtitle: 'Storm Run',
        icon: '⚡',
        color: '#ff6b35',
        glow: 'rgba(255,107,53,0.3)',
        border: 'rgba(255,107,53,0.5)',
        gates: 16,
        desc: 'Narrow gates, sharp turns, maximum speed required.',
        tag: 'EXPERT',
    },
];

export default function LevelSelectScreen() {
    const { setGameScreen, setLevel, resetGame } = useStore();
    const [hovered, setHovered] = useState(null);

    const handlePlay = (level) => {
        setLevel(level.id);
        resetGame();
        setGameScreen('playing');
    };

    return (
        <div style={{
            position: 'fixed', inset: 0, zIndex: 1000,
            background: 'radial-gradient(ellipse at 50% 20%, #0a1628 0%, #050a14 70%, #000 100%)',
            display: 'flex', flexDirection: 'column',
            alignItems: 'center', justifyContent: 'center',
            fontFamily: "'Courier New', monospace",
            overflow: 'hidden',
        }}>
            {/* Background grid */}
            <div style={{
                position: 'absolute', inset: 0, pointerEvents: 'none',
                backgroundImage: 'linear-gradient(rgba(0,238,255,0.03) 1px, transparent 1px), linear-gradient(90deg, rgba(0,238,255,0.03) 1px, transparent 1px)',
                backgroundSize: '60px 60px',
            }} />

            {/* Back button */}
            <button
                onClick={() => setGameScreen('intro')}
                style={{
                    position: 'absolute', top: 24, left: 24,
                    background: 'rgba(0,238,255,0.07)', border: '1px solid rgba(0,238,255,0.25)',
                    borderRadius: 20, padding: '8px 20px',
                    color: 'rgba(0,238,255,0.7)', fontSize: 12,
                    letterSpacing: '0.15em', cursor: 'pointer',
                    fontFamily: "'Courier New', monospace",
                    transition: 'all 0.2s',
                }}
                onMouseEnter={e => e.target.style.background = 'rgba(0,238,255,0.15)'}
                onMouseLeave={e => e.target.style.background = 'rgba(0,238,255,0.07)'}
            >← BACK</button>

            {/* Header */}
            <div style={{ textAlign: 'center', marginBottom: 48, position: 'relative', zIndex: 2 }}>
                <div style={{
                    fontSize: 11, letterSpacing: '0.4em',
                    color: 'rgba(0,238,255,0.4)', marginBottom: 10,
                }}>SELECT MISSION</div>
                <div style={{
                    fontSize: 'clamp(28px, 5vw, 48px)', fontWeight: 900,
                    letterSpacing: '0.1em',
                    background: 'linear-gradient(135deg, #ffffff 0%, #00eeff 100%)',
                    WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent',
                    backgroundClip: 'text',
                }}>CHOOSE YOUR LEVEL</div>
            </div>

            {/* Level cards */}
            <div style={{
                display: 'flex', gap: 20, flexWrap: 'wrap',
                justifyContent: 'center', padding: '0 20px',
                position: 'relative', zIndex: 2,
            }}>
                {LEVELS.map(level => (
                    <div
                        key={level.id}
                        onMouseEnter={() => setHovered(level.id)}
                        onMouseLeave={() => setHovered(null)}
                        onClick={() => handlePlay(level)}
                        style={{
                            width: 220, padding: '28px 22px',
                            background: hovered === level.id
                                ? `linear-gradient(145deg, rgba(255,255,255,0.07), rgba(0,0,0,0.3))`
                                : 'rgba(255,255,255,0.03)',
                            border: `1.5px solid ${hovered === level.id ? level.border : 'rgba(255,255,255,0.08)'}`,
                            borderRadius: 20,
                            backdropFilter: 'blur(12px)',
                            cursor: 'pointer',
                            transition: 'all 0.25s',
                            transform: hovered === level.id ? 'translateY(-8px) scale(1.02)' : 'translateY(0) scale(1)',
                            boxShadow: hovered === level.id ? `0 20px 60px ${level.glow}` : '0 4px 20px rgba(0,0,0,0.4)',
                            textAlign: 'center',
                        }}
                    >
                        {/* Tag */}
                        <div style={{
                            fontSize: 9, letterSpacing: '0.25em',
                            color: level.color, marginBottom: 14,
                            opacity: 0.8,
                        }}>{level.tag}</div>

                        {/* Icon */}
                        <div style={{ fontSize: 40, marginBottom: 12 }}>{level.icon}</div>

                        {/* Level name */}
                        <div style={{
                            fontSize: 22, fontWeight: 900, letterSpacing: '0.12em',
                            color: level.color, marginBottom: 4,
                        }}>{level.name}</div>

                        {/* Subtitle */}
                        <div style={{
                            fontSize: 10, letterSpacing: '0.15em',
                            color: 'rgba(255,255,255,0.4)', marginBottom: 16,
                        }}>{level.subtitle}</div>

                        {/* Divider */}
                        <div style={{
                            height: 1, background: `linear-gradient(90deg, transparent, ${level.border}, transparent)`,
                            marginBottom: 16,
                        }} />

                        {/* Gates count */}
                        <div style={{
                            fontSize: 11, color: 'rgba(255,255,255,0.5)',
                            marginBottom: 10, letterSpacing: '0.1em',
                        }}>
                            <span style={{ color: level.color, fontWeight: 700 }}>{level.gates}</span> GATES
                        </div>

                        {/* Description */}
                        <div style={{
                            fontSize: 10, color: 'rgba(255,255,255,0.35)',
                            lineHeight: 1.6, marginBottom: 20,
                        }}>{level.desc}</div>

                        {/* Play button */}
                        <div style={{
                            height: 38, borderRadius: 19,
                            background: hovered === level.id
                                ? `linear-gradient(135deg, ${level.color}33, ${level.color}11)`
                                : 'transparent',
                            border: `1px solid ${level.color}66`,
                            display: 'flex', alignItems: 'center', justifyContent: 'center',
                            fontSize: 11, fontWeight: 700, letterSpacing: '0.2em',
                            color: level.color,
                            transition: 'all 0.2s',
                        }}>
                            {hovered === level.id ? '▶  LAUNCH' : 'SELECT'}
                        </div>
                    </div>
                ))}
            </div>

            {/* Footer hint */}
            <div style={{
                position: 'absolute', bottom: 20,
                fontSize: 10, color: 'rgba(0,238,255,0.2)',
                letterSpacing: '0.2em', zIndex: 2,
            }}>CLICK ANY LEVEL TO START</div>
        </div>
    );
}
