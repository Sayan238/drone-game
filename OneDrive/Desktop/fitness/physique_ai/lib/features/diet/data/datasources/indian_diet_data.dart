class IndianDietData {
  static Map<String, List<Map<String, dynamic>>> getDietPlan({
    required double calorieTarget,
    required String dietPreference,
    required String goal,
  }) {
    if (dietPreference == 'veg') return _vegDiet(calorieTarget, goal);
    if (dietPreference == 'egg') return _eggDiet(calorieTarget, goal);
    return _nonVegDiet(calorieTarget, goal);
  }

  static Map<String, List<Map<String, dynamic>>> _nonVegDiet(
      double cal, String goal) {
    final factor = cal / 2200;
    return {
      'Breakfast (8:00 AM)': [
        {'name': '4 Egg White Omelette + 1 Whole Egg', 'calories': (280 * factor).round(), 'protein': 28, 'carbs': 2, 'fat': 10},
        {'name': 'Brown Bread (2 slices)', 'calories': (140 * factor).round(), 'protein': 6, 'carbs': 26, 'fat': 2},
        {'name': 'Banana + Almonds (5 pcs)', 'calories': (120 * factor).round(), 'protein': 4, 'carbs': 22, 'fat': 4},
      ],
      'Mid-Morning (10:30 AM)': [
        {'name': 'Greek Yogurt / Curd (200g)', 'calories': (120 * factor).round(), 'protein': 12, 'carbs': 8, 'fat': 5},
        {'name': 'Mixed Nuts (15g)', 'calories': (90 * factor).round(), 'protein': 3, 'carbs': 4, 'fat': 8},
      ],
      'Lunch (1:00 PM)': [
        {'name': 'Chicken Breast (150g) / Fish', 'calories': (250 * factor).round(), 'protein': 40, 'carbs': 0, 'fat': 8},
        {'name': 'Brown Rice (1 cup cooked)', 'calories': (180 * factor).round(), 'protein': 4, 'carbs': 38, 'fat': 1},
        {'name': 'Dal (1 bowl)', 'calories': (150 * factor).round(), 'protein': 10, 'carbs': 24, 'fat': 3},
        {'name': 'Mixed Sabzi + Salad', 'calories': (80 * factor).round(), 'protein': 3, 'carbs': 12, 'fat': 3},
      ],
      'Pre-Workout (4:30 PM)': [
        {'name': 'Banana + Peanut Butter (1 tbsp)', 'calories': (200 * factor).round(), 'protein': 6, 'carbs': 30, 'fat': 8},
        {'name': 'Black Coffee', 'calories': 5, 'protein': 0, 'carbs': 0, 'fat': 0},
      ],
      'Post-Workout (6:30 PM)': [
        {'name': 'Whey Protein Shake (1 scoop)', 'calories': (120 * factor).round(), 'protein': 24, 'carbs': 4, 'fat': 2},
        {'name': 'Oats (40g) with Milk', 'calories': (180 * factor).round(), 'protein': 8, 'carbs': 32, 'fat': 4},
      ],
      'Dinner (8:30 PM)': [
        {'name': 'Grilled Chicken/Fish (120g)', 'calories': (200 * factor).round(), 'protein': 32, 'carbs': 0, 'fat': 7},
        {'name': 'Roti (2 pcs)', 'calories': (160 * factor).round(), 'protein': 6, 'carbs': 30, 'fat': 3},
        {'name': 'Paneer Sabzi / Dal (1 bowl)', 'calories': (150 * factor).round(), 'protein': 10, 'carbs': 12, 'fat': 8},
        {'name': 'Cucumber Raita (1 bowl)', 'calories': (60 * factor).round(), 'protein': 4, 'carbs': 6, 'fat': 2},
      ],
    };
  }

  static Map<String, List<Map<String, dynamic>>> _vegDiet(
      double cal, String goal) {
    final factor = cal / 2200;
    return {
      'Breakfast (8:00 AM)': [
        {'name': 'Moong Dal Chilla (2 pcs)', 'calories': (220 * factor).round(), 'protein': 16, 'carbs': 28, 'fat': 4},
        {'name': 'Curd (1 bowl)', 'calories': (80 * factor).round(), 'protein': 6, 'carbs': 6, 'fat': 4},
        {'name': 'Banana + Mixed Seeds', 'calories': (140 * factor).round(), 'protein': 4, 'carbs': 26, 'fat': 4},
      ],
      'Mid-Morning (10:30 AM)': [
        {'name': 'Paneer Cubes (50g) + Sprouts', 'calories': (180 * factor).round(), 'protein': 16, 'carbs': 10, 'fat': 10},
        {'name': 'Green Tea + Almonds (8 pcs)', 'calories': (80 * factor).round(), 'protein': 3, 'carbs': 3, 'fat': 6},
      ],
      'Lunch (1:00 PM)': [
        {'name': 'Rajma / Chole (1 cup)', 'calories': (220 * factor).round(), 'protein': 14, 'carbs': 36, 'fat': 4},
        {'name': 'Brown Rice (1 cup cooked)', 'calories': (180 * factor).round(), 'protein': 4, 'carbs': 38, 'fat': 1},
        {'name': 'Palak Paneer (1 bowl)', 'calories': (200 * factor).round(), 'protein': 14, 'carbs': 10, 'fat': 14},
        {'name': 'Mixed Salad + Raita', 'calories': (80 * factor).round(), 'protein': 4, 'carbs': 10, 'fat': 3},
      ],
      'Pre-Workout (4:30 PM)': [
        {'name': 'Banana + Peanut Butter', 'calories': (200 * factor).round(), 'protein': 6, 'carbs': 30, 'fat': 8},
        {'name': 'Dates (3 pcs)', 'calories': (70 * factor).round(), 'protein': 1, 'carbs': 18, 'fat': 0},
      ],
      'Post-Workout (6:30 PM)': [
        {'name': 'Soy Protein / Paneer Shake', 'calories': (150 * factor).round(), 'protein': 20, 'carbs': 10, 'fat': 4},
        {'name': 'Poha / Upma (1 bowl)', 'calories': (180 * factor).round(), 'protein': 6, 'carbs': 34, 'fat': 3},
      ],
      'Dinner (8:30 PM)': [
        {'name': 'Tofu / Paneer Tikka (100g)', 'calories': (200 * factor).round(), 'protein': 18, 'carbs': 6, 'fat': 12},
        {'name': 'Roti (2 pcs)', 'calories': (160 * factor).round(), 'protein': 6, 'carbs': 30, 'fat': 3},
        {'name': 'Mixed Dal (1 bowl)', 'calories': (150 * factor).round(), 'protein': 10, 'carbs': 24, 'fat': 3},
        {'name': 'Jeera Rice (small)', 'calories': (120 * factor).round(), 'protein': 3, 'carbs': 24, 'fat': 2},
      ],
    };
  }

  static Map<String, List<Map<String, dynamic>>> _eggDiet(
      double cal, String goal) {
    final factor = cal / 2200;
    return {
      'Breakfast (8:00 AM)': [
        {'name': '4 Boiled Eggs (2 whole + 2 whites)', 'calories': (240 * factor).round(), 'protein': 24, 'carbs': 2, 'fat': 12},
        {'name': 'Multigrain Toast (2 slices)', 'calories': (140 * factor).round(), 'protein': 6, 'carbs': 26, 'fat': 2},
        {'name': 'Banana + Walnuts', 'calories': (120 * factor).round(), 'protein': 4, 'carbs': 20, 'fat': 5},
      ],
      'Mid-Morning (10:30 AM)': [
        {'name': 'Paneer (50g) + Sprouts Salad', 'calories': (170 * factor).round(), 'protein': 16, 'carbs': 10, 'fat': 9},
        {'name': 'Buttermilk (1 glass)', 'calories': (40 * factor).round(), 'protein': 3, 'carbs': 4, 'fat': 1},
      ],
      'Lunch (1:00 PM)': [
        {'name': 'Egg Curry (3 eggs)', 'calories': (280 * factor).round(), 'protein': 22, 'carbs': 8, 'fat': 18},
        {'name': 'Brown Rice (1 cup)', 'calories': (180 * factor).round(), 'protein': 4, 'carbs': 38, 'fat': 1},
        {'name': 'Dal Fry (1 bowl)', 'calories': (150 * factor).round(), 'protein': 10, 'carbs': 24, 'fat': 3},
        {'name': 'Cucumber Salad', 'calories': (30 * factor).round(), 'protein': 1, 'carbs': 6, 'fat': 0},
      ],
      'Pre-Workout (4:30 PM)': [
        {'name': 'Egg White Omelette (3 whites)', 'calories': (60 * factor).round(), 'protein': 12, 'carbs': 0, 'fat': 0},
        {'name': 'Banana + Honey', 'calories': (130 * factor).round(), 'protein': 2, 'carbs': 32, 'fat': 0},
      ],
      'Post-Workout (6:30 PM)': [
        {'name': 'Protein Shake + Egg Whites', 'calories': (150 * factor).round(), 'protein': 30, 'carbs': 4, 'fat': 2},
        {'name': 'Oats with Milk', 'calories': (180 * factor).round(), 'protein': 8, 'carbs': 32, 'fat': 4},
      ],
      'Dinner (8:30 PM)': [
        {'name': 'Egg Bhurji (3 eggs)', 'calories': (240 * factor).round(), 'protein': 20, 'carbs': 4, 'fat': 16},
        {'name': 'Roti (2 pcs)', 'calories': (160 * factor).round(), 'protein': 6, 'carbs': 30, 'fat': 3},
        {'name': 'Paneer Sabzi', 'calories': (180 * factor).round(), 'protein': 12, 'carbs': 8, 'fat': 12},
        {'name': 'Raita', 'calories': (60 * factor).round(), 'protein': 4, 'carbs': 6, 'fat': 2},
      ],
    };
  }
}
