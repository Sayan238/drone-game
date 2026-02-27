import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/datasources/indian_diet_data.dart';

class DietPlanScreen extends ConsumerWidget {
  const DietPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).profile;
    final calorieTarget = profile?.calorieTarget ?? 2200;
    final dietPref = profile?.dietPreference ?? 'non_veg';
    final goal = profile?.goal ?? 'muscle_gain';

    final dietPlan = IndianDietData.getDietPlan(
      calorieTarget: calorieTarget,
      dietPreference: dietPref,
      goal: goal,
    );

    final mealColors = [
      AppColors.neonBlue,
      AppColors.neonGreen,
      AppColors.neonPurple,
      AppColors.warning,
      AppColors.neonPink,
      AppColors.neonBlue,
      AppColors.neonGreen,
    ];

    final mealIcons = [
      '🌅',
      '🥜',
      '🍽️',
      '⚡',
      '🏋️',
      '🌙',
      '🍵',
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header
              FadeInDown(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Diet Plan', style: AppTextStyles.heading1),
                      const SizedBox(height: 4),
                      Text(
                        'Personalized Indian Diet • ${calorieTarget.toInt()} cal/day',
                        style: AppTextStyles.subtitle.copyWith(
                          color: AppColors.neonGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Diet info
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassmorphicCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _macroSummary('Protein', '${profile?.protein?.toInt() ?? 140}g',
                            AppColors.neonBlue),
                        Container(
                            width: 1,
                            height: 30,
                            color: AppColors.glassBorder),
                        _macroSummary('Carbs', '${profile?.carbs?.toInt() ?? 250}g',
                            AppColors.neonGreen),
                        Container(
                            width: 1,
                            height: 30,
                            color: AppColors.glassBorder),
                        _macroSummary(
                            'Fat', '${profile?.fat?.toInt() ?? 60}g', AppColors.warning),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Meal sections
              ...dietPlan.entries.toList().asMap().entries.map((entry) {
                final mealIndex = entry.key;
                final mealName = entry.value.key;
                final foods = entry.value.value;
                final color = mealColors[mealIndex % mealColors.length];
                final icon = mealIcons[mealIndex % mealIcons.length];

                final totalCal =
                    foods.fold<int>(0, (sum, f) => sum + (f['calories'] as int));

                return FadeInUp(
                  delay: Duration(milliseconds: 150 + mealIndex * 80),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 6),
                    child: GlassmorphicCard(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.06),
                          color.withOpacity(0.02),
                        ],
                      ),
                      borderColor: color.withOpacity(0.15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Meal header
                          Row(
                            children: [
                              Text(icon,
                                  style: const TextStyle(fontSize: 22)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(mealName,
                                        style: AppTextStyles.bodyBold),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$totalCal cal',
                                  style: AppTextStyles.caption.copyWith(
                                    color: color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Food items
                          ...foods.map((food) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        food['name'] as String,
                                        style: AppTextStyles.body,
                                      ),
                                    ),
                                    Text(
                                      '${food['calories']} cal',
                                      style: AppTextStyles.caption
                                          .copyWith(color: color),
                                    ),
                                  ],
                                ),
                              )),
                          // Macros row
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _microMacro('P', '${foods.fold<int>(0, (s, f) => s + (f['protein'] as int))}g',
                                  AppColors.neonBlue),
                              const SizedBox(width: 8),
                              _microMacro('C', '${foods.fold<int>(0, (s, f) => s + (f['carbs'] as int))}g',
                                  AppColors.neonGreen),
                              const SizedBox(width: 8),
                              _microMacro('F', '${foods.fold<int>(0, (s, f) => s + (f['fat'] as int))}g',
                                  AppColors.warning),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _macroSummary(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: AppTextStyles.heading3.copyWith(color: color, fontSize: 18)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _microMacro(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: $value',
        style: AppTextStyles.caption.copyWith(
          fontSize: 10,
          color: color,
        ),
      ),
    );
  }
}
