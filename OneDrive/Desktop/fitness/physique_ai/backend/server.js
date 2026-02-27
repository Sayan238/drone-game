require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');

// Routes
const authRoutes = require('./routes/auth');
const profileRoutes = require('./routes/profile');
const progressRoutes = require('./routes/progress');
const habitRoutes = require('./routes/habits');
const workoutRoutes = require('./routes/workouts');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Connect to MongoDB
connectDB();

// API Routes
app.use('/api/auth', authRoutes);
app.use('/api/profile', profileRoutes);
app.use('/api/progress', progressRoutes);
app.use('/api/habits', habitRoutes);
app.use('/api/workouts', workoutRoutes);

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'PhysiqueAI API is running' });
});

app.listen(PORT, () => {
  console.log(`🏋️ PhysiqueAI Server running on port ${PORT}`);
});
