import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class HexagonIcon extends StatelessWidget {
  final IconData icon;
  final Color fillColor;
  final Color iconColor;
  final double iconSize;

  const HexagonIcon({
    required this.icon,
    this.iconSize = 15,
    this.fillColor = whiteColor,
    this.iconColor = amberColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HexagonPainter(fillColor),
      child: Center(
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}

class _HexagonPainter extends CustomPainter {
  final Color bgColor;

  _HexagonPainter(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2.0;
    final double centerX = size.width / 2.0;
    final double centerY = size.height / 2.0;

    final Paint paint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;

    final Path path = Path();
    for (int i = 0; i < 6; i++) {
      final double angle = 2.0 * pi / 6 * i;
      final double x = centerX + radius * cos(angle);
      final double y = centerY + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
