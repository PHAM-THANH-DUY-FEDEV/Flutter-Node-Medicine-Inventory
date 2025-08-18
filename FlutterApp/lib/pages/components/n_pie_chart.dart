import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vtmath;
import 'dart:math' as math;

class NPieChart extends StatefulWidget {
  const NPieChart({
    super.key,
    this.radius = 100.0,
    this.expired = 18,
    this.available = 2,
    this.outOfStock = 3,
    this.nearExpiry = 1,
    this.textSize = 16.0,
    this.strokeWidth = 2.0,
    this.duration = const Duration(seconds: 1),
  });

  final double radius;
  final int expired;
  final int available;
  final int outOfStock;
  final int nearExpiry;
  final double textSize;
  final double strokeWidth;
  final Duration duration;

  @override
  State<NPieChart> createState() => _NPieChartState();
}

class _NPieChartState extends State<NPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.fromRadius(widget.radius),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _ProgressPainter(
              strokeWidth: widget.strokeWidth,
              expired: widget.expired,
              available: widget.available,
              outOfStock: widget.outOfStock,
              nearExpiry: widget.nearExpiry,
              progress: _animation.value,
            ),
          );
        },
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  const _ProgressPainter({
    required this.strokeWidth,
    required this.expired,
    required this.available,
    required this.outOfStock,
    required this.nearExpiry,
    required this.progress,
  });

  final double strokeWidth;
  final int expired;
  final int available;
  final int outOfStock;
  final int nearExpiry;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final total = expired + available + outOfStock + nearExpiry;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paints = {
      'expired':
          Paint()
            ..color = Colors.red.shade300
            ..style = PaintingStyle.fill
            ..strokeWidth = strokeWidth,
      'available':
          Paint()
            ..color = Colors.green.shade300
            ..style = PaintingStyle.fill
            ..strokeWidth = strokeWidth,
      'outOfStock':
          Paint()
            ..color = Colors.grey
            ..style = PaintingStyle.fill
            ..strokeWidth = strokeWidth,
      'nearExpiry':
          Paint()
            ..color = Colors.yellow.shade300
            ..style = PaintingStyle.fill
            ..strokeWidth = strokeWidth,
    };

    double startAngle = vtmath.radians(-90);
    double totalAngle = 2 * math.pi * progress;

    void drawSegment(int value, Paint paint, String label) {
      final sweepAngle = (value / total) * 2 * math.pi;
      if (totalAngle > 0) {
        final actualSweep = sweepAngle.clamp(0.0, totalAngle);
        canvas.drawArc(rect, startAngle, actualSweep, true, paint);

        // ignore: prefer_interpolation_to_compose_strings
        final percent = (value / total * 100).toStringAsFixed(0) + '%';
        final midAngle = startAngle + actualSweep / 2;
        final textRadius = radius * 0.7;
        final textOffset = Offset(
          center.dx + textRadius * math.cos(midAngle),
          center.dy + textRadius * math.sin(midAngle),
        );

        // Vẽ text phần trăm
        final textPainter = TextPainter(
          text: TextSpan(
            text: percent,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final offset =
            textOffset - Offset(textPainter.width / 2, textPainter.height / 2);
        textPainter.paint(canvas, offset);

        startAngle += actualSweep;
        totalAngle -= actualSweep;
      }
    }

    drawSegment(expired, paints['expired']!, 'expired');
    drawSegment(available, paints['available']!, 'available');
    drawSegment(outOfStock, paints['outOfStock']!, 'outOfStock');
    drawSegment(nearExpiry, paints['nearExpiry']!, 'nearExpiry');
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
