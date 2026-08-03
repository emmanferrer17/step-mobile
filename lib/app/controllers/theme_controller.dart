import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_colors.dart';

/// Controller to handle and persist theme state (Light/Dark mode).
/// Registered as a ChangeNotifierProvider in main.dart so any widget
/// can read or toggle the current theme.
class ThemeController extends ChangeNotifier {
  bool _isDarkMode = false;

  /// Whether the app is currently in dark mode.
  bool get isDarkMode => _isDarkMode;

  /// Initialize theme from stored settings, default to light mode.
  /// Must be called before runApp().
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('is_dark_mode') ?? false;
      AppColors.isDarkMode = _isDarkMode;
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
      _isDarkMode = false;
      AppColors.isDarkMode = false;
    }
  }

  /// Toggle between light and dark mode.
  /// Updates AppColors, persists the preference, and notifies listeners
  /// so the entire widget tree rebuilds with the new colors.
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    AppColors.isDarkMode = _isDarkMode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_dark_mode', _isDarkMode);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }
}
