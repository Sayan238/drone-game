const mongoose = require('mongoose');

const progressSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    date: { type: Date, default: Date.now },
    weight: { type: Number },
    caloriesConsumed: { type: Number, default: 0 },
    proteinConsumed: { type: Number, default: 0 },
    waterGlasses: { type: Number, default: 0 },
    sleepHours: { type: Number, default: 0 },
    steps: { type: Number, default: 0 },
}, { timestamps: true });

// Compound index for efficient user+date queries
progressSchema.index({ userId: 1, date: -1 });

module.exports = mongoose.model('Progress', progressSchema);
