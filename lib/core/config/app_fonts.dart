// lib/core/config/app_fonts.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppFonts {
  static List<BoxShadow> glowCyanSoft = [
    BoxShadow(
      color: AppColors.neonCyan.withOpacity(0.2),
      blurRadius: 10,
      spreadRadius: 0,
    )
  ];

  static TextStyle neonText = TextStyle(
    color: AppColors.neonCyan,
    shadows: [
      Shadow(
        color: AppColors.neonCyan.withOpacity(0.5),
        blurRadius: 10,
      ),
    ],
  );
}