import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8C0404),
        title: const Text(
          'Registration',
          style: TextStyle(fontFamily: 'Nunito', color: Colors.white), // Assuming you want white text on red background
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back arrow
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Ensures other icons in AppBar are white if any
        ),
      ),
      body: Center(
        child: Text(
          'Registration Page Content Goes Here',
          style: TextStyle(fontFamily: 'Nunito', fontSize: 18),
        ),
      ),
    );
  }
}
