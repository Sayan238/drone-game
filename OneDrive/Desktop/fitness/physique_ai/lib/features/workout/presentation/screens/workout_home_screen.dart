import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/datasources/workout_data.dart';

class WorkoutHomeScreen extends ConsumerWidget {
  const WorkoutHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).profile;
    final goal = profile?.goal ?? 'muscle_gain';
    final workouts = WorkoutData.getWorkouts(goal);

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
                      Text('Workouts', style: AppTextStyles.heading1),
                      const SizedBox(height: 4),
                      Text(
                        _getPlanName(goal),
                        style: AppTextStyles.subtitle.copyWith(
                          color: AppColors.neonBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Plan info card
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassmorphicCard(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.neonBlue.withOpacity(0.08),
                        AppColors.neonPurple.withOpacity(0.04),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.auto_awesome,
                              color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('AI-Generated Plan',
                                  style: AppTextStyles.bodyBold),
                              Text(
                                '${workouts.length}-day split • Tailored for ${_formatGoal(goal)}',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const SectionHeader(title: 'Your Routine'),
              const SizedBox(height: 4),

              // Workout cards
              ...workouts.asMap().entries.map((entry) {
                final i = entry.key;
                final workout = entry.value;
                final exercises = workout['exercises'] as List;
                final color = Color(workout['color'] as int);

                return FadeInUp(
                  delay: Duration(milliseconds: 150 + i * 80),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 6),
                    child: GlassmorphicCard(
                      onTap: () {
                        context.push('/workout-detail',
                            extra: workout['type'] as String);
                      },
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.08),
                          color.withOpacity(0.02),
                        ],
                      ),
                      borderColor: color.withOpacity(0.2),
                      child: Row(
                        children: [
                          // Day badge
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                workout['icon'] as String,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        workout['day'] as String,
                                        style:
                                            AppTextStyles.caption.copyWith(
                                          color: color,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  workout['name'] as String,
                                  style: AppTextStyles.bodyBold,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${exercises.length} exercises',
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: color.withOpacity(0.5),
                            size: 16,
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

  String _getPlanName(String goal) {
    switch (goal) {
      case 'muscle_gain':
        return 'Push / Pull / Legs (6-Day Split)';
      case 'fat_loss':
        return 'Fat Burn Routine (3-Day + HIIT)';
      case 'six_pack':
        return 'Six-Pack Program (5-Day Core Focus)';
      default:
        return 'Beginner Split (4-Day Upper/Lower)';
    }
  }

  String _formatGoal(String goal) {
    switch (goal) {
      case 'muscle_gain':
        return 'Muscle Gain';
      case 'fat_loss':
        return 'Fat Loss';
      case 'six_pack':
        return 'Six Pack';
      default:
        return 'Fitness';
    }
  }
}
