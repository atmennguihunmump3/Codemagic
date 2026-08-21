import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: AppColors.bgLight,
    primaryColor: AppColors.primaryDark,
    cardColor: AppColors.cardBg,
    dividerColor: AppColors.border,
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
      titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textMain),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.textBody),
      bodySmall: TextStyle(fontSize: 12, color: AppColors.textMuted),
    ),
  );
}