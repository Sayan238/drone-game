class FitnessCalculator {
  FitnessCalculator._();

  /// Calculate BMI: weight(kg) / height(m)²
  static double calculateBMI(double weightKg, double heightCm) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  /// BMI classification
  static String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }

  /// Calculate BMR using Mifflin-St Jeor equation
  /// isMale: true for male, false for female
  static double calculateBMR(
      double weightKg, double heightCm, int age, bool isMale) {
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    return isMale ? base + 5 : base - 161;
  }

  /// Activity multiplier
  static double getActivityMultiplier(String activityLevel) {
    switch (activityLevel.toLowerCase()) {
      case 'sedentary':
        return 1.2;
      case 'lightly active':
      case 'light':
        return 1.375;
      case 'moderately active':
      case 'moderate':
        return 1.55;
      case 'very active':
      case 'active':
        return 1.725;
      case 'extra active':
      case 'extra':
        return 1.9;
      default:
        return 1.55;
    }
  }

  /// Calculate TDEE: BMR × activity multiplier
  static double calculateTDEE(double bmr, String activityLevel) {
    return bmr * getActivityMultiplier(activityLevel);
  }

  /// Calculate calorie target based on goal
  static double calculateCalorieTarget(double tdee, String goal) {
    switch (goal.toLowerCase()) {
      case 'muscle gain':
      case 'muscle_gain':
        return tdee + 400; // Caloric surplus
      case 'fat loss':
      case 'fat_loss':
        return tdee - 500; // Caloric deficit
      case 'six pack':
      case 'six_pack':
        return tdee - 400; // Moderate deficit
      case 'maintenance':
        return tdee;
      default:
        return tdee;
    }
  }

  /// Calculate protein target (g/day) based on weight and goal
  static double calculateProtein(double weightKg, String goal) {
    switch (goal.toLowerCase()) {
      case 'muscle gain':
      case 'muscle_gain':
        return weightKg * 2.2; // 2.2g per kg
      case 'fat loss':
      case 'fat_loss':
        return weightKg * 2.0; // 2.0g per kg (preserve muscle)
      case 'six pack':
      case 'six_pack':
        return weightKg * 2.0;
      case 'maintenance':
        return weightKg * 1.6;
      default:
        return weightKg * 1.8;
    }
  }

  /// Calculate fat target (g/day) - 25% of total calories
  static double calculateFat(double calorieTarget) {
    return (calorieTarget * 0.25) / 9; // 9 cal per gram of fat
  }

  /// Calculate carbs (g/day) - remaining calories after protein and fat
  static double calculateCarbs(
      double calorieTarget, double proteinG, double fatG) {
    final proteinCals = proteinG * 4;
    final fatCals = fatG * 9;
    final carbCals = calorieTarget - proteinCals - fatCals;
    return carbCals / 4; // 4 cal per gram of carb
  }

  /// Calculate water intake (liters) based on weight
  static double calculateWaterIntake(double weightKg) {
    return weightKg * 0.033; // ~33ml per kg
  }

  /// Get all fitness results as a map
  static Map<String, dynamic> calculateAll({
    required double weightKg,
    required double heightCm,
    required int age,
    required bool isMale,
    required String activityLevel,
    required String goal,
  }) {
    final bmi = calculateBMI(weightKg, heightCm);
    final bmr = calculateBMR(weightKg, heightCm, age, isMale);
    final tdee = calculateTDEE(bmr, activityLevel);
    final calorieTarget = calculateCalorieTarget(tdee, goal);
    final protein = calculateProtein(weightKg, goal);
    final fat = calculateFat(calorieTarget);
    final carbs = calculateCarbs(calorieTarget, protein, fat);
    final water = calculateWaterIntake(weightKg);

    return {
      'bmi': bmi,
      'bmiCategory': getBMICategory(bmi),
      'bmr': bmr,
      'tdee': tdee,
      'calorieTarget': calorieTarget,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'waterLiters': water,
    };
  }
}
