class WorkoutData {
  static List<Map<String, dynamic>> getWorkouts(String goal) {
    switch (goal.toLowerCase()) {
      case 'muscle_gain':
      case 'muscle gain':
        return pushPullLegs;
      case 'fat_loss':
      case 'fat loss':
        return fatLossRoutine;
      case 'six_pack':
      case 'six pack':
        return sixPackProgram;
      default:
        return beginnerSplit;
    }
  }

  static const List<Map<String, dynamic>> pushPullLegs = [
    {
      'day': 'Day 1',
      'name': 'Push Day',
      'type': 'push',
      'icon': '🏋️',
      'color': 0xFF00D4FF,
      'exercises': [
        {'name': 'Barbell Bench Press', 'sets': 4, 'reps': '8-10', 'rest': '90s', 'muscle': 'Chest'},
        {'name': 'Incline Dumbbell Press', 'sets': 3, 'reps': '10-12', 'rest': '75s', 'muscle': 'Upper Chest'},
        {'name': 'Overhead Press', 'sets': 4, 'reps': '8-10', 'rest': '90s', 'muscle': 'Shoulders'},
        {'name': 'Lateral Raises', 'sets': 3, 'reps': '12-15', 'rest': '60s', 'muscle': 'Side Delts'},
        {'name': 'Tricep Pushdowns', 'sets': 3, 'reps': '12-15', 'rest': '60s', 'muscle': 'Triceps'},
        {'name': 'Overhead Tricep Extension', 'sets': 3, 'reps': '10-12', 'rest': '60s', 'muscle': 'Triceps'},
        {'name': 'Chest Dips', 'sets': 3, 'reps': '8-12', 'rest': '75s', 'muscle': 'Chest/Triceps'},
      ],
    },
    {
      'day': 'Day 2',
      'name': 'Pull Day',
      'type': 'pull',
      'icon': '💪',
      'color': 0xFF39FF14,
      'exercises': [
        {'name': 'Deadlifts', 'sets': 4, 'reps': '6-8', 'rest': '120s', 'muscle': 'Back/Hamstrings'},
        {'name': 'Pull-ups / Lat Pulldown', 'sets': 4, 'reps': '8-10', 'rest': '90s', 'muscle': 'Lats'},
        {'name': 'Barbell Rows', 'sets': 4, 'reps': '8-10', 'rest': '90s', 'muscle': 'Upper Back'},
        {'name': 'Face Pulls', 'sets': 3, 'reps': '15-20', 'rest': '60s', 'muscle': 'Rear Delts'},
        {'name': 'Dumbbell Curls', 'sets': 3, 'reps': '10-12', 'rest': '60s', 'muscle': 'Biceps'},
        {'name': 'Hammer Curls', 'sets': 3, 'reps': '10-12', 'rest': '60s', 'muscle': 'Biceps'},
      ],
    },
    {
      'day': 'Day 3',
      'name': 'Leg Day',
      'type': 'legs',
      'icon': '🦵',
      'color': 0xFFBB86FC,
      'exercises': [
        {'name': 'Barbell Squats', 'sets': 4, 'reps': '8-10', 'rest': '120s', 'muscle': 'Quads'},
        {'name': 'Romanian Deadlifts', 'sets': 4, 'reps': '8-10', 'rest': '90s', 'muscle': 'Hamstrings'},
        {'name': 'Leg Press', 'sets': 3, 'reps': '10-12', 'rest': '90s', 'muscle': 'Quads'},
        {'name': 'Leg Curls', 'sets': 3, 'reps': '12-15', 'rest': '60s', 'muscle': 'Hamstrings'},
        {'name': 'Calf Raises', 'sets': 4, 'reps': '15-20', 'rest': '60s', 'muscle': 'Calves'},
        {'name': 'Walking Lunges', 'sets': 3, 'reps': '12 each', 'rest': '75s', 'muscle': 'Quads/Glutes'},
      ],
    },
    {
      'day': 'Day 4',
      'name': 'Push Day',
      'type': 'push2',
      'icon': '🏋️',
      'color': 0xFF00D4FF,
      'exercises': [
        {'name': 'Dumbbell Bench Press', 'sets': 4, 'reps': '10-12', 'rest': '75s', 'muscle': 'Chest'},
        {'name': 'Cable Flyes', 'sets': 3, 'reps': '12-15', 'rest': '60s', 'muscle': 'Chest'},
        {'name': 'Arnold Press', 'sets': 3, 'reps': '10-12', 'rest': '75s', 'muscle': 'Shoulders'},
        {'name': 'Front Raises', 'sets': 3, 'reps': '12-15', 'rest': '60s', 'muscle': 'Front Delts'},
        {'name': 'Close-Grip Bench Press', 'sets': 3, 'reps': '10-12', 'rest': '75s', 'muscle': 'Triceps'},
        {'name': 'Skull Crushers', 'sets': 3, 'reps': '10-12', 'rest': '60s', 'muscle': 'Triceps'},
      ],
    },
    {
      'day': 'Day 5',
      'name': 'Pull Day',
      'type': 'pull2',
      'icon': '💪',
      'color': 0xFF39FF14,
      'exercises': [
        {'name': 'T-Bar Rows', 'sets': 4, 'reps': '8-10', 'rest': '90s', 'muscle': 'Upper Back'},
        {'name': 'Seated Cable Row', 'sets': 3, 'reps': '10-12', 'rest': '75s', 'muscle': 'Mid Back'},
        {'name': 'Chin-ups', 'sets': 3, 'reps': '8-10', 'rest': '90s', 'muscle': 'Lats/Biceps'},
        {'name': 'Reverse Flyes', 'sets': 3, 'reps': '15', 'rest': '60s', 'muscle': 'Rear Delts'},
        {'name': 'Preacher Curls', 'sets': 3, 'reps': '10-12', 'rest': '60s', 'muscle': 'Biceps'},
        {'name': 'Concentration Curls', 'sets': 3, 'reps': '12', 'rest': '60s', 'muscle': 'Biceps'},
      ],
    },
    {
      'day': 'Day 6',
      'name': 'Leg Day',
      'type': 'legs2',
      'icon': '🦵',
      'color': 0xFFBB86FC,
      'exercises': [
        {'name': 'Front Squats', 'sets': 4, 'reps': '8-10', 'rest': '120s', 'muscle': 'Quads'},
        {'name': 'Bulgarian Split Squats', 'sets': 3, 'reps': '10 each', 'rest': '75s', 'muscle': 'Quads/Glutes'},
        {'name': 'Leg Extensions', 'sets': 3, 'reps': '12-15', 'rest': '60s', 'muscle': 'Quads'},
        {'name': 'Glute Bridges', 'sets': 3, 'reps': '12-15', 'rest': '60s', 'muscle': 'Glutes'},
        {'name': 'Seated Calf Raises', 'sets': 4, 'reps': '15-20', 'rest': '60s', 'muscle': 'Calves'},
      ],
    },
  ];

