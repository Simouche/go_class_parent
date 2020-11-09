import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_class_parent/values/Colors.dart';

class HomePagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    // paint.color = Color.fromRGBO(5, 60, 114, 1);
    paint.shader = ui.Gradient.linear(
        Offset(size.width * 0.30, size.height * 0.35),
        Offset(size.width, size.height * 0.35), [
      MAIN_COLOR_DARK,
      MAIN_COLOR_MEDIUM,
      MAIN_COLOR_LIGHT,
    ], [
      0.0,
      0.3,
      1
    ]);
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 2.0;

    var path = Path();
    path.moveTo(0, size.height * 0.30);
    path.lineTo(size.width, size.height * 0.2);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
