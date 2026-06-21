import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/registration_controller.dart';
import '../controllers/home_controller.dart';
import '../../features/auth/registration_page.dart';
import '../../features/qr_scanner/qr_scanner_page.dart'; 
import '../../features/archive/archive_page.dart';
import '../../features/shared/widgets/main_scaffold.dart';

class AppRoutes {
  static const String welcome  = '/';
  static const String home     = '/home';
  static const String register = '/register';
  static const String profile  = '/profile';
  static const String qrScanner = '/qr-scanner'; 
  static const String archive  = '/archive';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        // Note: WelcomePage is now defined in main.dart or imported if moved
        // For now we assume it's the home property of MaterialApp
        return _buildRoute(settings, Container()); 

      case home:
        return _buildRoute(
          settings,
          ChangeNotifierProxyProvider<AuthController, HomeController>(
            create: (context) => HomeController(Provider.of<AuthController>(context, listen: false)),
            update: (context, auth, previous) => HomeController(auth),
            child: const MainScaffold(initialIndex: 0),
          ),
        );

      case profile:
        return _buildRoute(settings, const MainScaffold(initialIndex: 1));

      case register:
        return _buildRoute(
          settings,
          ChangeNotifierProvider(
            create: (_) => RegistrationController(),
            child: RegistrationPage(),
          ),
        );

      case qrScanner:
        return _buildRoute(settings, const QRScannerPage());

      case archive:
        return _buildRoute(settings, const ArchivePage());

      default:
        return _buildRoute(
          settings,
          Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static MaterialPageRoute _buildRoute(RouteSettings settings, Widget page) {
    return MaterialPageRoute(settings: settings, builder: (_) => page);
  }
}
