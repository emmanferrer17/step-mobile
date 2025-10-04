import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  int _currentStep = 0;
  String? _userType;
  String? _department;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0, // Increased the height of the AppBar
        backgroundColor: const Color(0xFF8C0404),
        title: const Text(
          'Registration',
          style: TextStyle(fontFamily: 'Nunito', color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 16.0), // Added horizontal margin
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepper(),
                const SizedBox(height: 24),
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField('First Name'),
                const SizedBox(height: 16),
                _buildTextField('Middle Name'),
                const SizedBox(height: 16),
                _buildTextField('Last Name'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Suffix')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField('TUPT-ID')),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Account Setup',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField('TUP Email'),
                const SizedBox(height: 16),
                _buildTextField('Password', obscureText: true),
                const SizedBox(height: 16),
                _buildTextField('Confirm Password', obscureText: true),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildDropdown('Choose User Type')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDropdown('Choose Department')),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle Next button press
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8C0404),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'NEXT',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStep(
            icon: Icons.person_outline, label: 'Step 1', isActive: _currentStep >= 0),
        _buildConnector(),
        _buildStep(icon: Icons.wysiwyg, label: 'Step 2', isActive: _currentStep >= 1),
        _buildConnector(),
        _buildStep(
            icon: Icons.shield_outlined, label: 'Step 3', isActive: _currentStep >= 2),
      ],
    );
  }

  Widget _buildStep(
      {required IconData icon, required String label, bool isActive = false}) {
    final Color activeColor = const Color(0xFF8C0404);
    final Color inactiveColor = Colors.grey.shade400;

    return Column(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: isActive ? activeColor : inactiveColor,
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Nunito',
            color: isActive ? activeColor : inactiveColor,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildConnector() {
    return Expanded(
      child: Container(
        height: 1,
        color: Colors.grey.shade300,
        margin: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Widget _buildTextField(String hintText, {bool obscureText = false}) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontFamily: 'Nunito', color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDropdown(String hintText) {
    List<String> items = [];
    String? value;

    if (hintText == 'Choose User Type') {
      items = ['Student', 'Faculty', 'Admin'];
      value = _userType;
    } else if (hintText == 'Choose Department') {
      items = ['Engineering', 'Science', 'Arts', 'Business'];
      value = _department;
    }

    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hintText,
          style: const TextStyle(fontFamily: 'Nunito', color: Colors.grey)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          if (hintText == 'Choose User Type') {
            _userType = newValue;
          } else if (hintText == 'Choose Department') {
            _department = newValue;
          }
        });
      },
    );
  }
}
