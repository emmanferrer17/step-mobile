import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';                          // [MVC] Provider
import 'package:mobile/app/controllers/auth_controller.dart';                   // [MVC] AuthController
import 'package:mobile/app/controllers/profile_controller.dart';                // [MVC] ProfileController
import 'app/config/routes.dart';                                 // [MVC] Centralized routing
import 'app/config/size_config.dart';
import 'app/config/ui_constants.dart';

// [MVC - ENTRY POINT]
// main() wraps the app in MultiProvider so that controllers are
// available anywhere in the widget tree.
// Note: RegistrationController is scoped to its own route inside AppRoutes.
void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthController()),
      ChangeNotifierProxyProvider<AuthController, ProfileController>(
        create: (context) => ProfileController(Provider.of<AuthController>(context, listen: false)),
        update: (context, auth, previous) => ProfileController(auth),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),              // Start screen (bypasses generateRoute)
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

// [MVC - VIEW]
// WelcomePage is now a THIN view. It:
//   1. Reads state FROM the AuthController (isLoading, errorMessage)
//   2. Sends user actions TO the AuthController (login())
//   3. Does NOT contain any login business logic itself
class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // Text controllers and focus nodes stay in the View — they are purely UI concerns
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isLoginFormVisible = false;
  bool _isPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onFocusChange);
    _passwordFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() {});

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.removeListener(_onFocusChange);
    _passwordFocusNode.removeListener(_onFocusChange);
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // [MVC] The View calls the Controller — no login logic here anymore
  void _login() async {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();

    final controller = context.read<AuthController>();
    final success = await controller.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      // [MVC] Named route — AppRoutes handles building the page
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
    // If not success, the controller already set errorMessage.
    // The Consumer below will automatically rebuild to show it.
  }

  Widget _buildInitialView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 40.s),
        Text(
          'Welcome to I-TRAC',
          style: TextStyle(fontSize: 24.s, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 10.s),
        Text(
          'A Digital System for Item Status Tracking and QR-Code Enabled Material Requisition Control ',
          style: TextStyle(fontSize: 14.s, color: Colors.black54),
        ),
        SizedBox(height: 40.s),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.s),
          child: ElevatedButton(
            onPressed: () => setState(() => _isLoginFormVisible = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8C0404),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 18.s),
              textStyle: TextStyle(fontSize: 18.s, fontFamily: 'Nunito'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.s)),
            ),
            child: const Text('LOGIN'),
          ),
        ),
        SizedBox(height: 20.s),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.s),
          child: OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF8C0404),
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 18.s),
              textStyle: TextStyle(fontSize: 18.s, fontFamily: 'Nunito', fontWeight: FontWeight.bold),
              side: BorderSide(color: const Color(0xFF8C0404), width: 2.s),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.s)),
            ),
            child: const Text('REGISTER'),
          ),
        ),
      ],
    );
  }

  // [MVC] Consumer listens to AuthController and rebuilds only this form
  Widget _buildLoginForm() {
    final double fieldHeight = 50.0.s;
    final double hintFontSize = 14.0.s;

    return Consumer<AuthController>(
      builder: (context, auth, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 50.s),
            Text(
              'LOGIN',
              style: TextStyle(fontSize: 24.s, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            Text(
              'Enter your TUP email and password to login',
              style: TextStyle(fontSize: 14.s, color: Colors.black54),
            ),
            SizedBox(height: 30.s),
            // Email field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.s), // Adjust this value to reduce width
              child: SizedBox(
                height: fieldHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.s),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1.s, blurRadius: 5.s, offset: Offset(0, 3.s))],
                  ),
                  child: TextField(
                    focusNode: _emailFocusNode,
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'TUP Email',
                      hintStyle: TextStyle(fontSize: hintFontSize, color: Colors.grey[600]),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15.s, vertical: (fieldHeight - hintFontSize) / 2 - 2.s),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.s),
            // Password field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.s), // Adjust this value to reduce width
              child: SizedBox(
                height: fieldHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.s),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1.s, blurRadius: 5.s, offset: Offset(0, 3.s))],
                  ),
                  child: TextField(
                    focusNode: _passwordFocusNode,
                    controller: _passwordController,
                    obscureText: _isPasswordObscured,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(fontSize: hintFontSize, color: Colors.grey[600]),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15.s, vertical: (fieldHeight - hintFontSize) / 2 - 2.s),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordObscured ? Icons.visibility_off : Icons.visibility, color: Colors.grey[600]),
                        onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.s),
            // [MVC] Error message comes FROM the controller, not widget state
            if (auth.errorMessage != null)
              Padding(
                padding: EdgeInsets.only(bottom: 10.s),
                child: Text(
                  auth.errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 14.s),
                  textAlign: TextAlign.center,
                ),
              ),
            // [MVC] isLoading comes FROM the controller
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.s), // Adjust this value to reduce width
              child: SizedBox(
                height: fieldHeight,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8C0404),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.s),
                    textStyle: TextStyle(fontSize: 17.s, fontFamily: 'Nunito'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.s)),
                  ),
                  child: auth.isLoading
                      ? SizedBox(width: 20.s, height: 20.s, child: const CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
                      : const Text('LOGIN'),
                ),
              ),
            ),
            SizedBox(height: 20.s),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.register),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontFamily: 'Nunito', color: Colors.black),
                  children: <TextSpan>[
                    const TextSpan(text: "Don't have an account? "),
                    TextSpan(text: 'Register.', style: TextStyle(color: const Color(0xFF8C0404), fontSize: 14.s)),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final bool isKeyboardVisible = _emailFocusNode.hasFocus || _passwordFocusNode.hasFocus;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(color: Color(0xFF8C0404)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: isKeyboardVisible ? 60.s : 160.s,
              ),
              SvgPicture.asset('assets/images/i-trac-logo.svg', width: 60.s, height: 60.s, fit: BoxFit.contain),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: isKeyboardVisible ? 20.s : 120.s,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(50.s), topRight: Radius.circular(50.s)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(30.s),
                    child: SingleChildScrollView(
                      child: _isLoginFormVisible ? _buildLoginForm() : _buildInitialView(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
