import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
    theme: ThemeData(
      fontFamily: 'Nunito', // Global font family
    ),
  ),
);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoginFormVisible = false;

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
            // TODO: Implement Register navigation/view change
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
                  offset: Offset(0, 3), // changes position of shadow to be at the bottom
                ),
              ],
            ),
            child: TextField(
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
                  offset: Offset(0, 3), // changes position of shadow to be at the bottom
                ),
              ],
            ),
            child: TextField(
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
        SizedBox(
          height: fieldHeight,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement actual login logic
            },
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
            child: const Text('LOGIN'),
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            // TODO: Navigate to Register or switch view.
          },
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(fontFamily: 'Nunito'), // Default style for the RichText
              children: <TextSpan>[
                TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: 'Register.',
                  style: TextStyle(
                    color: Color(0xFF8C0404),
                  ),
                  // TODO: Add a recognizer here if you want only "Register." to be clickable
                  // recognizer: TapGestureRecognizer()..onTap = () {
                  //   // Handle Register tap
                  // },
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
