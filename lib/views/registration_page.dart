import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // --- Controllers for User Info ---
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _suffixController = TextEditingController();
  final _tuptIdController = TextEditingController();
  final _tupEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // --- Controllers and FocusNodes for 6 OTP TextFields ---
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _otpFocusNodes;
  String _finalOtp = '';

  String? _userType;
  String? _department;

  bool _isPasswordVisibleInStep2 = false;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(6, (index) => TextEditingController());
    _otpFocusNodes = List.generate(6, (index) => FocusNode());
  }

  @override
  void dispose() {
    // Dispose all user info controllers
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _suffixController.dispose();
    _tuptIdController.dispose();
    _tupEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    // Dispose all OTP controllers and focus nodes
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // --- Main Build Method ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: const Color(0xFF8C0404),
        title: const Text(
          'Registration',
          style: TextStyle(fontFamily: 'Nunito', color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildCurrentStep(),
          ),
        ),
      ),
    );
  }

  // --- Widget Router for Steps ---
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      default:
        return _buildStep1();
    }
  }

  // --- All the Step 1, 2, and 3 build methods remain the same ---
  // (Code for steps is omitted for brevity, but is unchanged from last time)

  // --- UPDATED STEPPER WIDGETS TO MATCH THE IMAGE ---

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStep(label: 'Step 1', isActive: _currentStep == 0, isFirst: true),
        _buildConnector(),
        _buildStep(label: 'Step 2', isActive: _currentStep == 1),
        _buildConnector(),
        _buildStep(label: 'Step 3', isActive: _currentStep == 2, isLast: true),
      ],
    );
  }

  Widget _buildStep({required String label, bool isActive = false, bool isFirst = false, bool isLast = false}) {
    // Define colors based on the image
    final Color activeColor = const Color(0xFF8C0404);
    final Color inactiveColor = Colors.grey.shade400;
    final Color inactiveCircleColor = const Color(0xFFE8D4D4);

    // Define icons for each step
    IconData getIconForStep(String stepLabel) {
      switch (stepLabel) {
        case 'Step 1':
          return Icons.person_outline;
        case 'Step 2':
          return Icons.wysiwyg;
        case 'Step 3':
          return Icons.shield_outlined;
        default:
          return Icons.circle;
      }
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: isActive ? activeColor : inactiveCircleColor,
          child: Icon(
            getIconForStep(label),
            color: Colors.white, // Icon is always white inside the circle
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 16,
            color: isActive ? Colors.black : inactiveColor,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildConnector() {
    return Expanded(
      child: Container(
        height: 1.5,
        color: Colors.grey.shade300,
        margin: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  // --- THE REST OF THE CODE IS UNCHANGED ---

  // --- STEP 1: Input Form ---
  Widget _buildStep1() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildStepper(),
          const SizedBox(height: 32),
          const Text(
            'Personal Information',
            style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            'First Name',
            controller: _firstNameController,
            isRequired: true,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            'Middle Name',
            controller: _middleNameController,
            isRequired: false,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            'Last Name',
            controller: _lastNameController,
            isRequired: true,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  'Suffix',
                  controller: _suffixController,
                  isRequired: false,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildTextField(
                  'TUPT-ID',
                  controller: _tuptIdController,
                  isRequired: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Account Setup',
            style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            'TUP Email',
            controller: _tupEmailController,
            isRequired: true,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            'Password',
            controller: _passwordController,
            obscureText: false,
            isRequired: true,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            'Confirm Password',
            controller: _confirmPasswordController,
            obscureText: false,
            isRequired: true,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildDropdown('Choose User Type')),
              const SizedBox(width: 20),
              Expanded(child: _buildDropdown('Choose Department')),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _currentStep = 1;
                  });
                }
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
    );
  }

  // --- STEP 2: Confirmation View ---
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildStepper(),
        const SizedBox(height: 32),
        const Text(
          'Personal Information',
          style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoItem('First Name', _firstNameController.text),
                        _buildInfoItem('Last Name', _lastNameController.text),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoItem(
                            'Middle Name',
                            _middleNameController.text.isNotEmpty
                                ? _middleNameController.text
                                : 'N/A'),
                        _buildInfoItem(
                            'Suffix',
                            _suffixController.text.isNotEmpty
                                ? _suffixController.text
                                : 'N/A'),
                      ],
                    ),
                  ),
                ],
              ),
              _buildInfoItem('TUP-ID', _tuptIdController.text),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Account Setup',
          style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoItem('TUP Email', _tupEmailController.text),
              _buildPasswordInfoItem('Password', _passwordController.text),
              _buildInfoItem('User Type', _userType ?? 'N/A'),
              _buildInfoItem('Department/Office', _department ?? 'N/A'),
            ],
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStep = 2; // Move to Step 3
              });
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
    );
  }

  // --- STEP 3: Email Verification ---
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Center(child: _buildStepper()),
        const SizedBox(height: 48),
        const Text(
          'Email Verification',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Enter the code sent to your TUP email for verification.',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 32),

        // Row of 6 individual text fields
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 45,
              height: 50,
              child: TextField(
                controller: _otpControllers[index],
                focusNode: _otpFocusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                cursorColor: const Color(0xFF8C0404),
                decoration: InputDecoration(
                  counterText: '', // Hide the maxLength counter
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF8C0404), width: 2),
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (value) {
                  // Auto-focus to next field when a digit is entered
                  if (value.isNotEmpty && index < 5) {
                    FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
                  }
                  // Auto-focus to previous field when a digit is deleted
                  else if (value.isEmpty && index > 0) {
                    FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
                  }
                  // Rebuild to check if button should be enabled
                  setState(() {
                    _finalOtp = _otpControllers.map((c) => c.text).join();
                  });
                },
              ),
            );
          }),
        ),

        const SizedBox(height: 24),
        Center(
          child: TextButton(
            onPressed: () {
              print("Resend code");
            },
            child: const Text(
              'Resend',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                color: Color(0xFF8C0404),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            // Enable button only when all 6 fields are filled
            onPressed: _finalOtp.length == 6
                ? () {
              print('OTP Entered: $_finalOtp');
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Success!'),
                  content: const Text('Your registration is complete.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
                : null, // Disabled if not 6 digits
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8C0404),
              disabledBackgroundColor: Colors.grey.shade400,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'REGISTER',
              style: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Helper Widgets ---

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontFamily: 'Nunito', color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Nunito',
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontFamily: 'Nunito', color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _isPasswordVisibleInStep2 ? value : '●' * value.length,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isPasswordVisibleInStep2 = !_isPasswordVisibleInStep2;
                  });
                },
                child: Icon(
                  _isPasswordVisibleInStep2
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String hintText, {
        required TextEditingController controller,
        bool obscureText = false,
        bool isRequired = true,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(fontFamily: 'Nunito', color: Colors.grey),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        validator: isRequired
            ? (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hintText';
          }
          if (hintText == 'Confirm Password' &&
              value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        }
            : null,
      ),
    );
  }

  Widget _buildDropdown(String hintText) {
    List<String> items = [];
    String? value;

    if (hintText == 'Choose User Type') {
      items = ['Faculty', 'Staff'];
      value = _userType;
    } else if (hintText == 'Choose Department') {
      items = [
        'BSAD',
        'CAAD',
        'MAAD',
        'IT',
        'SUPPLY',
        'PROCUREMENT'
      ];
      value = _department;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(
          hintText,
          style: const TextStyle(fontFamily: 'Nunito', color: Colors.grey),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding:
          EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
        validator: (value) {
          if (value == null) {
            return 'Please select an option';
          }
          return null;
        },
      ),
    );
  }
}
