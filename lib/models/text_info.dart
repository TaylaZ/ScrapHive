import 'package:flutter/material.dart';

class TextInfo {
  String text;
  double left;
  double top;
  Color color;
  FontWeight fontWeight;
  FontStyle fontStyle;
  double fontSize;
  TextAlign textAlign;
  double rotation; // Add this property for text rotation

  TextInfo({
    required this.text,
    required this.left,
    required this.top,
    required this.color,
    required this.fontWeight,
    required this.fontStyle,
    required this.fontSize,
    required this.textAlign,
    this.rotation = 0.0, // Initialize rotation with 0 degrees
  });
}
