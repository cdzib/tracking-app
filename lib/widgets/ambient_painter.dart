import 'package:flutter/material.dart';

class AmbientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFD4A853).withOpacity(0.12),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.84, size.height * 0.1),
          radius: size.width * 0.6,
        ),
      );
    canvas.drawRect(Offset.zero & size, glowPaint);

    final bluePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF1A2A4A).withOpacity(0.58),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.14, size.height * 0.78),
          radius: size.width * 0.74,
        ),
      );
    canvas.drawRect(Offset.zero & size, bluePaint);
  }

  @override
  bool shouldRepaint(AmbientPainter oldDelegate) => false;
}
