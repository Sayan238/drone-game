import express from 'express';
import { createServer } from 'http';
import { Server } from 'socket.io';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import os from 'os';

const __dirname = dirname(fileURLToPath(import.meta.url));
const app = express();
const httpServer = createServer(app);

const io = new Server(httpServer, {
    cors: { origin: '*' }
});

// Serve the mobile controller page
app.get('/controller', (req, res) => {
    res.sendFile(join(__dirname, 'controller.html'));
});

app.get('/', (req, res) => {
    res.send(`
        <html><body style="font-family:monospace;background:#111;color:#0ff;padding:40px">
        <h2>🚁 Drone Controller Server</h2>
        <p>Server is running!</p>
        <p><a href="/controller" style="color:#0ff">Open Mobile Controller →</a></p>
        <hr style="border-color:#333">
        <p style="color:#888">Open the controller link on your phone while on the same WiFi.</p>
        </body></html>
    `);
});

// Track connected clients
let controllerSocket = null;
let gameClients = new Set();

io.on('connection', (socket) => {
    console.log(`[+] Client connected: ${socket.id}`);

    // Client announces who it is
    socket.on('register', (role) => {
        if (role === 'controller') {
            controllerSocket = socket;
            console.log('[Controller] Phone connected');
            socket.emit('registered', { role: 'controller', gameConnected: gameClients.size > 0 });
            // Tell game clients a controller is connected
            gameClients.forEach(s => s.emit('controller-connected'));
        } else if (role === 'game') {
            gameClients.add(socket);
            console.log(`[Game] PC game connected (total: ${gameClients.size})`);
            socket.emit('registered', { role: 'game', controllerConnected: !!controllerSocket });
            if (controllerSocket) controllerSocket.emit('game-connected');
        }
    });

    // Phone sends control state → relay to all game clients
    socket.on('controls', (data) => {
        gameClients.forEach(s => s.emit('controls', data));
    });

    // Phone sends flip trigger → relay to all game clients
    socket.on('flip', (data) => {
        gameClients.forEach(s => s.emit('flip', data));
    });

    socket.on('disconnect', () => {
        console.log(`[-] Client disconnected: ${socket.id}`);
        if (socket === controllerSocket) {
            controllerSocket = null;
            gameClients.forEach(s => s.emit('controller-disconnected'));
        }
        gameClients.delete(socket);
    });
});

// Print local IP for easy access
function getLocalIP() {
    const nets = os.networkInterfaces();
    for (const name of Object.keys(nets)) {
        for (const net of nets[name]) {
            if (net.family === 'IPv4' && !net.internal) return net.address;
        }
    }
    return 'localhost';
}

const PORT = 3001;
httpServer.listen(PORT, '0.0.0.0', () => {
    const ip = getLocalIP();
    console.log('\n🚁 Drone Controller Server running!');
    console.log(`\n  PC Game:    http://localhost:5173`);
    console.log(`  Controller: http://${ip}:${PORT}/controller`);
    console.log(`\n  👆 Open the controller URL on your phone (same WiFi)\n`);
});
