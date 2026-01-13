import 'package:flutter/material.dart';

/// A widget that smoothly animates background color changes
/// without restarting animations on rebuild
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({
    required this.color,
    this.duration = const Duration(milliseconds: 700),
    this.curve = Curves.easeInOut,
    super.key,
  });

  final Color color;
  final Duration duration;
  final Curve curve;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Color _previousColor;
  late Color _targetColor;

  @override
  void initState() {
    super.initState();
    _previousColor = widget.color;
    _targetColor = widget.color;

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _colorAnimation =
        ColorTween(
          begin: _previousColor,
          end: _targetColor,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: widget.curve,
          ),
        );
  }

  @override
  void didUpdateWidget(AnimatedBackground oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.color != widget.color) {
      // Store current animated color as the starting point
      _previousColor = _colorAnimation.value ?? widget.color;
      _targetColor = widget.color;

      // Create new animation from current color to new color
      _colorAnimation =
          ColorTween(
            begin: _previousColor,
            end: _targetColor,
          ).animate(
            CurvedAnimation(
              parent: _controller,
              curve: widget.curve,
            ),
          );

      // Restart animation from the beginning
      _controller
        ..reset()
        ..forward();
    }

    // Update duration if changed
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return ColoredBox(
          color: _colorAnimation.value ?? widget.color,
          child: const SizedBox.expand(),
        );
      },
    );
  }
}
