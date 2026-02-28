import 'package:flutter/material.dart';
import 'package:provider/provider.dart';                          // [MVC] Provider
import '../../app/controllers/registration_controller.dart';     // [MVC] Controller
import '../../data/models/department_model.dart';                // [MVC] Typed model

// [MVC - VIEW]
// RegistrationPage is now a THIN view. It:
//   1. Reads state FROM RegistrationController (currentStep, isLoading, etc.)
//   2. Sends user actions TO RegistrationController (proceedToVerification(), etc.)
//   3. Does NOT contain any registration or validation business logic itself
//
// Text controllers stay in the View — they are purely UI concerns
// (managing what the user types on screen).

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // --- UI-only form controllers (belong in the View) ---
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _suffixController = TextEditingController();
  final _tuptIdController = TextEditingController();
  final _tupEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _otpFocusNodes;
  String _finalOtp = '';

  // UI-only display toggles
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _isPasswordVisibleInStep2 = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(6, (_) => TextEditingController());
    _otpFocusNodes = List.generate(6, (_) => FocusNode());

    // [MVC] Load departments via Controller on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegistrationController>().loadDepartments();
    });

    // [MVC] Notify Controller when TUP-ID or email changes
    _tuptIdController.addListener(
      () => context.read<RegistrationController>().onTupIdChanged(_tuptIdController.text),
    );
    _tupEmailController.addListener(
      () => context.read<RegistrationController>().onEmailChanged(_tupEmailController.text),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _suffixController.dispose();
    _tuptIdController.dispose();
    _tupEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    for (var c in _otpControllers) c.dispose();
    for (var f in _otpFocusNodes) f.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------
  // STEP 1 → STEP 2: Validate then ask controller to advance
  // ---------------------------------------------------------------
  void _goToNextStep() {
    if (_formKey.currentState!.validate()) {
      final reg = context.read<RegistrationController>();
      final error = reg.validateStep1();
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      } else {
        reg.goToStep(1);
      }
    } else {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    }
  }

  // ---------------------------------------------------------------
  // STEP 2 → STEP 3: Send registration data via Controller
  // ---------------------------------------------------------------
  Future<void> _proceedToVerification() async {
    final reg = context.read<RegistrationController>();
    final userData = {
      'user_firstname': _firstNameController.text,
      'user_middlename': _middleNameController.text,
      'user_lastname': _lastNameController.text,
      'user_suffix': _suffixController.text,
      'user_tupid': _tuptIdController.text,
      'user_email': _tupEmailController.text,
      'user_password': _passwordController.text,
      'user_type': reg.userType ?? '',
      'selected_department_id': reg.selectedDepartmentId ?? '',
    };
    await reg.proceedToVerification(userData);
    // Controller updates currentStep — Consumer rebuilds automatically
  }

  // ---------------------------------------------------------------
  // STEP 3: Finalize OTP via Controller
  // ---------------------------------------------------------------
  Future<void> _finalizeRegistration() async {
    final reg = context.read<RegistrationController>();
    _finalOtp = _otpControllers.map((c) => c.text).join();
    final verificationData = {
      'otp': _finalOtp,
      'user_firstname': _firstNameController.text,
      'user_middlename': _middleNameController.text,
      'user_lastname': _lastNameController.text,
      'user_suffix': _suffixController.text,
      'user_tupid': _tuptIdController.text,
      'user_email': _tupEmailController.text,
      'user_password': _passwordController.text,
      'user_type': reg.userType ?? '',
      'selected_department_id': reg.selectedDepartmentId ?? '',
    };
    final success = await reg.finalizeRegistration(verificationData);
    if (!mounted) return;
    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Registration Successful!'),
          content: const Text('You can now log in with your new account.'),
          actions: [TextButton(onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), child: const Text('OK'))],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(reg.errorMessage ?? 'An unknown error occurred.')),
      );
    }
  }

  // ---------------------------------------------------------------
  // BUILD — Consumer wraps the entire body to react to controller changes
  // ---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Consumer<RegistrationController>(
      builder: (context, reg, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80.0,
            backgroundColor: const Color(0xFF8C0404),
            title: const Text('Registration', style: TextStyle(fontFamily: 'Nunito', color: Colors.white)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (reg.currentStep > 0) {
                  reg.goBack();
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildCurrentStep(reg),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentStep(RegistrationController reg) {
    switch (reg.currentStep) {
      case 0: return _buildStep1(reg);
      case 1: return _buildStep2(reg);
      case 2: return _buildStep3(reg);
      default: return _buildStep1(reg);
    }
  }

  // ---------------------------------------------------------------
  // STEPPER UI
  // ---------------------------------------------------------------
  Widget _buildStepper(int currentStep) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepIndicator(label: 'Step 1', isActive: currentStep == 0),
        _buildConnector(),
        _buildStepIndicator(label: 'Step 2', isActive: currentStep == 1),
        _buildConnector(),
        _buildStepIndicator(label: 'Step 3', isActive: currentStep == 2),
      ],
    );
  }

  Widget _buildStepIndicator({required String label, bool isActive = false}) {
    final Color activeColor = const Color(0xFF8C0404);
    final Color inactiveColor = Colors.grey.shade400;
    IconData icon;
    switch (label) {
      case 'Step 1': icon = Icons.person_outline; break;
      case 'Step 2': icon = Icons.wysiwyg; break;
      default: icon = Icons.shield_outlined;
    }
    return Row(children: [
      CircleAvatar(radius: 15, backgroundColor: isActive ? activeColor : inactiveColor, child: Icon(icon, color: Colors.white, size: 16)),
      const SizedBox(width: 8),
      Text(label, style: TextStyle(fontFamily: 'Nunito', fontSize: 16, color: isActive ? Colors.black : inactiveColor, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
    ]);
  }

  Widget _buildConnector() =>
      Expanded(child: Container(height: 1.5, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 8)));

  // ---------------------------------------------------------------
  // STEP 1 — Personal info + account setup form
  // ---------------------------------------------------------------
  Widget _buildStep1(RegistrationController reg) {
    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildStepper(reg.currentStep),
          const SizedBox(height: 32),
          const Text('Personal Information', style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildTextField('First Name', controller: _firstNameController),
          const SizedBox(height: 20),
          _buildTextField('Middle Name', controller: _middleNameController),
          const SizedBox(height: 20),
          _buildTextField('Last Name', controller: _lastNameController),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildTextField('Suffix', controller: _suffixController, isRequired: false)),
              const SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  controller: _tuptIdController,
                  decoration: InputDecoration(
                    hintText: 'TUPT-ID',
                    filled: true, fillColor: Colors.grey[200],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    // [MVC] Validation state read from controller
                    errorText: reg.tupIdError,
                    suffixIcon: _buildValidationIcon(reg.isTupIdChecking, reg.isTupIdValid, reg.tupIdError),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : (v.length != 6) ? 'Must be 6 digits' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text('Account Setup', style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          TextFormField(
            controller: _tupEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'TUP Email',
              filled: true, fillColor: Colors.grey[200],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              // [MVC] Email validation state read from controller
              errorText: reg.emailError,
              suffixIcon: _buildValidationIcon(reg.isEmailChecking, reg.isEmailValid, reg.emailError),
            ),
            validator: (v) => (v == null || v.isEmpty) ? 'Required' : (!RegExp(r'^[a-zA-Z0-9._%+-]+@tup\.edu\.ph$').hasMatch(v)) ? 'Invalid TUP email' : null,
          ),
          const SizedBox(height: 20),
          _buildPasswordTextField('Password', controller: _passwordController, isObscured: _isPasswordObscured, onToggle: () => setState(() => _isPasswordObscured = !_isPasswordObscured)),
          const SizedBox(height: 20),
          _buildPasswordTextField('Confirm Password', controller: _confirmPasswordController, isObscured: _isConfirmPasswordObscured, onToggle: () => setState(() => _isConfirmPasswordObscured = !_isConfirmPasswordObscured)),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: _buildUserTypeDropdown(reg)),
            const SizedBox(width: 20),
            Expanded(child: _buildDepartmentDropdown(reg)),
          ]),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _goToNextStep,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8C0404), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('Next', style: TextStyle(fontFamily: 'Nunito', color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // STEP 2 — Review before submitting
  // ---------------------------------------------------------------
  Widget _buildStep2(RegistrationController reg) {
    String departmentName = 'N/A';
    if (reg.selectedDepartmentId != null) {
      final matches = reg.departments.where((d) => d.id.toString() == reg.selectedDepartmentId);
      if (matches.isNotEmpty) departmentName = matches.first.name;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildStepper(reg.currentStep),
        const SizedBox(height: 32),
        // [MVC] Error message from controller
        if (reg.errorMessage != null)
          Padding(padding: const EdgeInsets.only(bottom: 16.0), child: Center(child: Text(reg.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 16)))),
        const Text('Personal Information', style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildInfoItem('Name', '${_firstNameController.text} ${_middleNameController.text} ${_lastNameController.text} ${_suffixController.text}'.trim()),
            _buildInfoItem('TUP-ID', _tuptIdController.text),
          ]),
        ),
        const SizedBox(height: 16),
        const Text('Account Setup', style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildInfoItem('TUP Email', _tupEmailController.text),
            _buildPasswordInfoItem('Password', _passwordController.text),
            _buildInfoItem('User Type', reg.userType ?? 'N/A'),
            _buildInfoItem('Department/Office', departmentName),
          ]),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            // [MVC] isLoading from controller
            onPressed: reg.isLoading ? null : _proceedToVerification,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8C0404), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: reg.isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                : const Text('Proceed to Email Verification', style: TextStyle(fontFamily: 'Nunito', color: Colors.white, fontSize: 18)),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------
  // STEP 3 — OTP Verification
  // ---------------------------------------------------------------
  Widget _buildStep3(RegistrationController reg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Center(child: _buildStepper(reg.currentStep)),
        const SizedBox(height: 48),
        const Text('Email Verification', style: TextStyle(fontFamily: 'Nunito', fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const Text('Enter the code sent to your TUP email for verification.', style: TextStyle(fontFamily: 'Nunito', fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) => SizedBox(
            width: 42, height: 52,
            child: TextFormField(
              controller: _otpControllers[index],
              focusNode: _otpFocusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: const TextStyle(fontSize: 22, fontFamily: 'Nunito', fontWeight: FontWeight.bold),
              decoration: const InputDecoration(counterText: '', border: OutlineInputBorder(), contentPadding: EdgeInsets.zero),
              onChanged: (value) {
                if (value.isNotEmpty && index < 5) _otpFocusNodes[index + 1].requestFocus();
                if (value.isEmpty && index > 0) _otpFocusNodes[index - 1].requestFocus();
                setState(() => _finalOtp = _otpControllers.map((c) => c.text).join());
              },
            ),
          )),
        ),
        const SizedBox(height: 24),
        Center(
          child: reg.isResendLoading
              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8C0404))))
              : TextButton(
                  // [MVC] Cooldown state from controller
                  onPressed: reg.resendCooldownValue > 0 ? null : () async {
                    final msg = await reg.resendOtp(_tupEmailController.text);
                    if (mounted && msg != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                    }
                  },
                  child: Text(
                    reg.resendCooldownValue > 0 ? 'Resend in ${reg.resendCooldownValue}s' : 'Resend',
                    style: TextStyle(fontFamily: 'Nunito', fontSize: 16, color: reg.resendCooldownValue > 0 ? Colors.grey : const Color(0xFF8C0404), fontWeight: FontWeight.bold),
                  ),
                ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_finalOtp.length == 6 && !reg.isLoading) ? _finalizeRegistration : null,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8C0404), disabledBackgroundColor: Colors.grey.shade400, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: reg.isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                : const Text('REGISTER', style: TextStyle(fontFamily: 'Nunito', color: Colors.white, fontSize: 18)),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------
  // REUSABLE FIELD WIDGETS
  // ---------------------------------------------------------------
  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 140, child: Text('$label:', style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold))),
        Expanded(child: Text(value, style: const TextStyle(fontFamily: 'Nunito'))),
      ]),
    );
  }

  Widget _buildPasswordInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 140, child: Text('$label:', style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold))),
        Expanded(child: Text(_isPasswordVisibleInStep2 ? value : '•' * value.length, style: const TextStyle(fontFamily: 'Nunito'))),
        IconButton(icon: Icon(_isPasswordVisibleInStep2 ? Icons.visibility_off : Icons.visibility, size: 20), onPressed: () => setState(() => _isPasswordVisibleInStep2 = !_isPasswordVisibleInStep2), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
      ]),
    );
  }

  Widget _buildTextField(String hintText, {required TextEditingController controller, bool isRequired = true}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText, filled: true, fillColor: Colors.grey[200], border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
      validator: (v) => (isRequired && (v == null || v.isEmpty)) ? 'This field is required' : null,
    );
  }

  Widget _buildPasswordTextField(String hintText, {required TextEditingController controller, required bool isObscured, required VoidCallback onToggle}) {
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      decoration: InputDecoration(
        hintText: hintText, filled: true, fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: IconButton(icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility), onPressed: onToggle),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'This field is required';
        if (hintText == 'Password' && v.length < 8) return 'Password must be at least 8 characters';
        if (hintText == 'Confirm Password' && v != _passwordController.text) return 'Passwords do not match';
        return null;
      },
    );
  }

  // [MVC] User type is stored in controller, not widget state
  Widget _buildUserTypeDropdown(RegistrationController reg) {
    return DropdownButtonFormField<String>(
      value: reg.userType,
      hint: const Text('Choose User Type', style: TextStyle(fontFamily: 'Nunito', color: Colors.grey)),
      decoration: InputDecoration(filled: true, fillColor: Colors.grey[200], border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
      items: ['Faculty', 'Staff'].map((v) => DropdownMenuItem<String>(value: v, child: Text(v))).toList(),
      onChanged: reg.setUserType,
      validator: (v) => v == null ? 'Please select an option' : null,
    );
  }

  // [MVC] Department list comes from controller, not FutureBuilder
  Widget _buildDepartmentDropdown(RegistrationController reg) {
    if (reg.isDepartmentsLoading) return const Center(child: CircularProgressIndicator());
    if (reg.departmentsError != null) return Text('Error: ${reg.departmentsError}');
    if (reg.departments.isEmpty) return const Text('No departments found.');

    return DropdownButtonFormField<String>(
      value: reg.selectedDepartmentId,
      isExpanded: true,
      hint: const Text('Choose Department', style: TextStyle(fontFamily: 'Nunito', color: Colors.grey)),
      decoration: InputDecoration(filled: true, fillColor: Colors.grey[200], border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
      items: reg.departments.map((DepartmentModel d) => DropdownMenuItem<String>(value: d.id.toString(), child: Text(d.name))).toList(),
      onChanged: reg.setDepartmentId,
      validator: (v) => v == null ? 'Please select a department' : null,
    );
  }

  Widget? _buildValidationIcon(bool isChecking, bool isValid, String? error) {
    if (isChecking) return const Padding(padding: EdgeInsets.all(12.0), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF8C0404))));
    if (isValid && error == null) return const Icon(Icons.check_circle, color: Colors.green);
    if (error != null) return const Icon(Icons.error, color: Colors.red);
    return null;
  }
}
