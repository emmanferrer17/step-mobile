import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/services/api_service.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // --- STATE AND CONTROLLERS ---
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  final _apiService = ApiService();

  // Controllers
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

  // Dropdown state
  String? _userType;
  String? _selectedDepartmentId;

  // Department fetching state
  late Future<List<dynamic>> _departmentsFuture;
  List<dynamic> _departments = [];

  // UI Feedback
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordVisibleInStep2 = false;

  // Live Validation State
  Timer? _tupIdDebounce;
  bool _isTupIdChecking = false;
  bool _isTupIdValid = false;
  String? _tupIdError;

  Timer? _emailDebounce;
  bool _isEmailChecking = false;
  bool _isEmailValid = false;
  String? _emailError;

  // Resend OTP Cooldown State
  Timer? _resendCooldownTimer;
  int _resendCooldownValue = 0;
  bool _isResendLoading = false;

  // --- LIFECYCLE METHODS ---
  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(6, (index) => TextEditingController());
    _otpFocusNodes = List.generate(6, (index) => FocusNode());
    _loadDepartments();
    _tuptIdController.addListener(_onTupIdChanged);
    _tupEmailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _tupIdDebounce?.cancel();
    _emailDebounce?.cancel();
    _resendCooldownTimer?.cancel();
    _tuptIdController.removeListener(_onTupIdChanged);
    _tupEmailController.removeListener(_onEmailChanged);
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _suffixController.dispose();
    _tuptIdController.dispose();
    _tupEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // --- API & VALIDATION LOGIC ---

  void _onTupIdChanged() {
    if (_tupIdDebounce?.isActive ?? false) _tupIdDebounce!.cancel();
    _tupIdDebounce = Timer(const Duration(milliseconds: 750), _validateTupId);
  }

  void _onEmailChanged() {
    if (_emailDebounce?.isActive ?? false) _emailDebounce!.cancel();
    _emailDebounce = Timer(const Duration(milliseconds: 750), _validateEmail);
  }
  
  void _startResendCooldown() {
    _resendCooldownTimer?.cancel();
    setState(() => _resendCooldownValue = 60);
    _resendCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendCooldownValue > 0) {
        setState(() => _resendCooldownValue--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _resendOtp() async {
    if (_resendCooldownValue > 0) return;
    setState(() => _isResendLoading = true);
    final result = await _apiService.resendOtp(_tupEmailController.text);
    if (!mounted) return;
    setState(() => _isResendLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? 'An unknown error occurred.')),
    );
    if (result['status'] == 'success') {
      _startResendCooldown();
    }
  }

  Future<void> _validateTupId() async {
    final tupId = _tuptIdController.text;
    if (tupId.length != 6) {
      setState(() { _isTupIdValid = false; _tupIdError = tupId.isEmpty ? null : 'TUP ID must be 6 digits'; });
      return;
    }
    setState(() { _isTupIdChecking = true; _tupIdError = null; });
    final result = await _apiService.checkTupId(tupId);
    if (!mounted) return;
    setState(() {
      _isTupIdChecking = false;
      if (result['status'] == 'success') { _isTupIdValid = true; _tupIdError = null; } 
      else { _isTupIdValid = false; _tupIdError = result['message']; }
    });
  }

  Future<void> _validateEmail() async {
    final email = _tupEmailController.text;
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@tup\.edu\.ph$').hasMatch(email)) {
      setState(() { _isEmailValid = false; _emailError = email.isEmpty ? null : 'Invalid TUP email format'; });
      return;
    }
    setState(() { _isEmailChecking = true; _emailError = null; });
    final result = await _apiService.checkEmail(email);
    if (!mounted) return;
    setState(() {
      _isEmailChecking = false;
      if (result['status'] == 'success') { _isEmailValid = true; _emailError = null; } 
      else { _isEmailValid = false; _emailError = result['message']; }
    });
  }

  void _loadDepartments() {
    _departmentsFuture = _apiService.getDepartments();
  }

  Future<void> _proceedToVerification() async {
    // FIX: Removed the redundant and faulty validation check.
    // The user can only get to this step if the form was valid on Step 1.
    setState(() { _isLoading = true; _errorMessage = null; });
    final userData = { 'user_firstname': _firstNameController.text, 'user_middlename': _middleNameController.text, 'user_lastname': _lastNameController.text, 'user_suffix': _suffixController.text, 'user_tupid': _tuptIdController.text, 'user_email': _tupEmailController.text, 'user_password': _passwordController.text, 'user_type': _userType ?? '', 'selected_department_id': _selectedDepartmentId ?? '', };
    final result = await _apiService.register(userData);
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (result['status'] == 'success') {
      setState(() => _currentStep = 2);
      _startResendCooldown();
    } else {
      setState(() => _errorMessage = result['message'] ?? 'An unknown server error occurred.');
    }
  }

  Future<void> _finalizeRegistration() async {
    setState(() => _isLoading = true);
    _finalOtp = _otpControllers.map((c) => c.text).join();
    final verificationData = { 'otp': _finalOtp, 'user_firstname': _firstNameController.text, 'user_middlename': _middleNameController.text, 'user_lastname': _lastNameController.text, 'user_suffix': _suffixController.text, 'user_tupid': _tuptIdController.text, 'user_email': _tupEmailController.text, 'user_password': _passwordController.text, 'user_type': _userType ?? '', 'selected_department_id': _selectedDepartmentId ?? '', };
    final result = await _apiService.verify(verificationData);
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (result['status'] == 'success') {
      showDialog(
        context: context, barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Registration Successful!'),
          content: const Text('You can now log in with your new account.'),
          actions: [ TextButton(onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), child: const Text('OK')), ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? 'An unknown error occurred.')));
    }
  }

  // --- UI & WIDGETS ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: const Color(0xFF8C0404),
        title: const Text('Registration', style: TextStyle(fontFamily: 'Nunito', color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() { _currentStep--; });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildCurrentStep(),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _buildStep1();
      case 1: return _buildStep2();
      case 2: return _buildStep3();
      default: return _buildStep1();
    }
  }
  
  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStep(label: 'Step 1', isActive: _currentStep == 0),
        _buildConnector(),
        _buildStep(label: 'Step 2', isActive: _currentStep == 1),
        _buildConnector(),
        _buildStep(label: 'Step 3', isActive: _currentStep == 2),
      ],
    );
  }

  Widget _buildStep({required String label, bool isActive = false}) {
    final Color activeColor = const Color(0xFF8C0404);
    final Color inactiveColor = Colors.grey.shade400;
    IconData getIconForStep(String stepLabel) {
      switch (stepLabel) {
        case 'Step 1': return Icons.person_outline;
        case 'Step 2': return Icons.wysiwyg;
        case 'Step 3': return Icons.shield_outlined;
        default: return Icons.circle;
      }
    }
    return Row(
      children: [
        CircleAvatar(radius: 15, backgroundColor: isActive ? activeColor : inactiveColor, child: Icon(getIconForStep(label), color: Colors.white, size: 16)),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontFamily: 'Nunito', fontSize: 16, color: isActive ? Colors.black : inactiveColor, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildConnector() {
    return Expanded(child: Container(height: 1.5, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 8)));
  }

  Widget _buildStep1() {
    bool isNextButtonEnabled = (_formKey.currentState?.validate() ?? false) && _isTupIdValid && _isEmailValid;
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () => setState(() {}),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16), _buildStepper(), const SizedBox(height: 32),
          const Text('Personal Information', style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 24),
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
                  decoration: InputDecoration(hintText: 'TUPT-ID', filled: true, fillColor: Colors.grey[200], border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), errorText: _tupIdError, suffixIcon: _buildValidationIcon(_isTupIdChecking, _isTupIdValid, _tupIdError)),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  validator: (value) => (value == null || value.isEmpty) ? 'Required' : (value.length != 6) ? 'Must be 6 digits' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text('Account Setup', style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 24),
          TextFormField(
            controller: _tupEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: 'TUP Email', filled: true, fillColor: Colors.grey[200], border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), errorText: _emailError, suffixIcon: _buildValidationIcon(_isEmailChecking, _isEmailValid, _emailError)),
            validator: (value) => (value == null || value.isEmpty) ? 'Required' : (!RegExp(r'^[a-zA-Z0-9._%+-]+@tup\.edu\.ph$').hasMatch(value)) ? 'Invalid TUP email' : null,
          ),
          const SizedBox(height: 20),
          _buildTextField('Password', controller: _passwordController, obscureText: true),
          const SizedBox(height: 20),
          _buildTextField('Confirm Password', controller: _confirmPasswordController, obscureText: true),
          const SizedBox(height: 20),
          Row(children: [Expanded(child: _buildUserTypeDropdown()), const SizedBox(width: 20), Expanded(child: _buildDepartmentDropdown())]),
          const SizedBox(height: 40),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: isNextButtonEnabled ? () => setState(() => _currentStep = 1) : null, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8C0404), disabledBackgroundColor: Colors.grey.shade400, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Next', style: TextStyle(fontFamily: 'Nunito', color: Colors.white, fontSize: 18)))),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    String departmentName = 'N/A';
    if (_selectedDepartmentId != null) {
      final selectedDept = _departments.firstWhere((d) => d['dep_id'].toString() == _selectedDepartmentId, orElse: () => null);
      if (selectedDept != null) departmentName = selectedDept['dep_name'];
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16), _buildStepper(), const SizedBox(height: 32),
        if (_errorMessage != null) Padding(padding: const EdgeInsets.only(bottom: 16.0), child: Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 16)))),
        const Text('Personal Information', style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 24),
        Padding(padding: const EdgeInsets.only(left: 20.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildInfoItem('Name', '${_firstNameController.text} ${_middleNameController.text} ${_lastNameController.text} ${_suffixController.text}'.trim()), _buildInfoItem('TUP-ID', _tuptIdController.text)])),
        const SizedBox(height: 16),
        const Text('Account Setup', style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 24),
        Padding(padding: const EdgeInsets.only(left: 20.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildInfoItem('TUP Email', _tupEmailController.text), _buildPasswordInfoItem('Password', _passwordController.text), _buildInfoItem('User Type', _userType ?? 'N/A'), _buildInfoItem('Department/Office', departmentName)])),
        const SizedBox(height: 40),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _isLoading ? null : _proceedToVerification, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8C0404), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) : const Text('Proceed to Email Verification', style: TextStyle(fontFamily: 'Nunito', color: Colors.white, fontSize: 18)))),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16), Center(child: _buildStepper()), const SizedBox(height: 48),
        const Text('Email Verification', style: TextStyle(fontFamily: 'Nunito', fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 12),
        const Text('Enter the code sent to your TUP email for verification.', style: TextStyle(fontFamily: 'Nunito', fontSize: 16, color: Colors.grey)), const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) => SizedBox(
            width: 40, height: 50,
            child: TextFormField(controller: _otpControllers[index], focusNode: _otpFocusNodes[index], textAlign: TextAlign.center, keyboardType: TextInputType.number, maxLength: 1, decoration: const InputDecoration(counterText: '', border: OutlineInputBorder()),
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
          child: _isResendLoading
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8C0404)))) 
            : TextButton(
                onPressed: _resendCooldownValue > 0 ? null : _resendOtp,
                child: Text(
                  _resendCooldownValue > 0 ? 'Resend in ${_resendCooldownValue}s' : 'Resend',
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 16, color: _resendCooldownValue > 0 ? Colors.grey : const Color(0xFF8C0404), fontWeight: FontWeight.bold),
                ),
              ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: (_finalOtp.length == 6 && !_isLoading) ? _finalizeRegistration : null, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8C0404), disabledBackgroundColor: Colors.grey.shade400, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) : const Text('REGISTER', style: TextStyle(fontFamily: 'Nunito', color: Colors.white, fontSize: 18)))),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 140, child: Text('$label:', style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold))), Expanded(child: Text(value, style: const TextStyle(fontFamily: 'Nunito')))]),
    );
  }

  Widget _buildPasswordInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 140, child: Text('$label:', style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold))), Expanded(child: Text(_isPasswordVisibleInStep2 ? value : '•' * value.length, style: const TextStyle(fontFamily: 'Nunito'))), IconButton(icon: Icon(_isPasswordVisibleInStep2 ? Icons.visibility_off : Icons.visibility, size: 20), onPressed: () => setState(() => _isPasswordVisibleInStep2 = !_isPasswordVisibleInStep2), padding: EdgeInsets.zero, constraints: const BoxConstraints())]),
    );
  }

  Widget _buildTextField(String hintText, {required TextEditingController controller, bool obscureText = false, bool isRequired = true, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(hintText: hintText, filled: true, fillColor: Colors.grey[200], border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        if (hintText == 'Password' && (value?.length ?? 0) < 8) {
          return 'Password must be at least 8 characters';
        }
        if (hintText == 'Confirm Password' && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildUserTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _userType, hint: const Text('Choose User Type', style: TextStyle(fontFamily: 'Nunito', color: Colors.grey)),
      decoration: InputDecoration(filled: true, fillColor: Colors.grey[200], border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
      items: ['Faculty', 'Staff'].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
      onChanged: (newValue) => setState(() => _userType = newValue),
      validator: (value) => value == null ? 'Please select an option' : null,
    );
  }

  Widget _buildDepartmentDropdown() {
    return FutureBuilder<List<dynamic>>(
      future: _departmentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          _departments = snapshot.data!;
          return DropdownButtonFormField<String>(
            value: _selectedDepartmentId, isExpanded: true, hint: const Text('Choose Department', style: TextStyle(fontFamily: 'Nunito', color: Colors.grey)),
            decoration: InputDecoration(filled: true, fillColor: Colors.grey[200], border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
            items: _departments.map((department) => DropdownMenuItem<String>(value: department['dep_id'].toString(), child: Text(department['dep_name']))).toList(),
            onChanged: (newValue) => setState(() => _selectedDepartmentId = newValue),
            validator: (value) => value == null ? 'Please select a department' : null,
          );
        }
        return const Text('No departments found.');
      },
    );
  }

  Widget? _buildValidationIcon(bool isChecking, bool isValid, String? error) {
    if (isChecking) return const Padding(padding: EdgeInsets.all(12.0), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF8C0404))));
    if (isValid && error == null) return const Icon(Icons.check_circle, color: Colors.green);
    if (error != null) return const Icon(Icons.error, color: Colors.red);
    return null;
  }
}
