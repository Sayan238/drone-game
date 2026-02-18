import React from 'react';
import { useStore } from '../store';

export default function HUD() {
    const { score, energy, gameStatus, setGameScreen, resetGame } = useStore();

    const energyColor = energy > 50 ? '#00eeff' : energy > 20 ? '#ffaa00' : '#ff3333';
    const energyGlow = energy > 50 ? 'cyan' : energy > 20 ? '#ffaa00' : 'red';

    return (
        <div style={{
            position: 'fixed',
            top: 0, left: 0,
            width: '100%',
            boxSizing: 'border-box',
            padding: '12px 4vw',
            pointerEvents: 'none',
            zIndex: 10,
            fontFamily: "'Rajdhani', 'Courier New', monospace",
            fontWeight: 700,
        }}>
            {/* Top HUD bar */}
            <div style={{
                display: 'flex',
                alignItems: 'center',
                gap: '14px',
                background: 'linear-gradient(135deg, rgba(0,10,30,0.75) 0%, rgba(0,20,50,0.6) 100%)',
                backdropFilter: 'blur(12px)',
                WebkitBackdropFilter: 'blur(12px)',
                borderRadius: '14px',
                padding: '8px 18px',
                border: '1px solid rgba(0,238,255,0.25)',
                boxShadow: '0 0 20px rgba(0,238,255,0.12), inset 0 1px 0 rgba(255,255,255,0.08)',
            }}>
                {/* Score panel */}
                <div style={{
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'flex-start',
                    minWidth: 'fit-content',
                }}>
                    <div style={{
                        fontSize: 'clamp(8px, 1.8vw, 11px)',
                        color: 'rgba(0,238,255,0.6)',
                        letterSpacing: '0.15em',
                        textTransform: 'uppercase',
                        lineHeight: 1,
                    }}>Score</div>
                    <div style={{
                        fontSize: 'clamp(14px, 3.5vw, 22px)',
                        color: '#fff',
                        textShadow: '0 0 12px rgba(0,238,255,0.8)',
                        letterSpacing: '0.08em',
                        lineHeight: 1.2,
                    }}>{score.toString().padStart(6, '0')}</div>
                </div>

                {/* Divider */}
                <div style={{ width: '1px', height: '36px', background: 'rgba(0,238,255,0.2)' }} />

                {/* Energy section */}
                <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{
                        display: 'flex',
                        justifyContent: 'space-between',
                        alignItems: 'center',
                        marginBottom: '4px',
                    }}>
                        <div style={{
                            fontSize: 'clamp(8px, 1.8vw, 11px)',
                            color: 'rgba(0,238,255,0.6)',
                            letterSpacing: '0.15em',
                            textTransform: 'uppercase',
                        }}>Energy</div>
                        <div style={{
                            fontSize: 'clamp(9px, 2vw, 13px)',
                            color: energyColor,
                            textShadow: `0 0 8px ${energyGlow}`,
                        }}>{Math.round(energy)}%</div>
                    </div>
                    {/* Energy bar */}
                    <div style={{
                        height: '8px',
                        borderRadius: '4px',
                        background: 'rgba(0,0,0,0.5)',
                        border: `1px solid ${energyColor}44`,
                        overflow: 'hidden',
                        position: 'relative',
                    }}>
                        <div style={{
                            width: `${energy}%`,
                            height: '100%',
                            background: `linear-gradient(90deg, ${energyColor}aa, ${energyColor})`,
                            boxShadow: `0 0 10px ${energyGlow}`,
                            transition: 'width 0.25s ease, background 0.4s ease',
                            borderRadius: '4px',
                        }} />
                        {/* Shimmer overlay */}
                        <div style={{
                            position: 'absolute',
                            top: 0, left: 0,
                            width: '100%', height: '50%',
                            background: 'linear-gradient(180deg, rgba(255,255,255,0.15) 0%, transparent 100%)',
                            borderRadius: '4px',
                            pointerEvents: 'none',
                        }} />
                    </div>
                </div>

                {/* Divider */}
                <div style={{ width: '1px', height: '36px', background: 'rgba(0,238,255,0.2)' }} />

                {/* Altitude/Speed indicator placeholder */}
                <div style={{
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'flex-end',
                    minWidth: 'fit-content',
                }}>
                    <div style={{
                        fontSize: 'clamp(8px, 1.8vw, 11px)',
                        color: 'rgba(0,238,255,0.6)',
                        letterSpacing: '0.15em',
                        textTransform: 'uppercase',
                        lineHeight: 1,
                    }}>Status</div>
                    <div style={{
                        fontSize: 'clamp(10px, 2.5vw, 14px)',
                        color: '#00ff88',
                        textShadow: '0 0 8px #00ff88',
                        letterSpacing: '0.05em',
                        lineHeight: 1.2,
                    }}>ONLINE</div>
                </div>
            </div>

            {/* Crosshair */}
            <div style={{
                position: 'fixed',
                top: '50%', left: '50%',
                transform: 'translate(-50%, -50%)',
                width: '24px', height: '24px',
                pointerEvents: 'none',
            }}>
                {/* Outer ring */}
                <div style={{
                    position: 'absolute',
                    inset: 0,
                    border: '1.5px solid rgba(0,238,255,0.45)',
                    borderRadius: '50%',
                }} />
                {/* Center dot */}
                <div style={{
                    position: 'absolute',
                    top: '50%', left: '50%',
                    width: '3px', height: '3px',
                    background: 'rgba(0,238,255,0.9)',
                    borderRadius: '50%',
                    transform: 'translate(-50%, -50%)',
                    boxShadow: '0 0 6px cyan',
                }} />
                {/* Cross lines */}
                {[
                    { top: '50%', left: '0', width: '6px', height: '1px', transform: 'translateY(-50%)' },
                    { top: '50%', right: '0', width: '6px', height: '1px', transform: 'translateY(-50%)' },
                    { left: '50%', top: '0', height: '6px', width: '1px', transform: 'translateX(-50%)' },
                    { left: '50%', bottom: '0', height: '6px', width: '1px', transform: 'translateX(-50%)' },
                ].map((s, i) => (
                    <div key={i} style={{
                        position: 'absolute',
                        background: 'rgba(0,238,255,0.7)',
                        ...s,
                    }} />
                ))}
            </div>

            {/* Game Over overlay */}
            {gameStatus === 'gameover' && (
                <div style={{
                    position: 'fixed',
                    top: '50%', left: '50%',
                    transform: 'translate(-50%, -50%)',
                    textAlign: 'center',
                    background: 'linear-gradient(135deg, rgba(0,0,0,0.92) 0%, rgba(20,0,0,0.88) 100%)',
                    backdropFilter: 'blur(20px)',
                    WebkitBackdropFilter: 'blur(20px)',
                    padding: '5vw 6vw',
                    border: '2px solid rgba(255,50,50,0.6)',
                    borderRadius: '20px',
                    boxShadow: '0 0 60px rgba(255,0,0,0.3), inset 0 0 40px rgba(255,0,0,0.05)',
                    width: '80vw',
                    maxWidth: '440px',
                }}>
                    <div style={{
                        fontSize: 'clamp(24px, 8vw, 56px)',
                        color: '#ff3333',
                        textShadow: '0 0 30px red, 0 0 60px rgba(255,0,0,0.5)',
                        letterSpacing: '0.05em',
                        lineHeight: 1.1,
                    }}>
                        CRITICAL FAILURE
                    </div>
                    <div style={{
                        fontSize: 'clamp(12px, 3.5vw, 20px)',
                        color: 'rgba(255,255,255,0.7)',
                        marginTop: '14px',
                        letterSpacing: '0.2em',
                        textTransform: 'uppercase',
                    }}>
                        System Shutdown
                    </div>
                    <div style={{
                        marginTop: '20px',
                        fontSize: 'clamp(14px, 4vw, 22px)',
                        color: '#fff',
                        textShadow: '0 0 10px rgba(255,255,255,0.5)',
                    }}>
                        Score: <span style={{ color: '#00eeff', textShadow: '0 0 12px cyan' }}>{score.toString().padStart(6, '0')}</span>
                    </div>
                    <div style={{ marginTop: 28, display: 'flex', gap: 12, justifyContent: 'center', pointerEvents: 'all' }}>
                        <button
                            onClick={() => { resetGame(); }}
                            style={{
                                padding: '10px 22px', borderRadius: 20,
                                background: 'rgba(0,238,255,0.12)', border: '1px solid rgba(0,238,255,0.5)',
                                color: '#00eeff', fontSize: 12, fontWeight: 700,
                                letterSpacing: '0.15em', cursor: 'pointer',
                                fontFamily: "'Courier New', monospace",
                            }}
                        >↺ RETRY</button>
                        <button
                            onClick={() => { resetGame(); setGameScreen('levelSelect'); }}
                            style={{
                                padding: '10px 22px', borderRadius: 20,
                                background: 'rgba(255,255,255,0.05)', border: '1px solid rgba(255,255,255,0.2)',
                                color: 'rgba(255,255,255,0.7)', fontSize: 12, fontWeight: 700,
                                letterSpacing: '0.15em', cursor: 'pointer',
                                fontFamily: "'Courier New', monospace",
                            }}
                        >⌂ MENU</button>
                    </div>
                </div>
            )}

            {/* Win Screen overlay */}
            {gameStatus === 'won' && (
                <div style={{
                    position: 'fixed',
                    top: '50%', left: '50%',
                    transform: 'translate(-50%, -50%)',
                    textAlign: 'center',
                    background: 'linear-gradient(135deg, rgba(0,20,10,0.92) 0%, rgba(0,40,20,0.88) 100%)',
                    backdropFilter: 'blur(20px)',
                    WebkitBackdropFilter: 'blur(20px)',
                    padding: '5vw 6vw',
                    border: '2px solid rgba(0,255,136,0.6)',
                    borderRadius: '20px',
                    boxShadow: '0 0 60px rgba(0,255,136,0.3), inset 0 0 40px rgba(0,255,136,0.05)',
                    width: '80vw',
                    maxWidth: '440px',
                    pointerEvents: 'auto',
                }}>
                    <div style={{
                        fontSize: 'clamp(24px, 7vw, 48px)',
                        color: '#00ff88',
                        textShadow: '0 0 30px #00ff88, 0 0 60px rgba(0,255,136,0.5)',
                        letterSpacing: '0.05em',
                        lineHeight: 1.1,
                        fontWeight: 900,
                    }}>
                        MISSION COMPLETE
                    </div>
                    <div style={{
                        fontSize: 'clamp(12px, 3.5vw, 20px)',
                        color: 'rgba(255,255,255,0.7)',
                        marginTop: '14px',
                        letterSpacing: '0.2em',
                        textTransform: 'uppercase',
                    }}>
                        All Systems Normal
                    </div>
                    <div style={{
                        marginTop: '20px',
                        fontSize: 'clamp(14px, 4vw, 22px)',
                        color: '#fff',
                        textShadow: '0 0 10px rgba(255,255,255,0.5)',
                    }}>
                        Final Score: <span style={{ color: '#00eeff', textShadow: '0 0 12px cyan' }}>{score.toString().padStart(6, '0')}</span>
                    </div>
                    <div style={{ marginTop: 28, display: 'flex', gap: 12, justifyContent: 'center' }}>
                        <button
                            onClick={() => { resetGame(); }}
                            style={{
                                padding: '10px 22px', borderRadius: 20,
                                background: 'rgba(0,255,136,0.15)', border: '1px solid rgba(0,255,136,0.5)',
                                color: '#00ff88', fontSize: 12, fontWeight: 700,
                                letterSpacing: '0.15em', cursor: 'pointer',
                                fontFamily: "'Courier New', monospace",
                                boxShadow: '0 0 15px rgba(0,255,136,0.2)',
                            }}
                        >↺ REPLAY</button>
                        <button
                            onClick={() => { resetGame(); setGameScreen('levelSelect'); }}
                            style={{
                                padding: '10px 22px', borderRadius: 20,
                                background: 'rgba(255,255,255,0.05)', border: '1px solid rgba(255,255,255,0.2)',
                                color: 'rgba(255,255,255,0.7)', fontSize: 12, fontWeight: 700,
                                letterSpacing: '0.15em', cursor: 'pointer',
                                fontFamily: "'Courier New', monospace",
                            }}
                        >⌂ MENU</button>
                    </div>
                </div>
            )}

        </div>
    );
}
