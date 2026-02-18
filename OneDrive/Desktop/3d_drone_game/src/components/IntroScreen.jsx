import React, { useEffect, useRef, useState } from 'react';
import { useStore } from '../store';
import { QRCodeCanvas } from 'qrcode.react';

export default function IntroScreen({ peerId }) {
    const { setGameScreen } = useStore();
    const canvasRef = useRef();
    const [loaded, setLoaded] = useState(false);

    // Particle star field on canvas
    useEffect(() => {
        const canvas = canvasRef.current;
        if (!canvas) return;
        const ctx = canvas.getContext('2d');
        let raf;
        let w = canvas.width = window.innerWidth;
        let h = canvas.height = window.innerHeight;

        const stars = Array.from({ length: 220 }, () => ({
            x: Math.random() * w, y: Math.random() * h,
            r: Math.random() * 1.6 + 0.3,
            speed: Math.random() * 0.25 + 0.05,
            opacity: Math.random() * 0.7 + 0.3,
        }));

        const resize = () => {
            w = canvas.width = window.innerWidth;
            h = canvas.height = window.innerHeight;
        };
        window.addEventListener('resize', resize);

        let t = 0;
        const draw = () => {
            t += 0.01;
            ctx.clearRect(0, 0, w, h);
            stars.forEach(s => {
                s.y += s.speed;
                if (s.y > h) { s.y = 0; s.x = Math.random() * w; }
                const pulse = 0.5 + 0.5 * Math.sin(t * 2 + s.x);
                ctx.beginPath();
                ctx.arc(s.x, s.y, s.r, 0, Math.PI * 2);
                ctx.fillStyle = `rgba(180,220,255,${s.opacity * pulse})`;
                ctx.fill();
            });
            raf = requestAnimationFrame(draw);
        };
        draw();
        setTimeout(() => setLoaded(true), 100);
        return () => { cancelAnimationFrame(raf); window.removeEventListener('resize', resize); };
    }, []);

    return (
        <div style={{
            position: 'fixed', inset: 0, zIndex: 1000,
            background: 'radial-gradient(ellipse at 50% 30%, #0a1628 0%, #050a14 60%, #000 100%)',
            display: 'flex', flexDirection: 'column',
            alignItems: 'center', justifyContent: 'center',
            fontFamily: "'Courier New', monospace",
            overflow: 'hidden',
        }}>
            {/* Star canvas */}
            <canvas ref={canvasRef} style={{ position: 'absolute', inset: 0, pointerEvents: 'none' }} />

            {/* Glow orb behind title */}
            <div style={{
                position: 'absolute', top: '18%', left: '50%', transform: 'translateX(-50%)',
                width: 320, height: 320, borderRadius: '50%',
                background: 'radial-gradient(circle, rgba(0,238,255,0.12) 0%, transparent 70%)',
                filter: 'blur(40px)',
                animation: 'pulse 3s ease-in-out infinite',
            }} />

            {/* Drone SVG silhouette */}
            <div style={{
                position: 'relative', zIndex: 2, marginBottom: 8,
                opacity: loaded ? 1 : 0, transition: 'opacity 0.8s',
                animation: 'float 3s ease-in-out infinite',
            }}>
                <svg width="110" height="70" viewBox="0 0 110 70" fill="none">
                    {/* Body */}
                    <rect x="42" y="28" width="26" height="14" rx="4" fill="rgba(0,238,255,0.9)" />
                    {/* Arms */}
                    <line x1="55" y1="35" x2="15" y2="20" stroke="rgba(0,238,255,0.7)" strokeWidth="3" strokeLinecap="round" />
                    <line x1="55" y1="35" x2="95" y2="20" stroke="rgba(0,238,255,0.7)" strokeWidth="3" strokeLinecap="round" />
                    <line x1="55" y1="35" x2="15" y2="50" stroke="rgba(0,238,255,0.7)" strokeWidth="3" strokeLinecap="round" />
                    <line x1="55" y1="35" x2="95" y2="50" stroke="rgba(0,238,255,0.7)" strokeWidth="3" strokeLinecap="round" />
                    {/* Propellers */}
                    {[[15, 20], [95, 20], [15, 50], [95, 50]].map(([cx, cy], i) => (
                        <g key={i}>
                            <circle cx={cx} cy={cy} r="10" fill="none" stroke="rgba(0,238,255,0.5)" strokeWidth="1.5" />
                            <circle cx={cx} cy={cy} r="3" fill="rgba(0,238,255,0.9)" />
                        </g>
                    ))}
                    {/* Glow */}
                    <circle cx="55" cy="35" r="18" fill="rgba(0,238,255,0.08)" />
                </svg>
            </div>

            {/* Title */}
            <div style={{
                position: 'relative', zIndex: 2, textAlign: 'center',
                opacity: loaded ? 1 : 0, transition: 'opacity 1s 0.2s',
            }}>
                <div style={{
                    fontSize: 'clamp(36px, 8vw, 72px)',
                    fontWeight: 900,
                    letterSpacing: '0.12em',
                    background: 'linear-gradient(135deg, #00eeff 0%, #ffffff 40%, #00eeff 70%, #7b2fff 100%)',
                    WebkitBackgroundClip: 'text',
                    WebkitTextFillColor: 'transparent',
                    backgroundClip: 'text',
                    textShadow: 'none',
                    lineHeight: 1.1,
                    marginBottom: 6,
                }}>DRONE STRIKE</div>
                <div style={{
                    fontSize: 13, letterSpacing: '0.35em',
                    color: 'rgba(0,238,255,0.55)', marginBottom: 40,
                }}>AERIAL RACING SIMULATOR</div>
            </div>

            {/* Buttons */}
            <div style={{
                position: 'relative', zIndex: 2, display: 'flex', flexDirection: 'column',
                gap: 14, alignItems: 'center',
                opacity: loaded ? 1 : 0, transition: 'opacity 1s 0.5s',
            }}>
                <IntroBtn
                    primary
                    onClick={() => setGameScreen('levelSelect')}
                    label="▶  PLAY"
                />
                <IntroBtn
                    onClick={() => setGameScreen('playing')}
                    label="⚡  QUICK START"
                />
            </div>

            {/* Footer */}
            <div style={{
                position: 'absolute', bottom: 20, left: 0, right: 0,
                textAlign: 'center', fontSize: 10,
                color: 'rgba(0,238,255,0.2)', letterSpacing: '0.2em',
                zIndex: 2,
            }}>
                USE WASD / ARROW KEYS · SPACE TO BOOST · PHONE CONTROLLER SUPPORTED
            </div>

            {/* QR Code for Mobile Controller */}
            {peerId && (
                <div style={{
                    position: 'absolute', bottom: 40, left: 40, zIndex: 10,
                    background: 'rgba(0,0,0,0.6)', padding: 10, borderRadius: 10,
                    backdropFilter: 'blur(5px)', border: '1px solid rgba(0,238,255,0.3)',
                    display: 'flex', flexDirection: 'column', alignItems: 'center'
                }}>
                    <div style={{ color: '#00eeff', fontSize: 10, marginBottom: 8, letterSpacing: '0.1em' }}>SCAN TO CONTROL</div>
                    <QRCodeCanvas
                        value={`${window.location.href.split('#')[0]}#controller?id=${peerId}`}
                        size={100}
                        bgColor={"transparent"}
                        fgColor={"#00eeff"}
                        level={"L"}
                        includeMargin={false}
                    />
                </div>
            )}


            <style>{`
                @keyframes float {
                    0%,100% { transform: translateY(0px); }
                    50%      { transform: translateY(-12px); }
                }
                @keyframes pulse {
                    0%,100% { opacity: 0.6; transform: translateX(-50%) scale(1); }
                    50%      { opacity: 1;   transform: translateX(-50%) scale(1.15); }
                }
                .intro-btn:hover { transform: scale(1.05) !important; }
                .intro-btn:active { transform: scale(0.97) !important; }
            `}</style>
        </div>
    );
}

function IntroBtn({ label, onClick, primary }) {
    return (
        <button
            className="intro-btn"
            onClick={onClick}
            style={{
                width: 240, height: 52,
                background: primary
                    ? 'linear-gradient(135deg, rgba(0,238,255,0.18), rgba(0,100,200,0.18))'
                    : 'rgba(255,255,255,0.04)',
                border: primary ? '1.5px solid rgba(0,238,255,0.7)' : '1.5px solid rgba(255,255,255,0.15)',
                borderRadius: 26,
                color: primary ? '#00eeff' : 'rgba(255,255,255,0.6)',
                fontSize: 14, fontWeight: 700, letterSpacing: '0.15em',
                cursor: 'pointer',
                transition: 'transform 0.15s, box-shadow 0.15s',
                boxShadow: primary ? '0 0 24px rgba(0,238,255,0.2)' : 'none',
                fontFamily: "'Courier New', monospace",
            }}
        >
            {label}
        </button>
    );
}
