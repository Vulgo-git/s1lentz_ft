// lib/features/auth/widgets/logo_painter.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/config/app_colors.dart';

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.45);
    final sideLength = size.width * 0.7;
    final height = sideLength * (math.sqrt(3) / 2);

    // Configuração das cores
    final bluePaint = Paint()
      ..color = AppColors.neonBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = AppColors.neonBlue.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    // --- Círculo Triplo ---
    final outerCircleRadius = sideLength * 0.8;
    final middleCircleRadius = sideLength * 0.65;
    final innerCircleRadius = sideLength * 0.5;

    // Camada externa - círculo com efeito de glow
    canvas.drawCircle(center, outerCircleRadius, glowPaint);
    canvas.drawCircle(center, outerCircleRadius, bluePaint..strokeWidth = 2);

    // Camada do meio - círculo pontilhado
    final dottedPaint = Paint()
      ..color = AppColors.neonBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    _drawDottedCircle(canvas, center, middleCircleRadius, dottedPaint);

    // Camada interna - círculo fino
    canvas.drawCircle(
        center, innerCircleRadius, bluePaint..strokeWidth = 1.0);

    // --- Triângulo Principal ---
    final pathTriangle = Path();
    pathTriangle.moveTo(center.dx, center.dy - height / 2);
    pathTriangle.lineTo(center.dx + sideLength / 2, center.dy + height / 2);
    pathTriangle.lineTo(center.dx - sideLength / 2, center.dy + height / 2);
    pathTriangle.close();

    canvas.drawPath(pathTriangle, bluePaint..strokeWidth = 2.5);

    // --- Símbolo "S1" Interno ---
    final sPath = Path();
    final double sSize = sideLength * 0.35;
    final Offset sCenter = center.translate(0, height * 0.1);

    // Desenho do "S" estilizado
    sPath.moveTo(sCenter.dx - sSize * 0.6, sCenter.dy - sSize * 0.6);
    sPath.lineTo(sCenter.dx + sSize * 0.4, sCenter.dy - sSize * 0.6);
    sPath.lineTo(sCenter.dx - sSize * 0.2, sCenter.dy);
    sPath.moveTo(sCenter.dx - sSize * 0.2, sCenter.dy);
    sPath.lineTo(sCenter.dx + sSize * 0.4, sCenter.dy);
    sPath.moveTo(sCenter.dx + sSize * 0.4, sCenter.dy);
    sPath.lineTo(sCenter.dx - sSize * 0.2, sCenter.dy + sSize * 0.6);
    sPath.lineTo(sCenter.dx + sSize * 0.6, sCenter.dy + sSize * 0.6);

    // Desenho do "1"
    final onePath = Path();
    onePath.moveTo(sCenter.dx + sSize * 0.2, sCenter.dy - sSize * 0.4);
    onePath.lineTo(sCenter.dx + sSize * 0.2, sCenter.dy + sSize * 0.6);

    canvas.drawPath(sPath, bluePaint..strokeWidth = 3);
    canvas.drawPath(onePath, bluePaint..strokeWidth = 3);

    // Detalhes internos do círculo - linhas radiais
    final radialPaint = Paint()
      ..color = AppColors.neonBlue.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      final x = center.dx + math.cos(angle) * innerCircleRadius;
      final y = center.dy + math.sin(angle) * innerCircleRadius;
      canvas.drawLine(center, Offset(x, y), radialPaint);
    }
  }

  void _drawDottedCircle(
      Canvas canvas, Offset center, double radius, Paint paint) {
    const int dots = 40;
    for (int i = 0; i < dots; i++) {
      final double angle = (2 * math.pi * i) / dots;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      canvas.drawCircle(Offset(x, y), 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}