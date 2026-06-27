import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:mobile/app/controllers/auth_controller.dart';
import 'package:mobile/app/config/app_colors.dart';
import 'package:mobile/app/config/routes.dart';
import 'package:mobile/app/config/size_config.dart';
import 'package:mobile/app/config/ui_constants.dart';

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
  double _emailFontSize = 14.0; // Base font size

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onFocusChange);
    _passwordFocusNode.addListener(_onFocusChange);
    _emailController.addListener(_updateEmailFontSize);
  }

  void _onFocusChange() => setState(() {});

  void _updateEmailFontSize() {
    final double baseFontSize = 14.0.s;
    final text = _emailController.text;
    if (text.isEmpty) {
      if (_emailFontSize != baseFontSize) {
        setState(() => _emailFontSize = baseFontSize);
      }
      return;
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: baseFontSize, fontFamily: 'Nunito'),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    // Field padding is 15.s on each side, plus some margin for the container
    final availableWidth = MediaQuery.of(context).size.width - 110.s;

    if (textPainter.width > availableWidth) {
      final newSize = (baseFontSize * (availableWidth / textPainter.width)).clamp(10.0.s, baseFontSize);
      if (_emailFontSize != newSize) {
        setState(() => _emailFontSize = newSize);
      }
    } else {
      if (_emailFontSize != baseFontSize) {
        setState(() => _emailFontSize = baseFontSize);
      }
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateEmailFontSize);
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
          style: TextStyle(fontSize: 24.s, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        SizedBox(height: 10.s),
        Text(
          'A Digital System for Item Status Tracking and QR-Code Enabled Material Requisition Control ',
          style: TextStyle(fontSize: 14.s, color: AppColors.textGrey),
        ),
        SizedBox(height: 40.s),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.s),
          child: ElevatedButton(
            onPressed: () => setState(() => _isLoginFormVisible = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonPrimaryBackground,
              foregroundColor: AppColors.buttonPrimaryForeground,
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
              foregroundColor: AppColors.border,
              backgroundColor: AppColors.backgroundWhite,
              padding: EdgeInsets.symmetric(vertical: 18.s),
              textStyle: TextStyle(fontSize: 18.s, fontFamily: 'Nunito', fontWeight: FontWeight.bold),
              side: BorderSide(color: AppColors.border, width: 2.s),
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
              style: TextStyle(fontSize: 24.s, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            Text(
              'Enter your TUP email and password to login',
              style: TextStyle(fontSize: 14.s, color: AppColors.textGrey),
            ),
            SizedBox(height: 30.s),
            // Email field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.s), // Adjust this value to reduce width
              child: SizedBox(
                height: fieldHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(10.s),
                    boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.3), spreadRadius: 1.s, blurRadius: 5.s, offset: Offset(0, 3.s))],
                  ),
                  child: TextField(
                    focusNode: _emailFocusNode,
                    controller: _emailController,
                    style: TextStyle(fontSize: _emailFontSize, color: AppColors.textBlack),
                    decoration: InputDecoration(
                      hintText: 'TUP Email',
                      hintStyle: TextStyle(fontSize: hintFontSize, color: AppColors.textHint),
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
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(10.s),
                    boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.3), spreadRadius: 1.s, blurRadius: 5.s, offset: Offset(0, 3.s))],
                  ),
                  child: TextField(
                    focusNode: _passwordFocusNode,
                    controller: _passwordController,
                    obscureText: _isPasswordObscured,
                    style: TextStyle(fontSize: 14.0.s, color: AppColors.textBlack), // Added explicit font size
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(fontSize: hintFontSize, color: AppColors.textHint),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15.s, vertical: (fieldHeight - hintFontSize) / 2 - 2.s),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordObscured ? Icons.visibility_off : Icons.visibility, color: AppColors.textHint),
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
                  style: TextStyle(color: AppColors.error, fontSize: 14.s),
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
                    backgroundColor: AppColors.buttonPrimaryBackground,
                    foregroundColor: AppColors.buttonPrimaryForeground,
                    padding: EdgeInsets.symmetric(vertical: 2.s),
                    textStyle: TextStyle(fontSize: 17.s, fontFamily: 'Nunito'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.s)),
                  ),
                  child: auth.isLoading
                      ? SizedBox(width: 20.s, height: 20.s, child: const CircularProgressIndicator(strokeWidth: 3, color: AppColors.buttonPrimaryForeground))
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
                  style: const TextStyle(fontFamily: 'Nunito', color: AppColors.textBlack),
                  children: <TextSpan>[
                    const TextSpan(text: "Don't have an account? "),
                    TextSpan(text: 'Register.', style: TextStyle(color: AppColors.primaryRed, fontSize: 14.s)),
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
          decoration: const BoxDecoration(color: AppColors.primaryRed),
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
                    color: AppColors.backgroundWhite,
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
