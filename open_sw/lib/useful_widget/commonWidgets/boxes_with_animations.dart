import 'boxes_styles.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedGradientBox extends StatefulWidget {
  final Widget child;
  final double edgeRad;
  final Color shadowColor1;
  final Color shadowColor2;
  final Color backGroundColor;
  final int alpha;
  final int shadowAlpha;
  final double horizontalPadding;
  final double verticalPadding;

  const AnimatedGradientBox({
    super.key,
    required this.child,
    this.edgeRad = 20,
    this.shadowColor1 = Colors.pinkAccent,
    this.shadowColor2 = Colors.lightBlueAccent,
    this.backGroundColor = Colors.white,
    this.alpha = 100,
    this.shadowAlpha = 180,
    this.horizontalPadding = 20.0,
    this.verticalPadding = 16.0,
  });

  @override
  State<AnimatedGradientBox> createState() => _AnimatedGradientBoxState();
}

class _AnimatedGradientBoxState extends State<AnimatedGradientBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _controller.value * 2 * pi;
        final dx1 = 10 * cos(angle);
        final dy1 = 10 * sin(angle);
        final dx2 = 10 * cos(angle * 2);
        final dy2 = -10 * sin(angle * 2);

        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(widget.edgeRad),
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor1.withAlpha(widget.shadowAlpha),
                offset: Offset(dx1, dy1),
                blurRadius: 30,
                spreadRadius: 6,
              ),
              BoxShadow(
                color: widget.shadowColor2.withAlpha(widget.shadowAlpha),
                offset: Offset(dx2, dy2),
                blurRadius: 30,
                spreadRadius: 6,
              ),
            ],
          ),
          child: blurredBox(
            alpha: widget.alpha,
            topRad: widget.edgeRad,
            bottomRad: widget.edgeRad,
            horizontalPadding: widget.horizontalPadding,
            verticalPadding: widget.verticalPadding,
            backGroundColor: widget.backGroundColor,
            child: widget.child,
          ),
        );
      },
    );
  }
}
