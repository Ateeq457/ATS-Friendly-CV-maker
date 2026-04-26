import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    required this.action,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onActionTap,
          child: Text(
            action,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
