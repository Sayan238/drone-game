import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/section_header.dart';

class HabitTrackerScreen extends ConsumerStatefulWidget {
  const HabitTrackerScreen({super.key});

  @override
  ConsumerState<HabitTrackerScreen> createState() =>
      _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends ConsumerState<HabitTrackerScreen> {
  late Box _habitBox;
  late String _todayKey;

  final List<HabitItem> _habits = [
    HabitItem(
      id: 'water',
      name: 'Water Intake',
      icon: Icons.water_drop_rounded,
      color: AppColors.neonBlue,
      target: 10,
      unit: 'glasses',
      emoji: '💧',
    ),
    HabitItem(
      id: 'sleep',
      name: 'Sleep',
      icon: Icons.bedtime_rounded,
      color: AppColors.neonPurple,
      target: 8,
      unit: 'hours',
      emoji: '😴',
    ),
    HabitItem(
      id: 'steps',
      name: 'Steps',
      icon: Icons.directions_walk_rounded,
      color: AppColors.neonGreen,
      target: 10000,
      unit: 'steps',
      emoji: '🚶',
    ),
    HabitItem(
      id: 'workout',
      name: 'Workout',
      icon: Icons.fitness_center_rounded,
      color: AppColors.neonPink,
      target: 1,
      unit: 'session',
      emoji: '🏋️',
    ),
    HabitItem(
      id: 'meditation',
      name: 'Meditation',
      icon: Icons.self_improvement_rounded,
      color: AppColors.warning,
      target: 1,
      unit: 'session',
      emoji: '🧘',
    ),
  ];

  Map<String, int> _todayData = {};

  @override
  void initState() {
    super.initState();
    _habitBox = Hive.box('habit_data');
    final now = DateTime.now();
    _todayKey = '${now.year}-${now.month}-${now.day}';
    _loadToday();
  }

  void _loadToday() {
    final data = _habitBox.get(_todayKey);
    if (data != null) {
      _todayData = Map<String, int>.from(jsonDecode(data));
    } else {
      _todayData = {for (var h in _habits) h.id: 0};
    }
    setState(() {});
  }

  void _updateHabit(String id, int delta) {
    setState(() {
      _todayData[id] = ((_todayData[id] ?? 0) + delta).clamp(0, 99999);
    });
    _habitBox.put(_todayKey, jsonEncode(_todayData));
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _habits.where((h) {
      final val = _todayData[h.id] ?? 0;
      return val >= h.target;
    }).length;

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
                      Text('Habits', style: AppTextStyles.heading1),
                      const SizedBox(height: 4),
                      Text(
                        '$completedCount of ${_habits.length} completed today',
                        style: AppTextStyles.subtitle.copyWith(
                          color: completedCount == _habits.length
                              ? AppColors.neonGreen
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Progress ring
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassmorphicCard(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 72,
                          height: 72,
                          child: Stack(
                            children: [
                              CircularProgressIndicator(
                                value: completedCount / _habits.length,
                                backgroundColor: AppColors.surfaceLight,
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                        AppColors.neonGreen),
                                strokeWidth: 6,
                              ),
                              Center(
                                child: Text(
                                  '${(completedCount / _habits.length * 100).toInt()}%',
                                  style: AppTextStyles.bodyBold.copyWith(
                                    color: AppColors.neonGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Today's Progress",
                                  style: AppTextStyles.bodyBold),
                              const SizedBox(height: 4),
                              Text(
                                completedCount == _habits.length
                                    ? '🎉 All habits completed! Great job!'
                                    : 'Keep going! ${_habits.length - completedCount} habits remaining.',
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

              const SectionHeader(title: 'Daily Habits'),
              const SizedBox(height: 4),

              // Habit cards
              ..._habits.asMap().entries.map((entry) {
                final i = entry.key;
                final habit = entry.value;
                final value = _todayData[habit.id] ?? 0;
                final isComplete = value >= habit.target;
                final progress = (value / habit.target).clamp(0.0, 1.0);

                return FadeInUp(
                  delay: Duration(milliseconds: 150 + i * 70),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 5),
                    child: GlassmorphicCard(
                      gradient: LinearGradient(
                        colors: [
                          habit.color.withOpacity(isComplete ? 0.12 : 0.05),
                          habit.color.withOpacity(isComplete ? 0.05 : 0.01),
                        ],
                      ),
                      borderColor: isComplete
                          ? habit.color.withOpacity(0.4)
                          : AppColors.glassBorder,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: habit.color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(habit.icon,
                                    color: habit.color, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(habit.name,
                                            style: AppTextStyles.bodyBold),
                                        if (isComplete) ...[
                                          const SizedBox(width: 8),
                                          const Icon(Icons.check_circle,
                                              color: AppColors.neonGreen,
                                              size: 16),
                                        ],
                                      ],
                                    ),
                                    Text(
                                      '$value / ${habit.target} ${habit.unit}',
                                      style: AppTextStyles.caption.copyWith(
                                        color: isComplete
                                            ? habit.color
                                            : AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Controls
                              Row(
                                children: [
                                  _circleButton(
                                    Icons.remove,
                                    () => _updateHabit(
                                        habit.id,
                                        habit.id == 'steps'
                                            ? -1000
                                            : -1),
                                    habit.color,
                                  ),
                                  const SizedBox(width: 8),
                                  _circleButton(
                                    Icons.add,
                                    () => _updateHabit(
                                        habit.id,
                                        habit.id == 'steps'
                                            ? 1000
                                            : 1),
                                    habit.color,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: AppColors.surfaceLight,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  habit.color),
                              minHeight: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Weekly chart
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                    const SectionHeader(title: 'Weekly Overview'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GlassmorphicCard(
                        height: 180,
                        child: _buildWeeklyChart(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  Widget _buildWeeklyChart() {
    final random = Random(7);
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                if (value.toInt() < days.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      days[value.toInt()],
                      style: AppTextStyles.caption.copyWith(fontSize: 10),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(7, (i) {
          final val = 1 + random.nextInt(5);
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: val.toDouble(),
                width: 20,
                borderRadius: BorderRadius.circular(6),
                gradient: LinearGradient(
                  colors: [
                    AppColors.neonBlue,
                    AppColors.neonBlue.withOpacity(0.4),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ],
          );
        }),
        maxY: 6,
      ),
    );
  }
}

class HabitItem {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int target;
  final String unit;
  final String emoji;

  const HabitItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.target,
    required this.unit,
    required this.emoji,
  });
}
