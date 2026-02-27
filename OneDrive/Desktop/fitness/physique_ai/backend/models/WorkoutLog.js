const mongoose = require('mongoose');

const workoutLogSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    date: { type: Date, default: Date.now },
    workoutType: { type: String, required: true },
    exercises: [{
        name: { type: String, required: true },
        sets: { type: Number },
        reps: { type: Number },
        weight: { type: Number },
    }],
    duration: { type: Number }, // minutes
    completed: { type: Boolean, default: false },
}, { timestamps: true });

workoutLogSchema.index({ userId: 1, date: -1 });

module.exports = mongoose.model('WorkoutLog', workoutLogSchema);
