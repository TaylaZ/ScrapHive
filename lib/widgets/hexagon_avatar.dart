import 'package:flutter/material.dart';
import 'dart:math';

class HexagonClipper extends CustomClipper<Path> {
  final double radius;

  HexagonClipper(this.radius);

  @override
  Path getClip(Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    Path path = Path()
      ..moveTo(centerX + radius * cos(0), centerY + radius * sin(0));

    for (int i = 1; i <= 6; i++) {
      double angle = 2.0 * pi / 6 * i;
      path.lineTo(centerX + radius * cos(angle), centerY + radius * sin(angle));
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class HexagonAvatar extends StatelessWidget {
  final double radius;
  final ImageProvider image;

  HexagonAvatar({
    required this.radius,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HexagonClipper(radius),
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: image,
          ),
        ),
      ),
    );
  }
}
