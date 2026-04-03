import 'package:flutter/material.dart';

import 'package:tripwise/app/design/app_colors.dart';
import 'package:tripwise/app/design/app_typography.dart';

class AppTheme {
  static const _seed = AppColors.accent;
  static const radius = 16.0;
  static const compactRadius = 12.0;

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
      primary: AppColors.accent,
      surface: AppColors.lightSurface,
      surfaceContainerHighest: AppColors.lightSurfaceVariant,
      onSurface: AppColors.lightText,
      onPrimary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: AppTypography.textTheme(AppColors.lightText),
      dividerColor: scheme.outlineVariant.withAlpha(179),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scheme.surface.withAlpha(230),
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTypography.textTheme(AppColors.lightText)
            .headlineMedium
            ?.copyWith(fontSize: 20),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: scheme.outlineVariant.withAlpha(179)),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(compactRadius),
          borderSide: BorderSide(color: scheme.outlineVariant.withAlpha(204)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(compactRadius),
          borderSide: BorderSide(color: scheme.outlineVariant.withAlpha(204)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(compactRadius),
          borderSide: BorderSide(color: scheme.primary.withAlpha(230), width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(compactRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(compactRadius),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.surface,
        contentTextStyle: AppTypography.textTheme(AppColors.lightText).bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(compactRadius),
          side: BorderSide(color: scheme.outlineVariant.withAlpha(179)),
        ),
      ),
    );
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
      primary: AppColors.accent,
      surface: AppColors.darkSurface,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      onSurface: AppColors.darkText,
      onPrimary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: AppTypography.textTheme(AppColors.darkText),
      dividerColor: scheme.outlineVariant.withAlpha(128),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scheme.surface.withAlpha(230),
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTypography.textTheme(AppColors.darkText)
            .headlineMedium
            ?.copyWith(fontSize: 20),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: scheme.outlineVariant.withAlpha(140)),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(compactRadius),
          borderSide: BorderSide(color: scheme.outlineVariant.withAlpha(153)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(compactRadius),
          borderSide: BorderSide(color: scheme.outlineVariant.withAlpha(153)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(compactRadius),
          borderSide: BorderSide(color: scheme.primary.withAlpha(230), width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(compactRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(compactRadius),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.surface,
        contentTextStyle: AppTypography.textTheme(AppColors.darkText).bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(compactRadius),
          side: BorderSide(color: scheme.outlineVariant.withAlpha(140)),
        ),
      ),
    );
  }
}

