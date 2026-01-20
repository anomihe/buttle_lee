import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProductivityRing extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final bool animate;

  const ProductivityRing({
    super.key,
    required this.progress,
    this.size = 40,
    this.strokeWidth = 4,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    // Determine colors based on progress
    final Color progressColor;
    if (progress >= 1.0) {
      progressColor = Colors.greenAccent;
    } else if (progress >= 0.7) {
      progressColor = Colors.tealAccent;
    } else if (progress >= 0.4) {
      progressColor = Colors.orangeAccent;
    } else {
      progressColor = Colors.redAccent;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
          ),
          // Progress ring
          SizedBox(
            width: size,
            height: size,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: strokeWidth,
                  strokeCap: StrokeCap.round,
                  color: progressColor,
                );
              },
            ),
          ),
          // Percentage Text
          if (progress > 0)
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress * 100),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return Text(
                  '${value.toInt()}%',
                  style: TextStyle(
                    fontSize: size * 0.25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            ),

          // Completion ripple effect
          if (progress >= 1.0)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: progressColor.withOpacity(0.5), width: 2),
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.4, 1.4),
                    duration: 1.5.seconds)
                .fadeOut(duration: 1.5.seconds),
        ],
      ),
    );
  }
}
