const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    firebaseUid: { type: String, unique: true, sparse: true },
    email: { type: String, required: true, unique: true },
    name: { type: String, required: true },
    age: { type: Number },
    height: { type: Number },       // cm
    weight: { type: Number },       // kg
    gender: { type: String, enum: ['male', 'female'], default: 'male' },
    goal: { type: String, enum: ['muscle_gain', 'fat_loss', 'six_pack', 'maintenance'] },
    dietPreference: { type: String, enum: ['veg', 'non_veg', 'egg'], default: 'non_veg' },
    activityLevel: { type: String, enum: ['sedentary', 'light', 'moderate', 'active', 'extra'] },
    bmi: { type: Number },
    tdee: { type: Number },
    calorieTarget: { type: Number },
    proteinTarget: { type: Number },
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);
