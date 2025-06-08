import 'package:flutter/material.dart';

class TouchReactBox extends StatefulWidget {
  final Widget child;

  const TouchReactBox({super.key, required this.child});

  @override
  State<TouchReactBox> createState() => _TouchReactBoxState();
}

class _TouchReactBoxState extends State<TouchReactBox> {
  double _scale = 1.0;
  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
  }
  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }
  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        child: widget.child,
      ),
    );
  }
}
