# PhysiqueAI 🏋️‍♂️

> Your Personal AI Fitness Coach — Built with Flutter + Node.js

PhysiqueAI is a production-ready, cross-platform mobile fitness application that provides personalized workout plans, Indian diet recommendations, habit tracking, and progress analytics — all powered by intelligent algorithms.

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🧠 **AI Fitness Calculator** | BMI, BMR, TDEE, Calorie Target, Protein/Carbs/Fat breakdown |
| 💪 **Workout Generator** | Push/Pull/Legs, Six-Pack Program, Fat Loss HIIT, Beginner Split |
| 🥗 **Indian Diet Plans** | Personalized Veg / Non-Veg / Eggetarian meal plans with macros |
| 📊 **Progress Dashboard** | Weight trend charts, calorie tracking with fl_chart |
| ✅ **Habit Tracker** | Water, Sleep, Steps, Workout, Meditation with weekly overview |
| 🎯 **Goal-Based Plans** | Muscle Gain, Fat Loss, Six Pack, Maintenance |
| 🌙 **Premium Dark UI** | Glassmorphism, neon accents, smooth animations |
| 🔐 **Auth Ready** | Firebase Auth structure (Email + Google sign-in) |

## 🏗️ Architecture

```
Clean Architecture with Feature-Based Modules
├── core/          → Theme, constants, utilities, widgets, router
├── features/      → Each feature has data/ domain/ presentation/
├── navigation/    → Bottom navigation shell
└── backend/       → Node.js + Express + MongoDB API
```

**State Management**: Flutter Riverpod (StateNotifier pattern)  
**Database**: Hive (local) + MongoDB (remote)  
**Charts**: fl_chart  
**Routing**: GoRouter

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK
- Android Studio / VS Code
- Node.js (18+) for backend

### Run the Flutter App
```bash
cd physique_ai
flutter pub get
flutter run
```

### Run the Backend (optional)
```bash
cd physique_ai/backend
cp .env.example .env    # Edit with your MongoDB URI
npm install
npm run dev
```

## 🔥 Firebase Setup (Optional)

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable Email/Password and Google Sign-In in Authentication
3. Download `google-services.json` → place in `android/app/`
4. Download `GoogleService-Info.plist` → place in `ios/Runner/`
5. Add `firebase_core` and `firebase_auth` to pubspec.yaml

> The app works fully offline without Firebase. The auth module uses a local mock.

## 📱 Screens

1. **Splash** → Animated logo with glow effect
2. **Onboarding** → 3-page intro with page indicators
3. **Login / Signup** → Glassmorphism forms with validation
4. **Profile Setup** → Gender, age, height, weight, goal, diet, activity
5. **Fitness Results** → BMI gauge, calorie target, macro breakdown
6. **Dashboard** → Quick stats, weight chart, calorie chart, motivation
7. **Workouts** → Goal-based routine list → exercise detail
8. **Diet Plan** → Per-meal Indian food with calories + macros
9. **Habits** → Daily tracker with progress ring + weekly chart
10. **Profile** → View/edit user data

## 🌐 Backend API

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Register user |
| POST | `/api/auth/login` | Login user |
| GET | `/api/profile` | Get profile |
| PUT | `/api/profile` | Update profile |
| POST | `/api/progress` | Log daily progress |
| GET | `/api/progress` | Get progress history |
| POST | `/api/habits` | Log daily habits |
| GET | `/api/habits` | Get habit history |
| POST | `/api/workouts/log` | Log workout |
| GET | `/api/workouts/logs` | Get workout history |

## 📦 Deployment

### Mobile
```bash
# Android
flutter build appbundle

# iOS (requires Mac)
flutter build ipa
```

### Backend
- **Railway / Render**: Push `backend/` folder, set env variables
- **MongoDB Atlas**: Free tier for development, M10+ for production
- **Firebase**: Enable auth providers in console

## 📈 Scalability

- **Clean Architecture** → Easy to add new features as separate modules
- **Repository Pattern** → Swap local storage ↔ remote API seamlessly
- **Riverpod DI** → Testable, decoupled state management
- **Stateless Backend** → Horizontally scalable Express API
- **MongoDB Atlas** → Auto-scaling with tier upgrades
- **Feature Flags** → Add Firebase Remote Config for gradual rollouts

## 📄 License

MIT License — Built with ❤️ for the fitness community.
