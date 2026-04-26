import 'package:flutter/material.dart';

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double elevation;
  final double scale;

  const AnimatedCard({
    super.key,
    required this.child,
    required this.onTap,
    this.elevation = 0,
    this.scale = 0.97,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  double _scale = 1.0;
  double _elevation = 0;

  @override
  void initState() {
    super.initState();
    _elevation = widget.elevation;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _scale = widget.scale;
          _elevation = 0;
        });
      },
      onTapUp: (_) {
        setState(() {
          _scale = 1.0;
          _elevation = widget.elevation;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _scale = 1.0;
          _elevation = widget.elevation;
        });
      },
      child: Transform.scale(
        scale: _scale,
        child: Material(
          elevation: _elevation,
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
          child: widget.child,
        ),
      ),
    );
  }
}
