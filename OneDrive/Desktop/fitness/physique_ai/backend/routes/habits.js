const express = require('express');
const router = express.Router();
const auth = require('../middleware/authMiddleware');
const Habit = require('../models/Habit');

// POST /api/habits - Log daily habits
router.post('/', auth, async (req, res) => {
    try {
        const habit = new Habit({
            userId: req.userId,
            ...req.body,
        });
        await habit.save();
        res.status(201).json(habit);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// GET /api/habits - Get habit history
router.get('/', auth, async (req, res) => {
    try {
        const { days = 7 } = req.query;
        const fromDate = new Date();
        fromDate.setDate(fromDate.getDate() - parseInt(days));

        const habits = await Habit.find({
            userId: req.userId,
            date: { $gte: fromDate },
        }).sort({ date: -1 });

        res.json(habits);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router;
