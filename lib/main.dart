import 'package:flutter/material.dart';
import 'package:provider/provider.dart';                          // [MVC] Provider
import 'package:mobile/app/controllers/auth_controller.dart';                   // [MVC] AuthController
import 'package:mobile/app/controllers/profile_controller.dart';                // [MVC] ProfileController
import 'package:mobile/app/controllers/home_controller.dart';
import 'package:mobile/features/shared/widgets/main_scaffold.dart';
import 'package:mobile/features/auth/welcome_page.dart';
import 'app/config/routes.dart';                                 // [MVC] Centralized routing

// [MVC - ENTRY POINT]
// main() wraps the app in MultiProvider so that controllers are
// available anywhere in the widget tree.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authController = AuthController();
  await authController.checkSession();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authController),
        ChangeNotifierProxyProvider<AuthController, ProfileController>(
          create: (context) => ProfileController(Provider.of<AuthController>(context, listen: false)),
          update: (context, auth, previous) => ProfileController(auth),
        ),
      ],
      child: MaterialApp(
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
        ),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling,
            ),
            child: child!,
          );
        },
      ),
    ),
  );
}
