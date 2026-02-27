import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary dark backgrounds
  static const Color background = Color(0xFF050508); // Deeper black
  static const Color surface = Color(0xFF0F0F16);
  static const Color surfaceLight = Color(0xFF181824);
  static const Color cardDark = Color(0xFF0C0C12);

  // Neon accents
  static const Color neonBlue = Color(0xFF00E5FF); // Brighter cyan
  static const Color neonGreen = Color(0xFF00FA9A); // Spring green
  static const Color neonPurple = Color(0xFFC77DF3);
  static const Color neonPink = Color(0xFFFF2A85);

  // Primary gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [neonBlue, Color(0xFF0088CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [neonGreen, Color(0xFF00CC88)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [
      Color(0x1A00D4FF),
      Color(0x0D00D4FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [
      Color(0xFF141420),
      Color(0xFF0A0A0F),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C0);
  static const Color textMuted = Color(0xFF6B6B80);

  // Status colors
  static const Color success = Color(0xFF39FF14);
  static const Color warning = Color(0xFFFFD700);
  static const Color error = Color(0xFFFF4444);
  static const Color info = Color(0xFF00D4FF);

  // Glass effect
  static const Color glassWhite = Color(0x15FFFFFF);
  static const Color glassBorder = Color(0x40FFFFFF); // Stronger border
  static const Color glassBackground = Color(0x0AFFFFFF);
}
