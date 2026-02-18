import { create } from 'zustand';

export const useStore = create((set, get) => ({
    score: 0,
    energy: 100,
    gameStatus: 'playing', // playing, gameover, won

    // Screen routing
    gameScreen: 'intro',
    currentLevel: 1,

    // Win condition - Gates
    gatesPassed: 0,
    totalGates: 0,


    setGameScreen: (screen) => set({ gameScreen: screen }),
    setLevel: (level) => set({ currentLevel: level }),


    setTotalGates: (count) => set({ totalGates: count, gatesPassed: 0 }),
    passGate: () => {
        set((state) => {
            const newPassed = state.gatesPassed + 1;
            const won = newPassed >= state.totalGates;
            return {
                gatesPassed: newPassed,
                gameStatus: won ? 'won' : state.gameStatus,
                score: state.score + 500 + (won ? 5000 : 0) // Bonus for winning
            };
        });
    },

    addScore: (points) => set((state) => ({ score: state.score + points })),
    useEnergy: (amount) => set((state) => ({ energy: Math.max(0, state.energy - amount) })),
    addEnergy: (amount) => set((state) => ({ energy: Math.min(100, state.energy + amount) })),
    setGameStatus: (status) => set({ gameStatus: status }),

    resetGame: () => set({
        score: 0,
        energy: 100,
        gameStatus: 'playing',
        gatesPassed: 0
    }),

    // Flip trigger
    pendingFlip: null,
    triggerFlip: (axis, dir) => set({ pendingFlip: { axis, dir } }),
    clearFlip: () => set({ pendingFlip: null }),

    // Controls State
    controls: { forward: false, backward: false, left: false, right: false, up: false, down: false },
    setControls: (newControls) => set((state) => ({ controls: { ...state.controls, ...newControls } })),

    // Gyroscope
    gyroEnabled: false,
    setGyroEnabled: (val) => set({ gyroEnabled: val }),
}));
