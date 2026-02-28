import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';                          // [MVC] Provider
import 'app/controllers/auth_controller.dart';                   // [MVC] AuthController
import 'app/config/routes.dart';                                 // [MVC] Centralized routing

// [MVC - ENTRY POINT]
// main() wraps the app in MultiProvider so that controllers are
// available anywhere in the widget tree.
// Note: RegistrationController is scoped to its own route inside AppRoutes.
void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthController()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),              // Start screen (bypasses generateRoute)
      onGenerateRoute: AppRoutes.generateRoute, // [MVC] All pushNamed routes go here
      theme: ThemeData(
        fontFamily: 'Nunito',
      ),
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
        const SizedBox(height: 40),
        const Text(
          'Welcome to I-TRAC',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 10),
        const Text(
          'A Digital System for Item Status Tracking and QR-Code Enabled Material Requisition Control ',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            onPressed: () => setState(() => _isLoginFormVisible = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8C0404),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              textStyle: const TextStyle(fontSize: 18, fontFamily: 'Nunito'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('LOGIN'),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF8C0404),
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              textStyle: const TextStyle(fontSize: 18, fontFamily: 'Nunito', fontWeight: FontWeight.bold),
              side: const BorderSide(color: Color(0xFF8C0404), width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('REGISTER'),
          ),
        ),
      ],
    );
  }

  // [MVC] Consumer listens to AuthController and rebuilds only this form
  Widget _buildLoginForm() {
    const double fieldHeight = 50.0;
    const double hintFontSize = 14.0;

    return Consumer<AuthController>(
      builder: (context, auth, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 50),
            const Text(
              'LOGIN',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const Text(
              'Enter your TUP email and password to login',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            // Email field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10), // Adjust this value to reduce width
              child: SizedBox(
                height: fieldHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3))],
                  ),
                  child: TextField(
                    focusNode: _emailFocusNode,
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'TUP Email',
                      hintStyle: TextStyle(fontSize: hintFontSize, color: Colors.grey[600]),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: (fieldHeight - hintFontSize) / 2 - 2),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Password field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10), // Adjust this value to reduce width
              child: SizedBox(
                height: fieldHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3))],
                  ),
                  child: TextField(
                    focusNode: _passwordFocusNode,
                    controller: _passwordController,
                    obscureText: _isPasswordObscured,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(fontSize: hintFontSize, color: Colors.grey[600]),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: (fieldHeight - hintFontSize) / 2 - 2),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordObscured ? Icons.visibility_off : Icons.visibility, color: Colors.grey[600]),
                        onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // [MVC] Error message comes FROM the controller, not widget state
            if (auth.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  auth.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            // [MVC] isLoading comes FROM the controller
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10), // Adjust this value to reduce width
              child: SizedBox(
                height: fieldHeight,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8C0404),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    textStyle: const TextStyle(fontSize: 17, fontFamily: 'Nunito'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: auth.isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
                      : const Text('LOGIN'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.register),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(fontFamily: 'Nunito', color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: "Don't have an account? "),
                    TextSpan(text: 'Register.', style: TextStyle(color: Color(0xFF8C0404))),
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
                height: isKeyboardVisible ? 60 : 160,
              ),
              SvgPicture.asset('assets/images/i-trac-logo.svg', width: 60, height: 60, fit: BoxFit.contain),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: isKeyboardVisible ? 20 : 120,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
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
