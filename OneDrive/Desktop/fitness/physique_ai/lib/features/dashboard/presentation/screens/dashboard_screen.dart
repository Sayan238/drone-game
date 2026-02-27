import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glassmorphic_card.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).profile;
    final quote = AppStrings.motivationalQuotes[
        DateTime.now().day % AppStrings.motivationalQuotes.length];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Greeting
              FadeInDown(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${profile?.name ?? 'Champ'} 💪',
                            style: AppTextStyles.heading2,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getGreeting(),
                            style: AppTextStyles.body,
                          ),
                        ],
                      ),
                      GestureDetector(
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              profile?.name.isNotEmpty == true
                                  ? profile!.name[0].toUpperCase()
                                  : 'U',
                              style: AppTextStyles.heading3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Motivational banner
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassmorphicCard(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.neonBlue.withOpacity(0.1),
                        AppColors.neonPurple.withOpacity(0.05),
                      ],
                    ),
                    borderColor: AppColors.neonBlue.withOpacity(0.2),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.neonBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.format_quote,
                              color: AppColors.neonBlue, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            quote,
                            style: AppTextStyles.body.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Quick stats
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 140,
                    child: Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            label: 'Weight',
                            value: '${profile?.weightKg.toInt() ?? 70}',
                            unit: 'kg',
                            icon: Icons.monitor_weight_outlined,
                            accentColor: AppColors.neonBlue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            label: 'Calories',
                            value: '${profile?.calorieTarget?.toInt() ?? 2200}',
                            unit: 'cal',
                            icon: Icons.local_fire_department_outlined,
                            accentColor: AppColors.neonGreen,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            label: 'Protein',
                            value: '${profile?.protein?.toInt() ?? 140}',
                            unit: 'g',
                            icon: Icons.egg_alt_outlined,
                            accentColor: AppColors.neonPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Weight Chart
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: Column(
                  children: [
                    const SectionHeader(title: 'Weight Trend'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GlassmorphicCard(
                        height: 200,
                        child: _buildWeightChart(profile?.weightKg ?? 70),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Calorie Chart
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Column(
                  children: [
                    const SectionHeader(title: 'Weekly Calories'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GlassmorphicCard(
                        height: 200,
                        child: _buildCalorieChart(
                            profile?.calorieTarget ?? 2200),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Today's summary
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassmorphicCard(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.neonGreen.withOpacity(0.08),
                        AppColors.neonGreen.withOpacity(0.03),
                      ],
                    ),
                    borderColor: AppColors.neonGreen.withOpacity(0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.today,
                                color: AppColors.neonGreen, size: 20),
                            const SizedBox(width: 8),
                            Text("Today's Focus",
                                style: AppTextStyles.bodyBold),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _focusItem(
                            '🏋️', 'Complete your workout session'),
                        _focusItem(
                            '🥗',
                            'Hit ${profile?.calorieTarget?.toInt() ?? 2200} cal target'),
                        _focusItem('💧',
                            'Drink ${((profile?.waterLiters ?? 2.5) * 4).toInt()} glasses of water'),
                        _focusItem('😴', 'Get 7-8 hours of sleep'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _focusItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: AppTextStyles.body),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 17) return 'Good Afternoon 🌤️';
    return 'Good Evening 🌙';
  }

  Widget _buildWeightChart(double currentWeight) {
    final random = Random(42);
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppColors.glassBorder.withOpacity(0.3),
            strokeWidth: 0.5,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: (value, _) => Text(
                '${value.toInt()}',
                style: AppTextStyles.caption.copyWith(fontSize: 10),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                if (value.toInt() < days.length) {
                  return Text(
                    days[value.toInt()],
                    style: AppTextStyles.caption.copyWith(fontSize: 10),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(7, (i) {
              return FlSpot(
                i.toDouble(),
                currentWeight - 2 + random.nextDouble() * 3,
              );
            }),
            isCurved: true,
            color: AppColors.neonBlue,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.neonBlue.withOpacity(0.2),
                  AppColors.neonBlue.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        minY: currentWeight - 4,
        maxY: currentWeight + 2,
      ),
    );
  }

  Widget _buildCalorieChart(double target) {
    final random = Random(99);
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return BarChart(
      BarChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 500,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppColors.glassBorder.withOpacity(0.3),
            strokeWidth: 0.5,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, _) => Text(
                '${value.toInt()}',
                style: AppTextStyles.caption.copyWith(fontSize: 10),
              ),
            ),
          ),
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
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(7, (i) {
          final value = target * 0.7 + random.nextDouble() * target * 0.5;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: value,
                width: 16,
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  colors: [
                    value > target
                        ? AppColors.warning
                        : AppColors.neonGreen,
                    value > target
                        ? AppColors.warning.withOpacity(0.5)
                        : AppColors.neonGreen.withOpacity(0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ],
          );
        }),
        maxY: target * 1.4,
      ),
    );
  }
}