  static const List<Map<String, dynamic>> sixPackProgram = [
    {
      'day': 'Day 1',
      'name': 'Upper Abs + HIIT',
      'type': 'upper_abs',
      'icon': '🔥',
      'color': 0xFFFF0080,
      'exercises': [
        {'name': 'Crunches', 'sets': 4, 'reps': '20', 'rest': '30s', 'muscle': 'Upper Abs'},
        {'name': 'Cable Crunches', 'sets': 3, 'reps': '15', 'rest': '45s', 'muscle': 'Upper Abs'},
        {'name': 'Decline Sit-ups', 'sets': 3, 'reps': '15', 'rest': '45s', 'muscle': 'Upper Abs'},
        {'name': 'Mountain Climbers', 'sets': 3, 'reps': '30s', 'rest': '30s', 'muscle': 'Core/Cardio'},
        {'name': 'Burpees', 'sets': 3, 'reps': '10', 'rest': '45s', 'muscle': 'Full Body'},
        {'name': 'Jump Rope', 'sets': 3, 'reps': '60s', 'rest': '30s', 'muscle': 'Cardio'},
      ],
    },
    {
      'day': 'Day 2',
      'name': 'Lower Abs + Strength',
      'type': 'lower_abs',
      'icon': '💥',
      'color': 0xFFFFD700,
      'exercises': [
        {'name': 'Hanging Leg Raises', 'sets': 4, 'reps': '12-15', 'rest': '45s', 'muscle': 'Lower Abs'},
        {'name': 'Reverse Crunches', 'sets': 3, 'reps': '15', 'rest': '30s', 'muscle': 'Lower Abs'},
        {'name': 'Flutter Kicks', 'sets': 3, 'reps': '30s', 'rest': '30s', 'muscle': 'Lower Abs'},
        {'name': 'Squats', 'sets': 4, 'reps': '8-10', 'rest': '90s', 'muscle': 'Quads'},
        {'name': 'Bench Press', 'sets': 4, 'reps': '8-10', 'rest': '90s', 'muscle': 'Chest'},
      ],
    },
    {
      'day': 'Day 3',
      'name': 'Obliques + Cardio',
      'type': 'obliques',
      'icon': '🌪️',
      'color': 0xFF00D4FF,
      'exercises': [
        {'name': 'Russian Twists', 'sets': 4, 'reps': '20', 'rest': '30s', 'muscle': 'Obliques'},
        {'name': 'Side Plank', 'sets': 3, 'reps': '30s each', 'rest': '30s', 'muscle': 'Obliques'},
        {'name': 'Bicycle Crunches', 'sets': 3, 'reps': '20', 'rest': '30s', 'muscle': 'Obliques'},
        {'name': 'Woodchoppers', 'sets': 3, 'reps': '12 each', 'rest': '45s', 'muscle': 'Obliques'},
        {'name': 'Treadmill Sprints', 'sets': 6, 'reps': '30s on/30s off', 'rest': '—', 'muscle': 'Cardio'},
      ],
    },
    {
      'day': 'Day 4',
      'name': 'Core Stability + Pull',
      'type': 'core_stability',
      'icon': '🧘',
      'color': 0xFF39FF14,
      'exercises': [
        {'name': 'Plank Hold', 'sets': 3, 'reps': '60s', 'rest': '30s', 'muscle': 'Core'},
        {'name': 'Ab Wheel Rollout', 'sets': 3, 'reps': '10-12', 'rest': '45s', 'muscle': 'Core'},
        {'name': 'Dead Bug', 'sets': 3, 'reps': '12 each', 'rest': '30s', 'muscle': 'Core'},
        {'name': 'Pull-ups', 'sets': 4, 'reps': '8-10', 'rest': '90s', 'muscle': 'Back'},
        {'name': 'Rows', 'sets': 3, 'reps': '10-12', 'rest': '75s', 'muscle': 'Back'},
      ],
    },
    {
      'day': 'Day 5',
      'name': 'Full Core Burn',
      'type': 'full_core',
      'icon': '🔱',
      'color': 0xFFBB86FC,
      'exercises': [
        {'name': 'V-Ups', 'sets': 4, 'reps': '15', 'rest': '30s', 'muscle': 'Full Core'},
        {'name': 'Dragon Flags', 'sets': 3, 'reps': '8-10', 'rest': '45s', 'muscle': 'Full Core'},
        {'name': 'Hanging Windshield Wipers', 'sets': 3, 'reps': '8 each', 'rest': '45s', 'muscle': 'Obliques'},
        {'name': 'Cable Woodchoppers', 'sets': 3, 'reps': '12 each', 'rest': '45s', 'muscle': 'Obliques'},
        {'name': 'Plank to Push-up', 'sets': 3, 'reps': '10', 'rest': '30s', 'muscle': 'Core/Arms'},
        {'name': 'Cardio Finisher (Bike)', 'sets': 1, 'reps': '15 min', 'rest': '—', 'muscle': 'Cardio'},
      ],
    },
  ];

