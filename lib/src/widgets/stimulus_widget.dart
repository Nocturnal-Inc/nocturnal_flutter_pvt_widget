import 'package:flutter/material.dart';
import 'package:psychomotor_vigilance_test/src/models/stimulus_type.dart';

/// A widget that displays the visual stimulus for the PVT.
class StimulusWidget extends StatelessWidget {
  /// Creates a stimulus widget.
  const StimulusWidget({
    super.key,
    required this.type,
    this.size = 100,
    this.color,
  });

  /// The type of stimulus to display.
  final StimulusType type;

  /// The size of the stimulus in logical pixels.
  final double size;

  /// The color of the stimulus. If null, uses the default color for the type.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? type.defaultColor;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _StimulusPainter(
          type: type,
          color: effectiveColor,
        ),
      ),
    );
  }
}

class _StimulusPainter extends CustomPainter {
  _StimulusPainter({
    required this.type,
    required this.color,
  });

  final StimulusType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    switch (type) {
      case StimulusType.circle:
        canvas.drawCircle(center, radius, paint);
        break;

      case StimulusType.square:
        canvas.drawRect(
          Rect.fromCenter(
            center: center,
            width: size.width,
            height: size.height,
          ),
          paint,
        );
        break;

      case StimulusType.cross:
        _drawCross(canvas, size, paint);
        break;

      case StimulusType.star:
        _drawStar(canvas, center, radius, paint);
        break;
    }
  }

  void _drawCross(Canvas canvas, Size size, Paint paint) {
    final strokeWidth = size.width * 0.25;
    final path = Path();

    // Horizontal bar
    path.addRect(Rect.fromLTWH(
      0,
      (size.height - strokeWidth) / 2,
      size.width,
      strokeWidth,
    ));

    // Vertical bar
    path.addRect(Rect.fromLTWH(
      (size.width - strokeWidth) / 2,
      0,
      strokeWidth,
      size.height,
    ));

    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const points = 5;
    final innerRadius = radius * 0.4;

    for (var i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : innerRadius;
      final angle = (i * 3.14159 / points) - (3.14159 / 2);
      final x = center.dx + r * _cos(angle);
      final y = center.dy + r * _sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  double _cos(double angle) => _cosApprox(angle);
  double _sin(double angle) => _sinApprox(angle);

  // Simple trig approximations to avoid dart:math in painting
  double _cosApprox(double x) {
    // Normalize to [-pi, pi]
    while (x > 3.14159) {
      x -= 6.28318;
    }
    while (x < -3.14159) {
      x += 6.28318;
    }
    // Taylor series approximation
    final x2 = x * x;
    return 1 - x2 / 2 + x2 * x2 / 24 - x2 * x2 * x2 / 720;
  }

  double _sinApprox(double x) {
    return _cosApprox(x - 1.5708); // cos(x - pi/2) = sin(x)
  }

  @override
  bool shouldRepaint(_StimulusPainter oldDelegate) {
    return type != oldDelegate.type || color != oldDelegate.color;
  }
}
