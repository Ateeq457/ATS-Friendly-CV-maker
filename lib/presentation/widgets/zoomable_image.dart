import 'package:flutter/material.dart';

class ZoomableImage extends StatefulWidget {
  final Widget child;
  final double maxScale;

  const ZoomableImage({super.key, required this.child, this.maxScale = 4.0});

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  final TransformationController _transformationController =
      TransformationController();
  TapDownDetails? _tapDownDetails;

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _tapDownDetails?.localPosition;
      _transformationController.value = Matrix4.identity()
        ..translate(
          -position!.dx * (widget.maxScale - 1),
          -position.dy * (widget.maxScale - 1),
        )
        ..scale(widget.maxScale);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (details) {
        _tapDownDetails = details;
        _handleDoubleTap();
      },
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 0.8,
        maxScale: widget.maxScale,
        child: widget.child,
      ),
    );
  }
}
