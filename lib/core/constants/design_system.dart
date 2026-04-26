import 'package:flutter/material.dart';

class DesignSystem {
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXLarge = 20;
  static const double radiusXXLarge = 24;
  static const double radiusCircular = 30;

  static const double paddingSmall = 8;
  static const double paddingMedium = 12;
  static const double paddingLarge = 16;
  static const double paddingXLarge = 20;
  static const double paddingXXLarge = 24;

  // No shadows
  static List<BoxShadow> subtleShadow = [];
  static List<BoxShadow> mediumShadow = [];

  static BoxDecoration cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.circular(radiusLarge),
      boxShadow: [],
    );
  }
}
