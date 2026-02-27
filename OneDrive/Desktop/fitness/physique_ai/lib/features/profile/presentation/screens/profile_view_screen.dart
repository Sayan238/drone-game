import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../providers/profile_provider.dart';

class ProfileViewScreen extends ConsumerWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: profile == null
          ? const Center(
              child: Text('No profile data',
                  style: TextStyle(color: Colors.white)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Avatar
                  FadeInDown(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonBlue.withOpacity(0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          profile.name.isNotEmpty
                              ? profile.name[0].toUpperCase()
                              : 'U',
                          style: AppTextStyles.heading1.copyWith(fontSize: 40),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    child: Text(profile.name, style: AppTextStyles.heading2),
                  ),
                  const SizedBox(height: 4),
                  FadeInUp(
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      _formatGoal(profile.goal),
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.neonBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Stats Grid
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Row(
                      children: [
                        Expanded(
                          child: _infoCard('Age', '${profile.age}',
                              Icons.cake_outlined),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _infoCard(
                              'Height',
                              '${profile.heightCm.toInt()} cm',
                              Icons.height),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _infoCard(
                              'Weight',
                              '${profile.weightKg.toInt()} kg',
                              Icons.monitor_weight_outlined),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Details
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: GlassmorphicCard(
                      child: Column(
                        children: [
                          _detailRow('BMI',
                              '${profile.bmi?.toStringAsFixed(1)} (${profile.bmiCategory})'),
                          _divider(),
                          _detailRow(
                              'Daily Calories',
                              '${profile.calorieTarget?.toInt()} cal'),
                          _divider(),
                          _detailRow(
                              'Protein Target',
                              '${profile.protein?.toInt()}g'),
                          _divider(),
                          _detailRow(
                              'Diet Preference',
                              _formatDiet(profile.dietPreference)),
                          _divider(),
                          _detailRow(
                              'Activity Level',
                              _formatActivity(profile.activityLevel)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: GradientButton(
                      text: 'Edit Profile',
                      onPressed: () => context.go('/profile-setup'),
                      icon: Icons.edit_outlined,
                      isOutlined: true,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _infoCard(String label, String value, IconData icon) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Icon(icon, color: AppColors.neonBlue, size: 22),
          const SizedBox(height: 8),
          Text(value,
              style: AppTextStyles.bodyBold, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body),
          Text(value, style: AppTextStyles.bodyBold),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: AppColors.glassBorder.withOpacity(0.5),
      height: 1,
    );
  }

  String _formatGoal(String goal) {
    switch (goal) {
      case 'muscle_gain':
        return '💪 Muscle Gain';
      case 'fat_loss':
        return '🔥 Fat Loss';
      case 'six_pack':
        return '🔱 Six Pack';
      case 'maintenance':
        return '⚖️ Maintenance';
      default:
        return goal;
    }
  }

  String _formatDiet(String diet) {
    switch (diet) {
      case 'veg':
        return 'Vegetarian';
      case 'non_veg':
        return 'Non-Veg';
      case 'egg':
        return 'Eggetarian';
      default:
        return diet;
    }
  }

  String _formatActivity(String level) {
    switch (level) {
      case 'sedentary':
        return 'Sedentary';
      case 'light':
        return 'Lightly Active';
      case 'moderate':
        return 'Moderately Active';
      case 'active':
        return 'Very Active';
      case 'extra':
        return 'Extra Active';
      default:
        return level;
    }
  }
}
