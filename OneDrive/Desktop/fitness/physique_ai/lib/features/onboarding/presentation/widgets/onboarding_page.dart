import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../screens/onboarding_screen.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with glow
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    data.color.withValues(alpha: 0.2),
                    data.color.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: data.color.withValues(alpha: 0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: data.color.withValues(alpha: 0.25), // Stronger outer glow
                    blurRadius: 50,
                    spreadRadius: 15,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5), // Inner depth shadow
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                data.icon,
                size: 64,
                color: data.color,
              ),
            ),
          ),
          const SizedBox(height: 48),
          // Title
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 200),
            child: Text(
              data.title,
              style: AppTextStyles.heading1,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          // Description
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 400),
            child: Text(
              data.description,
              style: AppTextStyles.body.copyWith(height: 1.6),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
