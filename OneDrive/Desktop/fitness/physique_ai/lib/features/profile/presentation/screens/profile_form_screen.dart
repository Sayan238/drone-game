import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/goal_selector.dart';

class ProfileFormScreen extends ConsumerStatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  ConsumerState<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends ConsumerState<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Fitness User');
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  bool _isMale = true;
  String _selectedGoal = 'muscle_gain';
  String _dietPreference = 'non_veg';
  String _activityLevel = 'moderate';

  final List<String> _dietOptions = ['veg', 'non_veg', 'egg'];
  final List<String> _activityOptions = [
    'sedentary',
    'light',
    'moderate',
    'active',
    'extra',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(profileProvider).profile;
      final authState = ref.read(authProvider);
      
      if (profile != null) {
        _nameController.text = profile.name;
        _ageController.text = profile.age.toString();
        _heightController.text = profile.heightCm.toInt().toString();
        _weightController.text = profile.weightKg.toInt().toString();
        setState(() {
          _isMale = profile.isMale;
          _selectedGoal = profile.goal;
          _dietPreference = profile.dietPreference;
          _activityLevel = profile.activityLevel;
        });
      } else if (authState.user != null) {
        _nameController.text = authState.user!.name;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  String _formatActivityLevel(String level) {
    switch (level) {
      case 'sedentary':
        return 'Sedentary (desk job)';
      case 'light':
        return 'Light (1-3 days/week)';
      case 'moderate':
        return 'Moderate (3-5 days/week)';
      case 'active':
        return 'Active (6-7 days/week)';
      case 'extra':
        return 'Extra Active (athlete)';
      default:
        return level;
    }
  }

  String _formatDiet(String diet) {
    switch (diet) {
      case 'veg':
        return '🥗 Vegetarian';
      case 'non_veg':
        return '🍗 Non-Vegetarian';
      case 'egg':
        return '🥚 Eggetarian';
      default:
        return diet;
    }
  }

  Future<void> _calculateAndSave() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(profileProvider.notifier).saveProfile(
          name: _nameController.text.trim(),
          age: int.parse(_ageController.text),
          heightCm: double.parse(_heightController.text),
          weightKg: double.parse(_weightController.text),
          isMale: _isMale,
          goal: _selectedGoal,
          dietPreference: _dietPreference,
          activityLevel: _activityLevel,
        );

    if (mounted) {
      context.go('/fitness-results');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Header
                FadeInDown(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.setupProfile,
                          style: AppTextStyles.heading1),
                      const SizedBox(height: 8),
                      Text(
                        'Tell us about yourself so we can create your perfect plan',
                        style: AppTextStyles.subtitle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Name Input
                FadeInUp(
                  delay: const Duration(milliseconds: 50),
                  child: TextFormField(
                    controller: _nameController,
                    validator: Validators.validateName,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline, color: AppColors.textMuted),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Gender selector
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gender', style: AppTextStyles.bodyBold),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _genderCard(
                              icon: Icons.male,
                              label: 'Male',
                              isSelected: _isMale,
                              onTap: () => setState(() => _isMale = true),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _genderCard(
                              icon: Icons.female,
                              label: 'Female',
                              isSelected: !_isMale,
                              onTap: () => setState(() => _isMale = false),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Age, Height, Weight
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          validator: Validators.validateAge,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Age',
                            suffixText: 'yrs',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          validator: Validators.validateHeight,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Height',
                            suffixText: 'cm',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          validator: Validators.validateWeight,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Weight',
                            suffixText: 'kg',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Goal selector
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.selectGoal, style: AppTextStyles.bodyBold),
                      const SizedBox(height: 12),
                      GoalSelector(
                        selectedGoal: _selectedGoal,
                        onGoalSelected: (goal) {
                          setState(() => _selectedGoal = goal);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Diet preference
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.dietPreference,
                          style: AppTextStyles.bodyBold),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: _dietOptions.map((diet) {
                          final isSelected = _dietPreference == diet;
                          return ChoiceChip(
                            label: Text(_formatDiet(diet)),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() => _dietPreference = diet);
                            },
                            backgroundColor: AppColors.surfaceLight,
                            selectedColor:
                                AppColors.neonBlue.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.neonBlue
                                  : AppColors.textSecondary,
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.neonBlue
                                  : AppColors.glassBorder,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Activity level
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.activityLevel,
                          style: AppTextStyles.bodyBold),
                      const SizedBox(height: 12),
                      ...  _activityOptions.map((level) {
                        final isSelected = _activityLevel == level;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _activityLevel = level),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.neonBlue.withOpacity(0.1)
                                    : AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.neonBlue
                                      : AppColors.glassBorder,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: isSelected
                                        ? AppColors.neonBlue
                                        : AppColors.textMuted,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _formatActivityLevel(level),
                                    style: AppTextStyles.body.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Calculate button
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: GradientButton(
                    text: AppStrings.calculateResults,
                    onPressed: _calculateAndSave,
                    isLoading: profileState.isLoading,
                    icon: Icons.auto_awesome,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _genderCard({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.neonBlue.withOpacity(0.1)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.neonBlue : AppColors.glassBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.neonBlue : AppColors.textMuted,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodyBold.copyWith(
                color: isSelected ? AppColors.neonBlue : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
