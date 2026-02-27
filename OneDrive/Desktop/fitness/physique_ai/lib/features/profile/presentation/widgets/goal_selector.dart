import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class GoalSelector extends StatelessWidget {
  final String selectedGoal;
  final ValueChanged<String> onGoalSelected;

  const GoalSelector({
    super.key,
    required this.selectedGoal,
    required this.onGoalSelected,
  });

  @override
  Widget build(BuildContext context) {
    final goals = [
      _GoalOption('muscle_gain', 'Muscle Gain', Icons.fitness_center_rounded, AppColors.neonBlue),
      _GoalOption('fat_loss', 'Fat Loss', Icons.local_fire_department_rounded, AppColors.neonPink),
      _GoalOption('six_pack', 'Six Pack', Icons.grid_on_rounded, AppColors.neonGreen),
      _GoalOption('maintenance', 'Maintenance', Icons.balance_rounded, AppColors.neonPurple),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: goals.map((goal) {
        final isSelected = selectedGoal == goal.id;
        return GestureDetector(
          onTap: () => onGoalSelected(goal.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: (MediaQuery.of(context).size.width - 72) / 2,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? goal.color.withOpacity(0.15)
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? goal.color
                    : AppColors.glassBorder,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: goal.color.withOpacity(0.2),
                        blurRadius: 16,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              children: [
                Icon(
                  goal.icon,
                  color: isSelected ? goal.color : AppColors.textMuted,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  goal.label,
                  style: AppTextStyles.bodyBold.copyWith(
                    color: isSelected ? goal.color : AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _GoalOption {
  final String id;
  final String label;
  final IconData icon;
  final Color color;

  const _GoalOption(this.id, this.label, this.icon, this.color);
}
