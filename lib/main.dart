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

  // Focus Nodes to detect when a field is selected for keyboard animation
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isLoginFormVisible = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordObscured = true; // For password toggle

  @override
  void initState() {
    super.initState();
    // Add listeners to trigger a rebuild when focus changes for the animation
    _emailFocusNode.addListener(_onFocusChange);
    _passwordFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    // This just forces a rebuild to update the layout based on focus
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    // Clean up focus node listeners and nodes
    _emailFocusNode.removeListener(_onFocusChange);
    _passwordFocusNode.removeListener(_onFocusChange);
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  // The login logic is now in its own function
  void _login() async {
    // Hide keyboard before processing login
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _apiService.login(
      _emailController.text,
      _passwordController.text,
    );
    
    if (!mounted) return; // Check if the widget is still in the widget tree

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
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3), 
                ),
              ],
            ),
            child: TextField(
              focusNode: _emailFocusNode, // Attach focus node
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
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              focusNode: _passwordFocusNode, // Attach focus node
              controller: _passwordController,
              obscureText: _isPasswordObscured, // Use state variable
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(fontSize: hintFontSize, color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: (fieldHeight - hintFontSize) / 2 - 2),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordObscured = !_isPasswordObscured;
                    });
                  },
                ),
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
            text: const TextSpan(
              style: TextStyle(fontFamily: 'Nunito', color: Colors.black), 
              children: <TextSpan>[
                TextSpan(
                  text: "Don't have an account? ",
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
    final bool isKeyboardVisible = _emailFocusNode.hasFocus || _passwordFocusNode.hasFocus;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height, // Ensure it takes full screen height
          decoration: const BoxDecoration(
            color: Color(0xFF8C0404),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: isKeyboardVisible ? 60 : 160,
              ),
              SvgPicture.asset(
                'assets/images/step-logo.svg',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
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
      ),
    );
  }
}