  static const List<Map<String, dynamic>> fatLossRoutine = [
    {
      'day': 'Day 1',
      'name': 'Full Body Strength',
      'type': 'full_body_1',
      'icon': '💪',
      'color': 0xFFFF0080,
      'exercises': [
        {'name': 'Squats', 'sets': 4, 'reps': '10-12', 'rest': '60s', 'muscle': 'Legs'},
        {'name': 'Bench Press', 'sets': 3, 'reps': '10-12', 'rest': '60s', 'muscle': 'Chest'},
        {'name': 'Bent Over Rows', 'sets': 3, 'reps': '10-12', 'rest': '60s', 'muscle': 'Back'},
        {'name': 'Shoulder Press', 'sets': 3, 'reps': '10-12', 'rest': '60s', 'muscle': 'Shoulders'},
        {'name': 'Plank', 'sets': 3, 'reps': '45s', 'rest': '30s', 'muscle': 'Core'},
        {'name': 'Jump Rope', 'sets': 5, 'reps': '60s', 'rest': '30s', 'muscle': 'Cardio'},
      ],
    },
    {
      'day': 'Day 2',
      'name': 'HIIT Cardio',
      'type': 'hiit',
      'icon': '🔥',
      'color': 0xFFFFD700,
      'exercises': [
        {'name': 'Burpees', 'sets': 4, 'reps': '12', 'rest': '30s', 'muscle': 'Full Body'},
        {'name': 'Box Jumps', 'sets': 4, 'reps': '10', 'rest': '30s', 'muscle': 'Legs'},
        {'name': 'Battle Ropes', 'sets': 4, 'reps': '30s', 'rest': '30s', 'muscle': 'Arms/Core'},
        {'name': 'Kettlebell Swings', 'sets': 4, 'reps': '15', 'rest': '30s', 'muscle': 'Full Body'},
        {'name': 'Mountain Climbers', 'sets': 4, 'reps': '30s', 'rest': '30s', 'muscle': 'Core/Cardio'},
        {'name': 'Sprint Intervals', 'sets': 6, 'reps': '30s sprint', 'rest': '60s walk', 'muscle': 'Cardio'},
      ],
    },
    {
      'day': 'Day 3',
      'name': 'Full Body Strength',
      'type': 'full_body_2',
      'icon': '🏋️',
      'color': 0xFF39FF14,
      'exercises': [
        {'name': 'Deadlifts', 'sets': 4, 'reps': '8-10', 'rest': '90s', 'muscle': 'Back/Legs'},
        {'name': 'Pull-ups', 'sets': 3, 'reps': '8-10', 'rest': '60s', 'muscle': 'Back'},
        {'name': 'Lunges', 'sets': 3, 'reps': '12 each', 'rest': '60s', 'muscle': 'Legs'},
        {'name': 'Push-ups', 'sets': 3, 'reps': '15-20', 'rest': '45s', 'muscle': 'Chest'},
        {'name': 'Russian Twists', 'sets': 3, 'reps': '20', 'rest': '30s', 'muscle': 'Core'},
        {'name': 'Stairmaster', 'sets': 1, 'reps': '15 min', 'rest': '—', 'muscle': 'Cardio'},
      ],
    },
  ];

