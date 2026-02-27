import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/profile_entity.dart';
import '../../../../core/utils/fitness_calculator.dart';

class ProfileState {
  final ProfileEntity? profile;
  final bool isLoading;
  final String? error;

  const ProfileState({this.profile, this.isLoading = false, this.error});

  ProfileState copyWith({
    ProfileEntity? profile,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final Box _profileBox = Hive.box('user_profile');

  ProfileNotifier() : super(const ProfileState()) {
    _loadProfile();
  }

  void _loadProfile() {
    final data = _profileBox.get('profile');
    if (data != null) {
      final json = jsonDecode(data);
      final profile = ProfileEntity(
        name: json['name'] ?? '',
        age: json['age'] ?? 20,
        heightCm: (json['heightCm'] ?? 170).toDouble(),
        weightKg: (json['weightKg'] ?? 70).toDouble(),
        isMale: json['isMale'] ?? true,
        goal: json['goal'] ?? 'muscle_gain',
        dietPreference: json['dietPreference'] ?? 'non_veg',
        activityLevel: json['activityLevel'] ?? 'moderate',
        bmi: json['bmi']?.toDouble(),
        bmiCategory: json['bmiCategory'],
        bmr: json['bmr']?.toDouble(),
        tdee: json['tdee']?.toDouble(),
        calorieTarget: json['calorieTarget']?.toDouble(),
        protein: json['protein']?.toDouble(),
        fat: json['fat']?.toDouble(),
        carbs: json['carbs']?.toDouble(),
        waterLiters: json['waterLiters']?.toDouble(),
      );
      state = state.copyWith(profile: profile);
    }
  }

  Future<void> saveProfile({
    required String name,
    required int age,
    required double heightCm,
    required double weightKg,
    required bool isMale,
    required String goal,
    required String dietPreference,
    required String activityLevel,
  }) async {
    state = state.copyWith(isLoading: true);

    // Calculate fitness data
    final results = FitnessCalculator.calculateAll(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      isMale: isMale,
      activityLevel: activityLevel,
      goal: goal,
    );

    final profile = ProfileEntity(
      name: name,
      age: age,
      heightCm: heightCm,
      weightKg: weightKg,
      isMale: isMale,
      goal: goal,
      dietPreference: dietPreference,
      activityLevel: activityLevel,
      bmi: results['bmi'],
      bmiCategory: results['bmiCategory'],
      bmr: results['bmr'],
      tdee: results['tdee'],
      calorieTarget: results['calorieTarget'],
      protein: results['protein'],
      fat: results['fat'],
      carbs: results['carbs'],
      waterLiters: results['waterLiters'],
    );

    // Save to Hive
    final json = {
      'name': name,
      'age': age,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'isMale': isMale,
      'goal': goal,
      'dietPreference': dietPreference,
      'activityLevel': activityLevel,
      'bmi': results['bmi'],
      'bmiCategory': results['bmiCategory'],
      'bmr': results['bmr'],
      'tdee': results['tdee'],
      'calorieTarget': results['calorieTarget'],
      'protein': results['protein'],
      'fat': results['fat'],
      'carbs': results['carbs'],
      'waterLiters': results['waterLiters'],
    };

    await _profileBox.put('profile', jsonEncode(json));
    state = state.copyWith(profile: profile, isLoading: false);
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier();
});
