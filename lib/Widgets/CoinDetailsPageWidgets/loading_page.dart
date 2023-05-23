import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const LoadingScreen());
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingPage(),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage('images/black.png'),
              width: 300,
            ),
            SizedBox(height: 10,),
            CustomCircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}

class CustomCircularProgressIndicator extends StatefulWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const CustomCircularProgressIndicator({super.key,
    this.size = 40.0,
    this.color = Colors.white12,
    this.strokeWidth = 4.0,
  });

  @override
  _CustomCircularProgressIndicatorState createState() =>
      _CustomCircularProgressIndicatorState();
}

class _CustomCircularProgressIndicatorState
    extends State<CustomCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _CustomCircularProgressIndicatorPainter(
              progress: _controller.value,
              color: widget.color,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _CustomCircularProgressIndicatorPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CustomCircularProgressIndicatorPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (strokeWidth / 2);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CustomCircularProgressIndicatorPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
