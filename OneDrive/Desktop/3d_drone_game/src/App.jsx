import React, { Suspense, useState, useEffect } from 'react';
import { Canvas } from '@react-three/fiber';
import { Physics } from '@react-three/cannon';
import { Stats, Environment, Cloud, Sky, Stars } from '@react-three/drei';
import { EffectComposer, Bloom, Vignette, ChromaticAberration, ToneMapping } from '@react-three/postprocessing';
import { BlendFunction, ToneMappingMode } from 'postprocessing';
import { Vector2 } from 'three';
import Drone from './components/Drone';
import HUD from './components/HUD';
import Terrain from './components/Terrain';
import Trees from './components/Trees';
import Grass from './components/Grass';
import Flowers from './components/Flowers'; // Kept imports just in case
import Level from './components/Level';
import TouchControls from './components/TouchControls';
import SettingsMenu from './components/SettingsMenu';
import IntroScreen from './components/IntroScreen';
import LevelSelectScreen from './components/LevelSelectScreen';
import Waterfall from './components/Waterfall';
import Updraft from './components/Updraft';
import MobileController from './components/MobileController'; // New Controller
import { useControls } from './hooks/useControls';
import { useGyro } from './hooks/useGyro';
import { usePeerControls } from './hooks/usePeerControls'; // Replaces Socket
import { useStore } from './store';

function GameScene() {
  const clouds = React.useMemo(() => {
    return new Array(40).fill(0).map((_, i) => {
      const isBig = i % 5 === 0;
      return {
        position: [(Math.random() - 0.5) * 800, (isBig ? 60 : 30) + Math.random() * 40, (Math.random() - 0.5) * 800],
        speed: (isBig ? 0.05 : 0.1) + Math.random() * 0.2,
        opacity: (isBig ? 0.7 : 0.5) + Math.random() * 0.4,
        width: (isBig ? 300 : 80) + Math.random() * (isBig ? 200 : 100),
        depth: (isBig ? 15 : 5) + Math.random() * 10,
        segments: isBig ? 40 : 20
      };
    });
  }, []);

  return (
    <Canvas
      shadows={{ type: 'PCFSoftShadowMap' }}
      camera={{ position: [0, 5, 10], fov: 60, near: 0.1, far: 2000 }}
      gl={{
        antialias: true,
        powerPreference: 'high-performance',
        alpha: false,
      }}
      dpr={[1, 2]}
      style={{ position: 'fixed', top: 0, left: 0, width: '100vw', height: '100vh', zIndex: 1 }}
    >
      {/* Sky */}
      <Sky
        distance={450000}
        sunPosition={[100, 20, 100]}
        inclination={0.5}
        azimuth={0.25}
        turbidity={8}
        rayleigh={0.5}
        mieCoefficient={0.005}
        mieDirectionalG={0.8}
      />

      {/* Stars for depth */}
      <Stars radius={300} depth={60} count={3000} factor={4} saturation={0} fade speed={1} />

      {/* Atmospheric fog */}
      <fogExp2 attach="fog" args={['#a8c8e8', 0.0010]} />

      {/* Lighting rig */}
      <directionalLight
        position={[100, 80, 50]}
        intensity={3.5}
        castShadow
        shadow-mapSize-width={2048}
        shadow-mapSize-height={2048}
        shadow-camera-near={0.5}
        shadow-camera-far={500}
        shadow-camera-left={-250}
        shadow-camera-right={250}
        shadow-camera-top={250}
        shadow-camera-bottom={-250}
        shadow-bias={-0.0005}
        color="#fff5e0"
      />
      <directionalLight position={[-50, 30, -50]} intensity={0.8} color="#c0d8ff" />
      <ambientLight intensity={0.4} color="#b0c8e8" />
      <hemisphereLight skyColor="#87ceeb" groundColor="#4a7c3f" intensity={0.6} />

      <Suspense fallback={null}>
        <Physics gravity={[0, 0, 0]}>
          <Drone />
          <Terrain />
          <Level />
        </Physics>

        <Trees />
        <Grass />

        <Environment preset="forest" />

        {/* Generated Clouds */}
        {clouds.map((cloud, i) => (
          <Cloud
            key={i}
            opacity={cloud.opacity}
            speed={cloud.speed}
            width={cloud.width}
            depth={cloud.depth}
            segments={cloud.segments}
            position={cloud.position}
          />
        ))}

        {/* Waterfalls */}
        <Waterfall position={[242, 45, -580]} height={60} width={25} />
        <Waterfall position={[184, 25, -100]} height={70} width={10} />

        {/* Updraft Zone */}
        <Updraft position={[20, 0, 10]} height={50} width={10} />
      </Suspense>

      <Stats />
    </Canvas>
  );
}

function Game() {
  useControls();
  useGyro();

  // Initialize PeerJS Host
  const { peerId } = usePeerControls();

  const gameScreen = useStore(s => s.gameScreen);

  return (
    <>
      {/* Unique ID for debugging */}
      {/* <div style={{position:'absolute', top:0, left:0, zIndex:9999, color:'white'}}>{peerId}</div> */}

      {/* Screens */}
      {gameScreen === 'intro' && <IntroScreen peerId={peerId} />}
      {gameScreen === 'levelSelect' && <LevelSelectScreen />}

      {/* Game (mounted when playing) */}
      {gameScreen === 'playing' && (
        <>
          <HUD />
          <TouchControls />
          <SettingsMenu />
          <GameScene />
        </>
      )}
    </>
  );
}

export default function App() {
  // Simple Hash Router for Controller
  const [isController, setIsController] = useState(false);

  useEffect(() => {
    const checkHash = () => setIsController(window.location.hash.startsWith('#controller'));
    checkHash(); // Check on mount
    window.addEventListener('hashchange', checkHash);
    return () => window.removeEventListener('hashchange', checkHash);
  }, []);

  if (isController) {
    return <MobileController />;
  }

  return <Game />;
}
