class ProfileEntity {
  final String name;
  final int age;
  final double heightCm;
  final double weightKg;
  final bool isMale;
  final String goal;         // 'muscle_gain', 'fat_loss', 'six_pack', 'maintenance'
  final String dietPreference; // 'veg', 'non_veg', 'egg'
  final String activityLevel;  // 'sedentary', 'light', 'moderate', 'active', 'extra'

  // Computed values
  final double? bmi;
  final String? bmiCategory;
  final double? bmr;
  final double? tdee;
  final double? calorieTarget;
  final double? protein;
  final double? fat;
  final double? carbs;
  final double? waterLiters;

  const ProfileEntity({
    required this.name,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    this.isMale = true,
    required this.goal,
    required this.dietPreference,
    required this.activityLevel,
    this.bmi,
    this.bmiCategory,
    this.bmr,
    this.tdee,
    this.calorieTarget,
    this.protein,
    this.fat,
    this.carbs,
    this.waterLiters,
  });

  ProfileEntity copyWith({
    String? name,
    int? age,
    double? heightCm,
    double? weightKg,
    bool? isMale,
    String? goal,
    String? dietPreference,
    String? activityLevel,
    double? bmi,
    String? bmiCategory,
    double? bmr,
    double? tdee,
    double? calorieTarget,
    double? protein,
    double? fat,
    double? carbs,
    double? waterLiters,
  }) {
    return ProfileEntity(
      name: name ?? this.name,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      isMale: isMale ?? this.isMale,
      goal: goal ?? this.goal,
      dietPreference: dietPreference ?? this.dietPreference,
      activityLevel: activityLevel ?? this.activityLevel,
      bmi: bmi ?? this.bmi,
      bmiCategory: bmiCategory ?? this.bmiCategory,
      bmr: bmr ?? this.bmr,
      tdee: tdee ?? this.tdee,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbs: carbs ?? this.carbs,
      waterLiters: waterLiters ?? this.waterLiters,
    );
  }
}
