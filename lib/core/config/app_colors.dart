// lib/core/config/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // --- Paleta Principal (Neon / Cyber) ---
  
  // Fundo principal escuro (Midnight Blue/Black)
  static const Color midnight = Color(0xFF0A0F1C);
  static const Color background = Color(0xFF000000);
  
  // Cor de destaque / primária (Ciano Neon)
  static const Color neonCyan = Color(0xFF3BB3FF);
  static const Color primaryNeon = Color(0xFF00BFFF);
  static const Color neonBlue = Color(0xFF0066FF);
  
  // Fundo secundário para cards/inputs (Azul Escuro)
  static const Color darkBlue = Color(0xFF151A2E);
  static const Color cardBackground = Color(0xFF0A0A0A);
  
  // Borda sutil para cards e elementos (Ciano acinzentado)
  static const Color borderCyan = Color(0xFF2E3A59);
  static const Color borderDark = Color(0xFF1A1F2E);
  
  // Cor de preenchimento para campos de entrada
  static const Color inputFill = Color(0xFF1F2640);
  static const Color inputBg = Color(0xFF0A0E15);
  
  // --- Paleta de Texto ---
  
  // Texto principal
  static const Color textPrimary = Color(0xFFFFFFFF);
  
  // Texto secundário/Hints
  static const Color textSecondary = Color(0xFF9FA5B4);
  static const Color textGray = Color(0xFF6B7280);
  
  // --- Cores de Status ---
  
  static const Color error = Color(0xFFFF4E4E);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color success = Color(0xFF00FF8C);
  static const Color successGreen = Color(0xFF10B981);
  
  // --- Neon Variations ---
  
  static const Color secondaryNeon = Color(0xFF0088FF);
  static const Color neonLight = Color(0xFF00BFFF);
  static const Color neonDark = Color(0xFF0088FF);
  static const Color neonGlow = Color(0x4000BFFF);
  
  // --- Gradientes ---
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [neonLight, neonDark],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  // --- Dimensões e Padding ---
  
  // Padding padrão para seções e cards
  static const EdgeInsets sectionPadding =
      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0);
  
  // Padding horizontal
  static const double horizontalPadding = 20.0;
  
  // Padding vertical
  static const double verticalPadding = 10.0;
}