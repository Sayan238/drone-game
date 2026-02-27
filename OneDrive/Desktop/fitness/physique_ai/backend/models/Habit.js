const mongoose = require('mongoose');

const habitSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    date: { type: Date, default: Date.now },
    habits: [{
        name: { type: String, required: true },
        target: { type: Number, required: true },
        achieved: { type: Number, default: 0 },
        unit: { type: String },
        completed: { type: Boolean, default: false },
    }],
}, { timestamps: true });

habitSchema.index({ userId: 1, date: -1 });

module.exports = mongoose.model('Habit', habitSchema);
