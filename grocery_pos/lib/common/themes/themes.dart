import 'package:flutter/material.dart';

import 'colors.dart';

class AppThemes {
  static TextTheme get textTheme => const TextTheme(
        //Heading
        headlineLarge: _headlineLarge,
        headlineMedium: _headlineMedium,
        headlineSmall: _headlineSmall,
        //Title
        titleLarge: _titleLarge,
        titleMedium: _titleMedium,
        titleSmall: _titleSmall,
        //Label
        labelLarge: _labelLarge,
        labelMedium: _labelMedium,
        labelSmall: _labelSmall,
        //Body
        bodyLarge: _bodyLarge,
        bodyMedium: _bodyMedium,
        bodySmall: _bodySmall,
      );

  static get colorScheme => const ColorScheme(
        primary: AppColors.primaryColor,
        secondary: AppColors.activeColor,
        surface: AppColors.backgroundColor,
        background: AppColors.backgroundColor,
        error: AppColors.errorColor,
        onPrimary: AppColors.textColor,
        onSecondary: AppColors.textColor,
        onSurface: AppColors.textColor,
        onBackground: AppColors.activeColor,
        onError: AppColors.errorColor,
        brightness: Brightness.light,
      );
// headlineLarge
  static const _headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 40 / 32,
    letterSpacing: 0,
  );

// headlineMedium
  static const _headlineMedium = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 36 / 28,
  );

// headlineSmall
  static const _headlineSmall = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 32 / 24,
  );

// titleLarge
  static const _titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    height: 28 / 22,
    letterSpacing: 0,
  );

// titleMedium
  static const _titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0.15,
  );
// titleSmall
  static const _titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0.1,
  );

// labelLarge
  static const _labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0.1,
  );
// labelMedium
  static const _labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0.5,
  );
// labelSmall
  static const _labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 16 / 11,
    letterSpacing: 0.5,
  );

// bodyLarge
  static const _bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0.15,
  );
// bodyMedium
  static const _bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0.25,
  );
// bodySmall
  static const _bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0.4,
  );
}
