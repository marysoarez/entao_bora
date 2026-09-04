import 'package:flutter/material.dart';
import 'package:entao_bora/shared/design_system/app_design_system.dart';

class AppTheme {
  AppTheme._();

  // Cores
  static const Color primary = DsColors.primary;
  static const Color secondary = DsColors.accent;

  static const Color background = DsColors.adminBackground;
  static const Color surface = DsColors.adminSurface;

  static const Color textPrimary = DsColors.adminText;
  static const Color textSecondary = DsColors.adminTextMuted;

  static const Color divider = DsColors.adminDivider;

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      scaffoldBackgroundColor: background,

      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),

      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: background,
        foregroundColor: textPrimary,
        centerTitle: false,
      ),

      dividerColor: divider,

      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DsRadius.xl),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(160, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DsRadius.md),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(160, 52),
          side: const BorderSide(color: divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DsRadius.md),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DsColors.publicText.withValues(alpha: .06),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: DsSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DsRadius.md),
          borderSide: BorderSide(
            color: DsColors.publicText.withValues(alpha: .12),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DsRadius.md),
          borderSide: BorderSide(
            color: DsColors.publicText.withValues(alpha: .12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DsRadius.md),
          borderSide: const BorderSide(color: secondary, width: 1.5),
        ),
        labelStyle: const TextStyle(color: DsColors.publicTextMuted),
        hintStyle: const TextStyle(color: DsColors.publicTextSubtle),
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          height: 1.1,
        ),
        displayMedium: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textPrimary, height: 1.6),
        bodyMedium: TextStyle(fontSize: 14, color: textSecondary, height: 1.5),
      ),
    );
  }
}
