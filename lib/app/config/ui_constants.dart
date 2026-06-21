import 'package:flutter/material.dart';
import 'size_config.dart';

class UIConstants {
  // --- Scaling Base ---
  // Adjust this to change the overall "zoom" of the app.
  // Lower value (e.g., 0.8) makes everything smaller.
  static double get globalScale => 0.90;

  // --- Spacing & Padding ---
  static double get paddingXS => 4.0 * globalScale;
  static double get paddingSmall => 8.5 * globalScale;
  static double get paddingMedium => 14.0 * globalScale;
  static double get paddingLarge => 24.0 * globalScale;
  static double get paddingXL => 32.0 * globalScale;

  // --- Icon Sizes ---
  static double get iconSmall => 21.0 * globalScale;
  static double get iconMedium => 24.0 * globalScale;
  static double get iconLarge => 32.0 * globalScale;
  static double get iconXL => 48.0 * globalScale;

  // --- Font Sizes ---
  static double get fontXS => 8.0 * globalScale;
  static double get fontSmall => 9.0 * globalScale;
  static double get fontMedium => 10.5 * globalScale;
  static double get fontLarge => 12.0 * globalScale;
  static double get fontXL => 13.0 * globalScale;
  static double get fontXXL => 14.0 * globalScale;

  // --- Navbar ---
  static double get navbarHeight => 65.0 * globalScale;
  static double get qrButtonSize => 80.0 * globalScale;
  static double get qrIconSize => 35.0 * globalScale;
}

extension UIConstantsExtension on num {
  /// Responsive scaling + Manual Global Scale override
  double get s => this * SizeConfig.scaleFactor * UIConstants.globalScale;
}
