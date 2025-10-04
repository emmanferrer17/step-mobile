import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'data/services/api_service.dart';
import 'features/auth/registration_page.dart';
import 'features/home/home_page.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WelcomePage(), // Renamed for clarity
    theme: ThemeData(
      fontFamily: 'Nunito', // Global font family
    ),
  ),
);

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // Controllers for the text fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();

  bool _isLoginFormVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // The login logic is now in its own function
  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _apiService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['status'] == 'success') {
      // Navigate to a new screen on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // Show an error message on failure
      setState(() {
        _errorMessage = result['message'] ?? 'An unknown error occurred.';
      });
    }
  }

  Widget _buildInitialView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 40),
        const Text(
          'Lorem Ipsum',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isLoginFormVisible = true;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8C0404),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            textStyle: const TextStyle(fontSize: 18, fontFamily: 'Nunito'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('LOGIN'),
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistrationPage()),
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF8C0404),
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            textStyle: const TextStyle(fontSize: 18, fontFamily: 'Nunito', fontWeight: FontWeight.bold),
            side: const BorderSide(
              color: Color(0xFF8C0404),
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('REGISTER'),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    const double fieldHeight = 50.0;
    const double hintFontSize = 14.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 50),
        const Text(
          'LOGIN',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Text(
          'Enter your TUP email and password to login',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: fieldHeight,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Or a slightly off-white if needed for contrast
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow to be at the bottom
                ),
              ],
            ),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'TUP Email',
                hintStyle: TextStyle(fontSize: hintFontSize, color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: (fieldHeight - hintFontSize) / 2 - 2), // Adjust vertical padding carefully
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: fieldHeight,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow to be at the bottom
                ),
              ],
            ),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(fontSize: hintFontSize, color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: (fieldHeight - hintFontSize) / 2 - 2), // Adjust vertical padding carefully
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        SizedBox(
          height: fieldHeight,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8C0404),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 2),
              textStyle: const TextStyle(
                fontSize: 17,
                fontFamily: 'Nunito',
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: _isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
                : const Text('LOGIN'),
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
             Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistrationPage()),
            );
          },
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(fontFamily: 'Nunito'), // Default style for the RichText
              children: <TextSpan>[
                TextSpan(
                  text: "Don\'t have an account? ",
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: 'Register.',
                  style: TextStyle(
                    color: Color(0xFF8C0404),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF8C0404),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 160),
            SvgPicture.asset(
              'assets/images/step-logo.svg',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 120),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: SingleChildScrollView(
                     child: _isLoginFormVisible ? _buildLoginForm() : _buildInitialView(),
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
