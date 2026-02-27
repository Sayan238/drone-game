const express = require('express');
const router = express.Router();
const auth = require('../middleware/authMiddleware');
const WorkoutLog = require('../models/WorkoutLog');

// POST /api/workouts/log - Log completed workout
router.post('/log', auth, async (req, res) => {
    try {
        const log = new WorkoutLog({
            userId: req.userId,
            ...req.body,
        });
        await log.save();
        res.status(201).json(log);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// GET /api/workouts/logs - Get workout history
router.get('/logs', auth, async (req, res) => {
    try {
        const { days = 30 } = req.query;
        const fromDate = new Date();
        fromDate.setDate(fromDate.getDate() - parseInt(days));

        const logs = await WorkoutLog.find({
            userId: req.userId,
            date: { $gte: fromDate },
        }).sort({ date: -1 });

        res.json(logs);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router;
