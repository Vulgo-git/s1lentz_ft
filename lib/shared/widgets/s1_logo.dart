// lib/shared/widgets/s1_logo.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class S1Logo extends StatelessWidget {
  final double size;
  final Color color;
  final bool useAssetImage; // Se true, usa a imagem de assets, senão usa CustomPaint

  const S1Logo({
    super.key,
    this.size = 180,
    this.color = const Color(0xFF00C2FF),
    this.useAssetImage = true, // Por padrão tenta usar a imagem
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: useAssetImage
          ? _buildAssetImage()
          : CustomPaint(
              painter: _S1LogoPainter(color),
            ),
    );
  }

  Widget _buildAssetImage() {
    try {
      return Image.asset(
        'assets/images/s1_logo.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Se a imagem não existir, usa o CustomPaint como fallback
          return CustomPaint(
            painter: _S1LogoPainter(color),
          );
        },
      );
    } catch (e) {
      // Se houver erro ao carregar, usa o CustomPaint como fallback
      return CustomPaint(
        painter: _S1LogoPainter(color),
      );
    }
  }
}
class _S1LogoPainter extends CustomPainter {
  final Color color;

  _S1LogoPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // 🔺 TRIÂNGULO
    final triangle = Path();
    triangle.moveTo(w * 0.50, h * 0.05);
    triangle.lineTo(w * 0.90, h * 0.80);
    triangle.lineTo(w * 0.10, h * 0.80);
    triangle.close();
    canvas.drawPath(triangle, paint);

    // 🌀 LETRA "S"
    final sPath = Path();
    sPath.moveTo(w * 0.30, h * 0.38);
    sPath.quadraticBezierTo(w * 0.50, h * 0.20, w * 0.70, h * 0.40);
    sPath.quadraticBezierTo(w * 0.50, h * 0.58, w * 0.30, h * 0.70);
    canvas.drawPath(sPath, paint);

    // ➖ NÚMERO "1"
    final onePath = Path();
    onePath.moveTo(w * 0.65, h * 0.35);
    onePath.lineTo(w * 0.65, h * 0.72);
    canvas.drawPath(onePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
