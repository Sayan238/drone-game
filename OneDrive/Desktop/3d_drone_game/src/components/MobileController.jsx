import React, { useEffect, useState, useRef } from 'react';
import { Joystick } from 'react-joystick-component';
import Peer from 'peerjs';

export default function MobileController() {
    const [status, setStatus] = useState('Connecting...');
    const [peerId, setPeerId] = useState('');
    const connRef = useRef(null);
    const peerRef = useRef(null);

    // Parse Peer ID from URL: #controller?id=...
    useEffect(() => {
        const params = new URLSearchParams(window.location.hash.split('?')[1]);
        const id = params.get('id');
        if (id) {
            setPeerId(id);
            initPeer(id);
        } else {
            setStatus('Error: No Game ID found in URL');
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
            console.log('My Peer ID:', id);
            setStatus(`Connecting to Game (${hostId})...`);

            const conn = peer.connect(hostId);
            connRef.current = conn;

            conn.on('open', () => {
                setStatus('Connected! 🎮');
                // Send initial handshake
                conn.send({ type: 'handshake', name: 'Mobile Controller' });
            });

            conn.on('close', () => {
                setStatus('Disconnected');
            });

            conn.on('error', (err) => {
                console.error(err);
                setStatus('Connection Error');
            });
        });

        peer.on('error', (err) => {
            console.error(err);
            setStatus('Peer Error: ' + err.type);
        });
    };

    const sendData = (data) => {
        if (connRef.current && connRef.current.open) {
            connRef.current.send(data);
        }
    };

    // Input handlers
    const handleMove = (e) => {
        // e.x, e.y are usually -1 to 1? Or pixels?
        // react-joystick-component returns x, y logic?
        // Actually it returns { type: "move", x: number, y: number, direction: string, distance: number }
        // We need to normalize.
        // Assuming joystick size=100.
        // Let's console log or check docs.
        // Usually x/y are relative.
        // We'll normalize in game or here.
        // Let's send raw x/y.
        sendData({ type: 'joystick', id: 'move', x: e.x, y: e.y });
    };

    const handleStopMove = () => {
        sendData({ type: 'joystick', id: 'move', x: 0, y: 0 });
    };

    const handleLook = (e) => {
        sendData({ type: 'joystick', id: 'look', x: e.x, y: e.y });
    };

    const handleStopLook = () => {
        sendData({ type: 'joystick', id: 'look', x: 0, y: 0 });
    };

    const handleButton = (action, pressed) => {
        sendData({ type: 'button', action, pressed });
    };

    return (
        <div style={{
            position: 'fixed', top: 0, left: 0, width: '100%', height: '100%',
            backgroundColor: '#111', color: '#fff', touchAction: 'none',
            display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center'
        }}>
            <h2 style={{ position: 'absolute', top: 10, fontSize: '1.2rem' }}>{status}</h2>

            <div style={{
                display: 'flex', flexDirection: 'row', justifyContent: 'space-between',
                width: '100%', padding: '0 40px', boxSizing: 'border-box', marginTop: 'auto', marginBottom: 40
            }}>
                {/* Left Joystick - Movement */}
                <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                    <div style={{ marginBottom: 10 }}>MOVE</div>
                    <Joystick
                        size={120}
                        baseColor="#333"
                        stickColor="#0af"
                        move={handleMove}
                        stop={handleStopMove}
                    />
                </div>

                {/* Center Buttons */}
                <div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'center', gap: 20 }}>
                    <button
                        onPointerDown={() => handleButton('boost', true)}
                        onPointerUp={() => handleButton('boost', false)}
                        style={btnStyle('#f00')}
                    >BOOST 🚀</button>

                    <button
                        onPointerDown={() => handleButton('flip', true)}
                        onPointerUp={() => handleButton('flip', false)} // Flip is usually trigger
                        style={btnStyle('#fa0')}
                    >FLIP 🔄</button>

                    <button
                        onClick={() => window.location.reload()}
                        style={{ ...btnStyle('#555'), fontSize: '0.8rem', padding: '10px' }}
                    >RECONNECT</button>
                </div>

                {/* Right Joystick - Look/Up/Down */}
                <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                    <div style={{ marginBottom: 10 }}>LOOK / ALT</div>
                    <Joystick
                        size={120}
                        baseColor="#333"
                        stickColor="#0f8"
                        move={handleLook}
                        stop={handleStopLook}
                    />
                </div>
            </div>

            <div style={{ position: 'absolute', bottom: 10, fontSize: '0.8rem', opacity: 0.5 }}>
                PeerID: {peerId ? peerId.substring(0, 8) + '...' : 'None'}
            </div>
        </div>
    );
}

const btnStyle = (col) => ({
    padding: '20px', borderRadius: '50%', border: 'none',
    backgroundColor: col, color: '#fff', fontWeight: 'bold',
    width: '80px', height: '80px', boxShadow: '0 0 10px ' + col
});
