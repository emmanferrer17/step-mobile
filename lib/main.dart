import 'package:flutter/material.dart';
import 'package:provider/provider.dart';                          // [MVC] Provider
import 'package:mobile/app/controllers/auth_controller.dart';                   // [MVC] AuthController
import 'package:mobile/app/controllers/profile_controller.dart';                // [MVC] ProfileController
import 'package:mobile/app/controllers/home_controller.dart';
import 'package:mobile/app/controllers/theme_controller.dart';
import 'package:mobile/features/shared/widgets/main_scaffold.dart';
import 'package:mobile/features/auth/welcome_page.dart';
import 'app/config/app_colors.dart';
import 'app/config/routes.dart';                                 // [MVC] Centralized routing

// [MVC - ENTRY POINT]
// main() wraps the app in MultiProvider so that controllers are
// available anywhere in the widget tree.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize theme from stored preference before building the UI
  final themeController = ThemeController();
  await themeController.init();

  final authController = AuthController();
  await authController.checkSession();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeController),
        ChangeNotifierProvider.value(value: authController),
        ChangeNotifierProxyProvider<AuthController, ProfileController>(
          create: (context) => ProfileController(Provider.of<AuthController>(context, listen: false)),
          update: (context, auth, previous) => ProfileController(auth),
        ),
      ],
      // Consumer<ThemeController> ensures MaterialApp rebuilds when theme toggles
      child: Consumer<ThemeController>(
        builder: (context, theme, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Consumer<AuthController>(
              builder: (context, auth, _) {
                return auth.isLoggedIn
                    ? ChangeNotifierProxyProvider<AuthController, HomeController>(
                        create: (context) => HomeController(auth),
                        update: (context, auth, previous) => HomeController(auth),
                        child: const MainScaffold(initialIndex: 0),
                      )
                    : WelcomePage();
              },
            ),
            onGenerateRoute: AppRoutes.generateRoute, // [MVC] All pushNamed routes go here
            theme: ThemeData(
              fontFamily: 'Nunito',
              scaffoldBackgroundColor: AppColors.backgroundLight,
              canvasColor: AppColors.backgroundLight,
            ),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.noScaling,
                ),
                child: child!,
              );
            },
          );
        },
      ),
    ),
  );
}
