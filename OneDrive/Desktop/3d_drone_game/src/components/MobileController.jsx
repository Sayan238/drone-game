import React, { useEffect, useState, useRef } from 'react';
import { Joystick } from 'react-joystick-component';
import Peer from 'peerjs';

export default function MobileController() {
    const [status, setStatus] = useState('Active');
    const [peerId, setPeerId] = useState('');
    const connRef = useRef(null);
    const peerRef = useRef(null);

    // Parse Peer ID from URL
    useEffect(() => {
        const params = new URLSearchParams(window.location.hash.split('?')[1]);
        const id = params.get('id');
        if (id) {
            setPeerId(id);
            initPeer(id);
        } else {
            setStatus('Error: No ID');
        }

        return () => {
            if (connRef.current) connRef.current.close();
            if (peerRef.current) peerRef.current.destroy();
        };
    }, []);

    const initPeer = (hostId) => {
        const peer = new Peer();
        peerRef.current = peer;

        peer.on('open', (id) => {
            setStatus('Connecting...');
            const conn = peer.connect(hostId);
            connRef.current = conn;

            conn.on('open', () => {
                setStatus('Connected');
                conn.send({ type: 'handshake', name: 'Mobile' });
            });

            conn.on('close', () => setStatus('Disconnected'));
            conn.on('error', () => setStatus('Error'));
        });
    };

    const sendData = (data) => {
        if (connRef.current && connRef.current.open) {
            connRef.current.send(data);
        }
    };

    // Handlers
    const handleMove = (e) => sendData({ type: 'joystick', id: 'move', x: e.x, y: e.y });
    const handleStopMove = () => sendData({ type: 'joystick', id: 'move', x: 0, y: 0 });
    const handleLook = (e) => sendData({ type: 'joystick', id: 'look', x: e.x, y: e.y });
    const handleStopLook = () => sendData({ type: 'joystick', id: 'look', x: 0, y: 0 });
    const handleButton = (action, pressed) => sendData({ type: 'button', action, pressed });

    return (
        <div style={{
            position: 'fixed', inset: 0,
            backgroundColor: '#000', color: '#fff', touchAction: 'none',
            display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
            backgroundImage: 'radial-gradient(circle at center, #112 0%, #000 100%)'
        }}>
            {/* Status Bar */}
            <div style={{
                position: 'absolute', top: 0, left: 0, right: 0,
                padding: '10px', textAlign: 'center', fontSize: '12px',
                color: status === 'Connected' ? '#0f0' : '#f00',
                background: 'rgba(0,0,0,0.5)', letterSpacing: '2px', fontFamily: 'monospace'
            }}>
                ● {status.toUpperCase()}
            </div>

            {/* Controls Container */}
            <div style={{
                display: 'flex', flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center',
                width: '100%', height: '100%', padding: '0 5vw', boxSizing: 'border-box'
            }}>

                {/* Left Joystick - MOVE (Cyan) */}
                <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 10 }}>
                    <Joystick
                        size={120}
                        baseColor="rgba(255,255,255,0.1)"
                        stickColor="rgba(0,255,255,0.8)"
                        move={handleMove}
                        stop={handleStopMove}
                    />
                    <div style={{ fontFamily: 'monospace', fontSize: 10, color: '#0ff', opacity: 0.7, letterSpacing: 2 }}>MOVE</div>
                </div>

                {/* Center Buttons */}
                <div style={{ display: 'flex', flexDirection: 'column', gap: 20, alignItems: 'center' }}>
                    <button
                        onPointerDown={() => handleButton('boost', true)}
                        onPointerUp={() => handleButton('boost', false)}
                        style={btnStyle}
                    >
                        BOOST
                    </button>
                    <button
                        onPointerDown={() => handleButton('flip', true)}
                        onPointerUp={() => handleButton('flip', false)}
                        style={{ ...btnStyle, border: '1px solid #fa0', color: '#fa0', boxShadow: '0 0 10px rgba(255,170,0,0.2)' }}
                    >
                        FLIP
                    </button>
                </div>

                {/* Right Joystick - ALT (Magenta) */}
                <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 10 }}>
                    <Joystick
                        size={120}
                        baseColor="rgba(255,255,255,0.1)"
                        stickColor="rgba(255,0,255,0.8)"
                        move={handleLook}
                        stop={handleStopLook}
                    />
                    <div style={{ fontFamily: 'monospace', fontSize: 10, color: '#f0f', opacity: 0.7, letterSpacing: 2 }}>ALT / LOOK</div>
                </div>

            </div>
        </div>
    );
}

const btnStyle = {
    background: 'rgba(0,0,0,0.3)',
    border: '1px solid #0ff',
    color: '#0ff',
    padding: '15px 30px',
    borderRadius: '30px',
    fontFamily: 'monospace',
    fontWeight: 'bold',
    fontSize: '14px',
    letterSpacing: '2px',
    cursor: 'pointer',
    width: '120px',
    backdropFilter: 'blur(4px)',
    boxShadow: '0 0 15px rgba(0,255,255,0.2)'
};
