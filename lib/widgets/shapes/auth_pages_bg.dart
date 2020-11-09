import 'package:flutter/material.dart';
import 'package:go_class_parent/values/Colors.dart';

class AuthPagesTopBG extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = CUSTOM_PAINT_LIGHT_COLOR;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 2.0;

    var path = Path();
    path.moveTo(size.width * 0.90, 0);
    path.quadraticBezierTo(
        size.width * 0.60, size.height * 0.3, 0, size.height * 0.185);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);

    var paint2 = Paint();
    paint2.color = CUSTOM_PAINT_DARK_COLOR;
    paint2.style = PaintingStyle.fill;
    paint2.strokeWidth = 2.0;

    var path2 = Path();
    path2.moveTo(size.width * 0.55, 0);
    path2.quadraticBezierTo(
        size.width * 0.60, size.height * 0.20, size.width, size.height * 0.20);
    path2.lineTo(size.width, 0);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