  static const List<Map<String, dynamic>> beginnerSplit = [
    {
      'day': 'Day 1',
      'name': 'Upper Body',
      'type': 'upper',
      'icon': '💪',
      'color': 0xFF00D4FF,
      'exercises': [
        {'name': 'Push-ups', 'sets': 3, 'reps': '10-15', 'rest': '60s', 'muscle': 'Chest'},
        {'name': 'Dumbbell Rows', 'sets': 3, 'reps': '10-12', 'rest': '60s', 'muscle': 'Back'},
        {'name': 'Shoulder Press', 'sets': 3, 'reps': '10-12', 'rest': '60s', 'muscle': 'Shoulders'},
        {'name': 'Bicep Curls', 'sets': 2, 'reps': '12', 'rest': '45s', 'muscle': 'Biceps'},
        {'name': 'Tricep Dips', 'sets': 2, 'reps': '10', 'rest': '45s', 'muscle': 'Triceps'},
      ],
    },
    {
      'day': 'Day 2',
      'name': 'Lower Body',
      'type': 'lower',
      'icon': '🦵',
      'color': 0xFFBB86FC,
      'exercises': [
        {'name': 'Bodyweight Squats', 'sets': 3, 'reps': '15', 'rest': '60s', 'muscle': 'Quads'},
        {'name': 'Lunges', 'sets': 3, 'reps': '12 each', 'rest': '60s', 'muscle': 'Legs'},
        {'name': 'Glute Bridges', 'sets': 3, 'reps': '15', 'rest': '45s', 'muscle': 'Glutes'},
        {'name': 'Calf Raises', 'sets': 3, 'reps': '20', 'rest': '45s', 'muscle': 'Calves'},
        {'name': 'Plank', 'sets': 3, 'reps': '30s', 'rest': '30s', 'muscle': 'Core'},
      ],
    },
    {
      'day': 'Day 3',
      'name': 'Upper Body',
      'type': 'upper2',
      'icon': '💪',
      'color': 0xFF39FF14,
      'exercises': [
        {'name': 'Incline Push-ups', 'sets': 3, 'reps': '12', 'rest': '60s', 'muscle': 'Chest'},
        {'name': 'Lat Pulldown', 'sets': 3, 'reps': '10-12', 'rest': '60s', 'muscle': 'Back'},
        {'name': 'Lateral Raises', 'sets': 3, 'reps': '12', 'rest': '45s', 'muscle': 'Shoulders'},
        {'name': 'Hammer Curls', 'sets': 2, 'reps': '12', 'rest': '45s', 'muscle': 'Biceps'},
        {'name': 'Overhead Extensions', 'sets': 2, 'reps': '12', 'rest': '45s', 'muscle': 'Triceps'},
      ],
    },
    {
      'day': 'Day 4',
      'name': 'Lower Body',
      'type': 'lower2',
      'icon': '🦵',
      'color': 0xFFFF0080,
      'exercises': [
        {'name': 'Goblet Squats', 'sets': 3, 'reps': '12', 'rest': '60s', 'muscle': 'Quads'},
        {'name': 'Step-ups', 'sets': 3, 'reps': '10 each', 'rest': '60s', 'muscle': 'Legs'},
        {'name': 'Romanian Deadlifts', 'sets': 3, 'reps': '10', 'rest': '60s', 'muscle': 'Hamstrings'},
        {'name': 'Leg Raises', 'sets': 3, 'reps': '12', 'rest': '45s', 'muscle': 'Core'},
        {'name': 'Wall Sit', 'sets': 3, 'reps': '30s', 'rest': '45s', 'muscle': 'Quads'},
      ],
    },
  ];
}
