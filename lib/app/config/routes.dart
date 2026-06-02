import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/registration_controller.dart';
import '../controllers/home_controller.dart';
import '../../features/auth/registration_page.dart';
import '../../features/home/home_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/qr_scanner/qr_scanner_page.dart'; // [MVC] Added QR Scanner feature
import '../../features/archive/archive_page.dart';

// [MVC - ROUTING]
// AppRoutes is the single source of truth for all navigation in the app.
// Instead of writing MaterialPageRoute(...) scattered throughout the code,
// every screen transition goes through here.
//
// How to navigate from anywhere in the app:
//   Navigator.pushNamed(context, AppRoutes.home);
//   Navigator.pushReplacementNamed(context, AppRoutes.home);
//   Navigator.pushNamedAndRemoveUntil(context, AppRoutes.welcome, (_) => false);

class AppRoutes {
  // --- Route Name Constants ---
  // Use these constants instead of raw strings to avoid typos
  static const String welcome  = '/';
  static const String home     = '/home';
  static const String register = '/register';
  static const String profile  = '/profile';
  static const String qrScanner = '/qr-scanner'; 
  static const String archive  = '/archive';

  // --- Route Generator ---
  // Registered in MaterialApp via: onGenerateRoute: AppRoutes.generateRoute
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case home:
        // HomeController is scoped to the home route
        return _buildRoute(
          settings,
          ChangeNotifierProvider(
            create: (_) => HomeController(),
            child: const HomePage(),
          ),
        );

      case register:
        // RegistrationController is scoped to this route only.
        // Created fresh every time the user visits the Register screen.
        return _buildRoute(
          settings,
          ChangeNotifierProvider(
            create: (_) => RegistrationController(),
            child: RegistrationPage(),
          ),
        );

      case profile:
        return _buildRoute(settings, const ProfilePage());

      case qrScanner:
        // [ROUTE] QRScannerPage is a basic camera view in Phase 2
        return _buildRoute(settings, const QRScannerPage());

      case archive:
        return _buildRoute(settings, const ArchivePage());

      default:
        // Fallback screen for any unknown route
        return _buildRoute(
          settings,
          Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  // Helper: wraps a widget in a MaterialPageRoute with named settings
  static MaterialPageRoute _buildRoute(RouteSettings settings, Widget page) {
    return MaterialPageRoute(settings: settings, builder: (_) => page);
  }
}
