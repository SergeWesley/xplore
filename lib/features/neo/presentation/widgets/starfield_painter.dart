import 'package:flutter/material.dart';
import 'dart:math';

class StarfieldPainter extends CustomPainter {
  final int starCount;
  final int seed;

  StarfieldPainter({this.starCount = 100, this.seed = 123});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final random = Random(seed);

    for (int i = 0; i < starCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final opacity = 0.3 + random.nextDouble() * 0.5;
      final radius = 0.5 + random.nextDouble() * 1.5;

      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
