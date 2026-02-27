import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../providers/profile_provider.dart';

class FitnessResultsScreen extends ConsumerWidget {
  const FitnessResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).profile;

    if (profile == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header
              FadeInDown(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome,
                            color: AppColors.neonGreen, size: 28),
                        const SizedBox(width: 8),
                        Text('Your AI Plan', style: AppTextStyles.heading1),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Here\'s your personalized fitness blueprint',
                      style: AppTextStyles.subtitle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // BMI Card
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: GlassmorphicCard(
                  child: Row(
                    children: [
                      CircularPercentIndicator(
                        radius: 45,
                        lineWidth: 8,
                        percent: ((profile.bmi ?? 22) / 40).clamp(0.0, 1.0),
                        center: Text(
                          profile.bmi?.toStringAsFixed(1) ?? '—',
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.neonBlue,
                          ),
                        ),
                        progressColor: _getBMIColor(profile.bmi ?? 22),
                        backgroundColor: AppColors.surfaceLight,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Body Mass Index',
                                style: AppTextStyles.bodyBold),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getBMIColor(profile.bmi ?? 22)
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                profile.bmiCategory ?? 'Normal',
                                style: AppTextStyles.caption.copyWith(
                                  color: _getBMIColor(profile.bmi ?? 22),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Height: ${profile.heightCm.toInt()} cm  •  Weight: ${profile.weightKg.toInt()} kg',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Calorie target
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: GlassmorphicCard(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.neonBlue.withOpacity(0.1),
                      AppColors.neonBlue.withOpacity(0.05),
                    ],
                  ),
                  borderColor: AppColors.neonBlue.withOpacity(0.3),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Daily Calorie Target',
                              style: AppTextStyles.bodyBold),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _formatGoal(profile.goal),
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${profile.calorieTarget?.toInt() ?? 0}',
                        style: AppTextStyles.statValue.copyWith(
                          fontSize: 48,
                          color: AppColors.neonBlue,
                        ),
                      ),
                      Text('calories / day', style: AppTextStyles.caption),
                      const SizedBox(height: 8),
                      Text(
                        'TDEE: ${profile.tdee?.toInt() ?? 0} cal  •  BMR: ${profile.bmr?.toInt() ?? 0} cal',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Macro breakdown
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: Row(
                  children: [
                    Expanded(
                      child: _macroCard(
                        'Protein',
                        '${profile.protein?.toInt() ?? 0}g',
                        Icons.egg_alt_outlined,
                        AppColors.neonBlue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _macroCard(
                        'Carbs',
                        '${profile.carbs?.toInt() ?? 0}g',
                        Icons.grain,
                        AppColors.neonGreen,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _macroCard(
                        'Fat',
                        '${profile.fat?.toInt() ?? 0}g',
                        Icons.water_drop_outlined,
                        AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Water intake
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: GlassmorphicCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.neonBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.water_drop,
                            color: AppColors.neonBlue, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Daily Water Intake',
                                style: AppTextStyles.bodyBold),
                            Text(
                              '${profile.waterLiters?.toStringAsFixed(1) ?? 0} liters (~${((profile.waterLiters ?? 2.3) * 4).toInt()} glasses)',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Continue button
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: GradientButton(
                  text: 'Start My Journey',
                  onPressed: () => context.go('/home'),
                  icon: Icons.arrow_forward_rounded,
                ),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 550),
                child: GradientButton(
                  text: 'Edit Profile',
                  onPressed: () => context.go('/profile-setup'),
                  isOutlined: true,
                  icon: Icons.edit_outlined,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _macroCard(String label, String value, IconData icon, Color color) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.heading3.copyWith(color: color, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return AppColors.info;
    if (bmi < 25) return AppColors.success;
    if (bmi < 30) return AppColors.warning;
    return AppColors.error;
  }

  String _formatGoal(String goal) {
    switch (goal) {
      case 'muscle_gain':
        return 'MUSCLE GAIN';
      case 'fat_loss':
        return 'FAT LOSS';
      case 'six_pack':
        return 'SIX PACK';
      case 'maintenance':
        return 'MAINTENANCE';
      default:
        return goal.toUpperCase();
    }
  }
}
