import 'package:flutter/material.dart';
import 'dart:math';

import 'package:scraphive/utils/colors.dart';

class HexagonSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  HexagonSlider({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        overlayColor: Colors.transparent,
        activeTrackColor: amberColor.withOpacity(0.7),
        inactiveTrackColor: yellowColor,
        thumbColor: amberColor,
        thumbShape: HexagonSliderThumbShape(),
        activeTickMarkColor: Colors.transparent,
        inactiveTickMarkColor: Colors.transparent,
      ),
      child: Slider(
        value: value,
        onChanged: onChanged,
        min: 0,
        max: 100,
        divisions: 20,
      ),
    );
  }
}

class HexagonSliderThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(12); // Adjust the size of the hexagon thumb
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final double radius = 12;
    final double sideLength = radius * sqrt(3);
    final double centerX = center.dx;
    final double centerY = center.dy;

    final Paint paint = Paint()..color = sliderTheme.thumbColor!;

    final Path path = Path()
      ..moveTo(centerX, centerY - radius)
      ..lineTo(centerX + sideLength / 2, centerY - radius / 2)
      ..lineTo(centerX + sideLength / 2, centerY + radius / 2)
      ..lineTo(centerX, centerY + radius)
      ..lineTo(centerX - sideLength / 2, centerY + radius / 2)
      ..lineTo(centerX - sideLength / 2, centerY - radius / 2)
      ..close();

    canvas.drawPath(path, paint);
  }
}
