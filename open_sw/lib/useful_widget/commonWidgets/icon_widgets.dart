import 'package:flutter/material.dart';


Widget IconBox({
  required IconData icon,
  required Color color,
  double size = 28.0
}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
    child: Icon(icon, color: Colors.white, size: size * 0.65,),
  );
}

class AnimatedBlinkingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const AnimatedBlinkingIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 100,
  });

  @override
  State<AnimatedBlinkingIcon> createState() => _AnimatedBlinkingIconState();
}

class _AnimatedBlinkingIconState extends State<AnimatedBlinkingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _opacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    if (mounted) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
        child: Center(
            child: ScaleTransition(
              scale: _scale,
              child: FadeTransition(
                opacity: _opacity,
                child: Icon(widget.icon, color: Colors.white, size: widget.size * 0.65,),
              ),
            )
        )
    );
  }
}
