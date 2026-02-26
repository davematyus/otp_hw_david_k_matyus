import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/theme_own.dart';

class AnalogClock extends StatelessWidget {
  final Duration elapsed;

  const AnalogClock({super.key, required this.elapsed});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;

        return CustomPaint(
          size: size,
          painter: _AnalogClockPainter(
            elapsed: elapsed,
            color: colors.text,
            subtle: colors.dark,
          ),
        );
      },
    );
  }
}

class _AnalogClockPainter extends CustomPainter {
  final Duration elapsed;
  final Color color;
  final Color subtle;

  _AnalogClockPainter({
    required this.elapsed,
    required this.color,
    required this.subtle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final facePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.05
      ..color = subtle;

    canvas.drawCircle(center, radius * 0.95, facePaint);

    final tickPaint = Paint()..color = subtle;
    for (int i = 0; i < 60; i++) {
      final isHour = i % 5 == 0;
      tickPaint.strokeWidth = isHour ? radius * 0.03 : radius * 0.015;

      final angle = (2 * math.pi) * (i / 60) - math.pi / 2;
      final outer =
          center + Offset(math.cos(angle), math.sin(angle)) * (radius * 0.92);
      final inner =
          center +
          Offset(math.cos(angle), math.sin(angle)) *
              (radius * (isHour ? 0.78 : 0.84));

      canvas.drawLine(inner, outer, tickPaint);
    }

    final ms = elapsed.inMilliseconds.toDouble();

    final seconds = (ms / 1000.0) % 60.0;
    final minutes = (ms / 60000.0) % 60.0;
    final hours = (ms / 3600000.0) % 12.0;

    _drawHand(
      canvas,
      center,
      radius,
      angle: _angleFromUnit(hours / 12.0),
      length: 0.55,
      width: 0.06,
      paint: Paint()
        ..color = color
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    _drawHand(
      canvas,
      center,
      radius,
      angle: _angleFromUnit(minutes / 60.0),
      length: 0.75,
      width: 0.04,
      paint: Paint()
        ..color = color
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    _drawHand(
      canvas,
      center,
      radius,
      angle: _angleFromUnit(seconds / 60.0),
      length: 0.82,
      width: 0.02,
      paint: Paint()
        ..color = color
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    canvas.drawCircle(center, radius * 0.04, Paint()..color = color);
  }

  double _angleFromUnit(double unit) {
    return 2 * math.pi * unit - math.pi / 2;
  }

  void _drawHand(
    Canvas canvas,
    Offset center,
    double radius, {
    required double angle,
    required double length,
    required double width,
    required Paint paint,
  }) {
    paint.strokeWidth = radius * width;
    final end =
        center + Offset(math.cos(angle), math.sin(angle)) * (radius * length);
    canvas.drawLine(center, end, paint);
  }

  @override
  bool shouldRepaint(covariant _AnalogClockPainter oldDelegate) {
    return oldDelegate.elapsed != elapsed ||
        oldDelegate.color != color ||
        oldDelegate.subtle != subtle;
  }
}
