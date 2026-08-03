import 'package:flutter/material.dart';

/// Centralized color configuration for the I-TRAC mobile application.
/// All colors are theme-aware — they automatically return the correct
/// value based on [isDarkMode]. Widgets just reference `AppColors.xxx`
/// and the right color is returned for the active theme.
class AppColors {
  // ---------------------------------------------------------------------------
  // THEME FLAG — set by ThemeController on init and toggle
  // ---------------------------------------------------------------------------
  static bool isDarkMode = false;

  // ===========================================================================
  // BRAND & PRIMARY COLORS
  // ===========================================================================
  /// Main university brand color (Dark Red).
  /// Slightly lighter in dark mode for visibility on dark backgrounds.
  static Color get primaryRed =>
      isDarkMode ? const Color(0xFFE7515A) : const Color(0xFFBA1A1A);

  /// Success color (Green) used in registration success, check icons, etc.
  static const Color success = Color(0xFF00C853);

  /// Error color (Red)
  static Color get error =>
      isDarkMode ? const Color(0xFFDC2626) : Colors.red;

  /// Warning accent (amber/orange)
  static Color get warningAccent =>
      isDarkMode ? const Color(0xFFE2A03F) : const Color(0xFFE2A03F);

  // ===========================================================================
  // BACKGROUND COLORS
  // ===========================================================================
  /// Main screen background (beige in light, near-black in dark)
  static Color get backgroundLight =>
      isDarkMode ? const Color(0xFF0E0F11) : const Color(0xFFF5EFE6);

  /// Card / widget surface background
  static Color get backgroundWhite =>
      isDarkMode ? const Color(0xFF15181D) : Colors.white;

  /// Surface / sidebar / dropdown background (slightly lighter than card in dark)
  static Color get surfaceBackground =>
      isDarkMode ? const Color(0xFF1D2127) : Colors.white;

  /// Transparent background
  static const Color backgroundTransparent = Colors.transparent;

  // ===========================================================================
  // NAVIGATION BAR & QR BUTTON
  // ===========================================================================
  /// Background color of the bottom navigation bar
  static Color get navBarBackground =>
      isDarkMode ? const Color(0xFF1D2127) : Colors.white;

  /// Color of icons and text in the navigation bar (on brand buttons, always white)
  static const Color navBarContent = Colors.white;

  /// Highlight/Overlay color for the selected tab in the navigation bar
  static Color get navBarHighlight =>
      isDarkMode
          ? const Color(0x33E7515A) // red tint with 20% opacity on dark
          : const Color(0x66FFFFFF); // White with 40% opacity

  /// Background color of the floating QR code button
  static Color get qrButtonBackground =>
      isDarkMode ? const Color(0xFFE7515A) : const Color(0xFFBA1A1A);

  /// Color of the icon inside the QR code button
  static const Color qrButtonIcon = Colors.white;

  // ===========================================================================
  // TEXT COLORS
  // ===========================================================================
  /// Primary text for headings and body
  static Color get textDark =>
      isDarkMode ? const Color(0xFFF3F4F6) : Colors.black87;

  /// Secondary text for descriptions
  static Color get textGrey =>
      isDarkMode ? const Color(0xFFA1A1AA) : Colors.black54;

  /// Pure black text (light) / near-white text (dark)
  static Color get textBlack =>
      isDarkMode ? const Color(0xFFF3F4F6) : Colors.black;

  /// Pure white text
  static const Color textWhite = Colors.white;

  /// Hint text color in text fields
  static Color get textHint =>
      isDarkMode ? const Color(0xFF6B7280) : Colors.grey[600]!;

  /// Muted / tertiary text
  static Color get textMuted =>
      isDarkMode ? const Color(0xFF6B7280) : Colors.grey[600]!;

  // ===========================================================================
  // BUTTON COLORS
  // ===========================================================================
  /// Background for primary elevated buttons (LOGIN, REGISTER)
  static Color get buttonPrimaryBackground =>
      isDarkMode ? const Color(0xFFE7515A) : const Color(0xFFBA1A1A);

  /// Text/Icon color for primary elevated buttons
  static const Color buttonPrimaryForeground = Colors.white;

  /// Disabled background color for buttons
  static const Color buttonDisabled = Colors.grey;

  // ===========================================================================
  // BORDERS, DIVIDERS & SHADOWS
  // ===========================================================================
  /// Standard divider color used between list items
  static Color get divider =>
      isDarkMode ? const Color(0xFF2A2F38) : const Color(0xFFEEEEEE);

  /// Border color for text fields or outlined buttons (brand-colored)
  static Color get border =>
      isDarkMode ? const Color(0xFFE7515A) : const Color(0xFFBA1A1A);

  /// Light border color for cards or subtle separators
  static Color get borderLight =>
      isDarkMode ? const Color(0xFF2A2F38) : Colors.grey.shade300;

  /// Standard shadow color for cards and floating elements
  static Color get shadow =>
      isDarkMode
          ? Colors.black.withValues(alpha: 0.4)
          : Colors.black.withValues(alpha: 0.2);

  // ===========================================================================
  // MODALS & BOTTOM SHEETS
  // ===========================================================================
  /// Background color for bottom sheets and modals
  static Color get modalBackground =>
      isDarkMode ? const Color(0xFF1D2127) : Colors.white;

  /// Handle/Indicator color at the top of bottom sheets
  static Color get modalHandle =>
      isDarkMode ? const Color(0xFF6B7280) : Colors.grey[300]!;

  // ===========================================================================
  // FORM & INPUT COLORS
  // ===========================================================================
  /// Background color for text input fields
  static Color get inputFill =>
      isDarkMode ? const Color(0xFF2A2F38) : Colors.grey[200]!;

  /// Color for active step in registration or active progress
  static Color get stepActive =>
      isDarkMode ? const Color(0xFFE7515A) : const Color(0xFFBA1A1A);

  /// Color for inactive step in registration
  static Color get stepInactive =>
      isDarkMode ? const Color(0xFF6B7280) : Colors.grey.shade400;

  // ===========================================================================
  // ITEM & STATUS COLORS
  // ===========================================================================
  /// Location icon color in item lists
  static Color get itemLocationIcon =>
      isDarkMode ? const Color(0xFF6B7280) : Colors.grey;

  // ===========================================================================
  // PALETTE COLORS
  // ===========================================================================
  /// Color of unselected items in bottom navigation
  static Color get navBarUnselected =>
      isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF908181);

  /// Color of selected highlight (pill background) in bottom navigation
  static Color get navBarSelectedHighlight =>
      isDarkMode ? const Color(0x33E7515A) : const Color(0xFFFDE8E8);

  /// Fill color of unselected category circle icons
  static Color get categoryCircleUnselected =>
      isDarkMode ? const Color(0xFF6B7280) : const Color(0xFFA7A0A0);

  /// Color of location icon and sub-text under item name
  static Color get itemLocationColor =>
      isDarkMode ? const Color(0xFFBFC9D4) : const Color(0xFF585656);

  /// Light gray outline color for the floating navbar
  static Color get navBarOutlineLight =>
      isDarkMode ? const Color(0xFF2A2F38) : const Color(0xFFD3D2D2);

  // ===========================================================================
  // CONVENIENCE GETTERS for common inline color patterns
  // ===========================================================================
  /// Search bar / filter button icon color
  static Color get iconMuted =>
      isDarkMode ? const Color(0xFFA1A1AA) : Colors.grey;

  /// Highlighted item background (e.g. recently scanned)
  static Color get highlightBackground =>
      isDarkMode ? const Color(0xFF1A3A2A) : const Color(0xFFC8E6C9);
}
