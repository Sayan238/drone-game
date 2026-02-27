import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/datasources/workout_data.dart';

class WorkoutDetailScreen extends ConsumerWidget {
  final String workoutType;

  const WorkoutDetailScreen({super.key, required this.workoutType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).profile;
    final goal = profile?.goal ?? 'muscle_gain';
    final workouts = WorkoutData.getWorkouts(goal);

    final workout = workouts.firstWhere(
      (w) => w['type'] == workoutType,
      orElse: () => workouts.first,
    );

    final exercises = workout['exercises'] as List;
    final color = Color(workout['color'] as int);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: workout['name'] as String,
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Workout info header
            FadeInDown(
              child: GlassmorphicCard(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.12),
                    color.withOpacity(0.04),
                  ],
                ),
                borderColor: color.withOpacity(0.3),
                child: Row(
                  children: [
                    Text(
                      workout['icon'] as String,
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${workout['day']} - ${workout['name']}',
                            style: AppTextStyles.heading3,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${exercises.length} exercises • ~45-60 min',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Exercise list
            Text('Exercises', style: AppTextStyles.heading3),
            const SizedBox(height: 12),

            ...exercises.asMap().entries.map((entry) {
              final i = entry.key;
              final exercise = entry.value as Map<String, dynamic>;

              return FadeInUp(
                delay: Duration(milliseconds: 50 + i * 60),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.glassBorder.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Number badge
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: AppTextStyles.bodyBold.copyWith(
                              color: color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise['name'] as String,
                              style: AppTextStyles.bodyBold,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _infoChip(
                                    '${exercise['sets']} sets', color),
                                const SizedBox(width: 6),
                                _infoChip(
                                    '${exercise['reps']} reps',
                                    AppColors.textMuted),
                                const SizedBox(width: 6),
                                _infoChip(
                                    '${exercise['rest']} rest',
                                    AppColors.textMuted),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          exercise['muscle'] as String,
                          style: AppTextStyles.caption
                              .copyWith(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 32),

            // Tips
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: GlassmorphicCard(
                gradient: LinearGradient(
                  colors: [
                    AppColors.neonGreen.withOpacity(0.08),
                    AppColors.neonGreen.withOpacity(0.02),
                  ],
                ),
                borderColor: AppColors.neonGreen.withOpacity(0.2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline,
                            color: AppColors.neonGreen, size: 20),
                        const SizedBox(width: 8),
                        Text('Pro Tips',
                            style: AppTextStyles.bodyBold.copyWith(
                                color: AppColors.neonGreen)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• Warm up for 5-10 minutes before starting\n'
                      '• Focus on proper form over heavy weight\n'
                      '• Control the negative (eccentric) phase\n'
                      '• Stay hydrated throughout your workout\n'
                      '• Progressive overload: increase weight/reps weekly',
                      style: AppTextStyles.body.copyWith(height: 1.6),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          fontSize: 10,
          color: color,
        ),
      ),
    );
  }
}
