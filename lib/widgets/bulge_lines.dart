import 'package:flutter/material.dart';

class BulgedLinePainter extends CustomPainter {
  final Color color;
  final bool bulgeUpward;

  BulgedLinePainter({
    required this.color,
    this.bulgeUpward = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final midY = size.height / 2;
    const bulgeHeight = 4; // reduce bulge depth for better fit

    final startY = bulgeUpward ? midY - bulgeHeight / 2 : midY + bulgeHeight / 2;
    final endY = startY;

    // Start at left edge
    path.moveTo(0, startY);

    // Curve to right
    path.quadraticBezierTo(
      size.width / 2,
      bulgeUpward ? midY - bulgeHeight : midY + bulgeHeight,
      size.width,
      endY,
    );

    // Close and fill to bottom baseline
    path.lineTo(size.width, midY + 0.5);
    path.lineTo(0, midY + 0.5);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
