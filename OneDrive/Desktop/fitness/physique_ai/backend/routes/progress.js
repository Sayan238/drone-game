const express = require('express');
const router = express.Router();
const auth = require('../middleware/authMiddleware');
const Progress = require('../models/Progress');

// POST /api/progress - Log daily progress
router.post('/', auth, async (req, res) => {
    try {
        const progress = new Progress({
            userId: req.userId,
            ...req.body,
        });
        await progress.save();
        res.status(201).json(progress);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// GET /api/progress - Get progress history
router.get('/', auth, async (req, res) => {
    try {
        const { days = 30 } = req.query;
        const fromDate = new Date();
        fromDate.setDate(fromDate.getDate() - parseInt(days));

        const progress = await Progress.find({
            userId: req.userId,
            date: { $gte: fromDate },
        }).sort({ date: -1 });

        res.json(progress);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router;
