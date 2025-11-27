// lib/features/auth/widgets/circuit_board_painter.dart
import 'package:flutter/material.dart';
import '../../../core/config/app_colors.dart';

class CircuitBoardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neonBlue.withOpacity(0.03)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final w = size.width;
    final h = size.height;

    // Linhas de circuito
    path.moveTo(0, h * 0.8);
    path.lineTo(w * 0.15, h * 0.8);
    path.lineTo(w * 0.2, h * 0.7);
    path.lineTo(w * 0.35, h * 0.7);
    path.lineTo(w * 0.4, h * 0.75);

    path.moveTo(w, h * 0.9);
    path.lineTo(w * 0.85, h * 0.9);
    path.lineTo(w * 0.8, h * 0.85);
    path.lineTo(w * 0.65, h * 0.85);
    path.lineTo(w * 0.6, h * 0.8);

    // Nós de conexão
    canvas.drawCircle(
        Offset(w * 0.35, h * 0.7), 2, paint..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(w * 0.65, h * 0.85), 2, paint);
    canvas.drawCircle(Offset(w * 0.15, h * 0.8), 2, paint);
    canvas.drawCircle(Offset(w * 0.85, h * 0.9), 2, paint);

    paint.style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}