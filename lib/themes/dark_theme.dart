// lib/themes/dark_theme.dart
import 'package:flutter/material.dart';
import '../core/config/app_colors.dart';

ThemeData get darkTheme => ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.midnight,
      primaryColor: AppColors.neonCyan,
      cardColor: AppColors.darkBlue,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonCyan,
          foregroundColor: AppColors.midnight,
        ),
      ),
    );