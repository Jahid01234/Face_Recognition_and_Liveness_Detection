import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FacePainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;

  FacePainter(this.faces, this.imageSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // 🔹 scale factor
    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    // 🔹 center offset (VERY IMPORTANT)
    final offsetX = (size.width - imageSize.width * scale) / 2;
    final offsetY = (size.height - imageSize.height * scale) / 2;

    for (final face in faces) {
      final rect = Rect.fromLTRB(
        face.boundingBox.left * scale + offsetX,
        face.boundingBox.top * scale + offsetY,
        face.boundingBox.right * scale + offsetX,
        face.boundingBox.bottom * scale + offsetY,
      );

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}