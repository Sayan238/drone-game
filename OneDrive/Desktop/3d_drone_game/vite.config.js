import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import mkcert from 'vite-plugin-mkcert'

// https://vite.dev/config/
export default defineConfig({
  base: '/drone-game/',
  plugins: [react(), process.env.NODE_ENV !== 'production' && mkcert()].filter(Boolean),
  server: {
    host: true,
    https: true,
  }
})
