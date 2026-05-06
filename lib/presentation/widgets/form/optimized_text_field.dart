// File: lib/presentation/widgets/form/optimized_text_field.dart

import 'dart:async';

import 'package:flutter/material.dart';

class OptimizedTextField extends StatefulWidget {
  final String initialValue;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final int maxLines;
  final int? maxLength;
  final Function(String) onChanged;
  final VoidCallback? onEditingComplete;
  final Duration debounceDelay;
  final double? maxWidth; // ✅ ADD THIS

  const OptimizedTextField({
    super.key,
    required this.initialValue,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.maxLength,
    required this.onChanged,
    this.onEditingComplete,
    this.debounceDelay = const Duration(milliseconds: 400),
    this.maxWidth, // ✅ ADD THIS
  });

  @override
  State<OptimizedTextField> createState() => _OptimizedTextFieldState();
}

class _OptimizedTextFieldState extends State<OptimizedTextField> {
  late TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(OptimizedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  void _onChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDelay, () {
      widget.onChanged(value);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: widget.maxWidth ?? double.infinity, // ✅ ADD THIS
      ),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon)
              : null,
        ),
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        onChanged: _onChanged,
        onEditingComplete: widget.onEditingComplete,
      ),
    );
  }
}
