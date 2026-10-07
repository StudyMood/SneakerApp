import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      primaryColor: AppColors.accent,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        secondary: AppColors.accentCyan,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        outline: AppColors.borderLight,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimaryLight,
          letterSpacing: -0.8,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryLight,
          letterSpacing: -0.4,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryLight,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryLight,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryLight,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondaryLight,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondaryLight,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryLight,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }

  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      primaryColor: AppColors.accent,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accentCyan,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        outline: AppColors.borderDark,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimaryDark,
          letterSpacing: -0.8,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark,
          letterSpacing: -0.4,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryDark,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondaryDark,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondaryDark,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }
}

