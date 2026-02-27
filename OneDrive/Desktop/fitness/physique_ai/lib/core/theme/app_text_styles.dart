import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get heading1 => GoogleFonts.outfit(
        fontSize: 34, // Slightly larger
        fontWeight: FontWeight.w800, // Extra bold for premium feel
        color: Colors.white,
        letterSpacing: -1.0, // Tighter spacing for modern look
      );

  static TextStyle get heading2 => GoogleFonts.outfit(
        fontSize: 26, // Slightly larger
        fontWeight: FontWeight.w700, // Bolder
        color: Colors.white,
        letterSpacing: -0.5,
      );

  static TextStyle get heading3 => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get subtitle => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: const Color(0xFFB0B0C0),
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFB0B0C0),
      );

  static TextStyle get bodyBold => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B6B80),
      );

  static TextStyle get button => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.5,
      );

  static TextStyle get statValue => GoogleFonts.outfit(
        fontSize: 32, // Larger stats
        fontWeight: FontWeight.w800, // Bolder numbers
        color: Colors.white,
        letterSpacing: -1.0,
      );

  static TextStyle get statLabel => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF6B6B80),
      );
}
