import 'package:flutter/material.dart';

class HolePainter extends CustomPainter {
  final Rect holeRect;

  HolePainter(this.holeRect);

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.7);

    // Draw the overlay first
    canvas.drawRect(
        Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
        backgroundPaint);

    // Save the current layer
    canvas.saveLayer(
        Rect.fromPoints(Offset.zero, Offset(size.width, size.height)), Paint());

    // Then cut out the hole
    final holePaint = Paint()..blendMode = BlendMode.clear;

    canvas.drawRect(holeRect, holePaint);

    print(holeRect);

    // Restore the layer, applying the BlendMode.clear
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
