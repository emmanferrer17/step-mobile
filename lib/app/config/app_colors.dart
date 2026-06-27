import 'package:flutter/material.dart';

/// Centralized color configuration for the I-TRAC mobile application.
/// Tweak these values to change the look and feel of the app from a single place.
class AppColors {
  // ===========================================================================
  // BRAND & PRIMARY COLORS
  // ===========================================================================
  /// Main university brand color (Dark Red)
  static const Color primaryRed = Color(0xFFBA1A1A);

  /// Success color (Green) used in registration success, check icons, etc.
  static const Color success = Color(0xFF00C853);

  /// Error color (Red) used in error icons, error text, etc.
  static const Color error = Colors.red;

  // ===========================================================================
  // BACKGROUND COLORS
  // ===========================================================================
  /// Light beige background used in Home and Archive screens
  static const Color backgroundLight = Color(0xFFF5EFE6);

  /// Pure white background used in many containers and cards
  static const Color backgroundWhite = Colors.white;

  /// Transparent background
  static const Color backgroundTransparent = Colors.transparent;

  // ===========================================================================
  // NAVIGATION BAR & QR BUTTON
  // ===========================================================================
  /// Background color of the bottom navigation bar
  static const Color navBarBackground = Color(0xFFBA1A1A);

  /// Color of icons and text in the navigation bar
  static const Color navBarContent = Colors.white;

  /// Highlight/Overlay color for the selected tab in the navigation bar
  static const Color navBarHighlight = Color.fromARGB(102, 255, 255, 255); // White with 40% opacity

  /// Background color of the floating QR code button
  static const Color qrButtonBackground = Color(0xFFBA1A1A);

  /// Color of the icon inside the QR code button
  static const Color qrButtonIcon = Colors.white;

  // ===========================================================================
  // TEXT COLORS
  // ===========================================================================
  /// Standard dark text for headings and body
  static const Color textDark = Colors.black87;

  /// Lighter grey text for secondary information/descriptions
  static const Color textGrey = Colors.black54;

  /// Pure black text
  static const Color textBlack = Colors.black;

  /// Pure white text
  static const Color textWhite = Colors.white;

  /// Hint text color in text fields
  static final Color textHint = Colors.grey[600]!;

  // ===========================================================================
  // BUTTON COLORS
  // ===========================================================================
  /// Background for primary elevated buttons (LOGIN, REGISTER)
  static const Color buttonPrimaryBackground = Color(0xFFBA1A1A);

  /// Text/Icon color for primary elevated buttons
  static const Color buttonPrimaryForeground = Colors.white;

  /// Disabled background color for buttons
  static const Color buttonDisabled = Colors.grey;

  // ===========================================================================
  // BORDERS, DIVIDERS & SHADOWS
  // ===========================================================================
  /// Standard divider color used between list items
  static const Color divider = Color(0xFFEEEEEE);

  /// Border color for text fields or outlined buttons
  static const Color border = Color(0xFFBA1A1A);

  /// Light border color for cards or subtle separators
  static final Color borderLight = Colors.grey.shade300;

  /// Standard shadow color for cards and floating elements
  static final Color shadow = Colors.black.withValues(alpha: 0.2);

  // ===========================================================================
  // MODALS & BOTTOM SHEETS
  // ===========================================================================
  /// Background color for bottom sheets and modals
  static const Color modalBackground = Colors.white;

  /// Handle/Indicator color at the top of bottom sheets
  static final Color modalHandle = Colors.grey[300]!;

  // ===========================================================================
  // FORM & INPUT COLORS
  // ===========================================================================
  /// Background color for text input fields
  static final Color inputFill = Colors.grey[200]!;

  /// Color for active step in registration or active progress
  static const Color stepActive = Color(0xFFBA1A1A);

  /// Color for inactive step in registration
  static final Color stepInactive = Colors.grey.shade400;

  // ===========================================================================
  // ITEM & STATUS COLORS
  // ===========================================================================
  /// Location icon color in item lists
  static const Color itemLocationIcon = Colors.grey;

  // ===========================================================================
  // NEW PALETTE COLORS
  // ===========================================================================
  /// Color of unselected items in bottom navigation
  static const Color navBarUnselected = Color(0xFF908181);

  /// Color of selected highlight (pill background) in bottom navigation
  static const Color navBarSelectedHighlight = Color(0xFFFDE8E8);

  /// Fill color of unselected category circle icons
  static const Color categoryCircleUnselected = Color(0xFFA7A0A0);

  /// Color of location icon and sub-text under item name
  static const Color itemLocationColor = Color(0xFF585656);

  /// Light gray outline color for the floating navbar
  static const Color navBarOutlineLight = Color(0xFFD3D2D2);
}
