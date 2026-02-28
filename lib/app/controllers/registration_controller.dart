import 'dart:async';
import 'package:flutter/foundation.dart'; // provides ChangeNotifier
import '../../data/services/api_service.dart';
import '../../data/models/department_model.dart';

// [MVC - CONTROLLER]
// RegistrationController handles ALL registration logic.
//
// Before MVC: All of this was mixed into _RegistrationPageState (500+ lines).
//   - Step management, loading states, API calls, validation timers
//   - Everything was in one giant widget class
//
// After MVC (now): RegistrationPage just calls controller methods and
// listens for state changes. The page becomes much simpler.

class RegistrationController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // --- Step State ---
  int currentStep = 0;

  // --- Department State ---
  List<DepartmentModel> departments = [];
  bool isDepartmentsLoading = false;
  String? departmentsError;
  String? selectedDepartmentId;

  // --- User Type ---
  String? userType;

  // --- UI Feedback ---
  bool isLoading = false;
  String? errorMessage;

  // --- TUP ID Live Validation ---
  Timer? _tupIdDebounce;
  bool isTupIdChecking = false;
  bool isTupIdValid = false;
  String? tupIdError;

  // --- Email Live Validation ---
  Timer? _emailDebounce;
  bool isEmailChecking = false;
  bool isEmailValid = false;
  String? emailError;

  // --- OTP / Resend Cooldown ---
  Timer? _resendCooldownTimer;
  int resendCooldownValue = 0;
  bool isResendLoading = false;

  // ---------------------------------------------------------------
  // DEPARTMENT LOADING
  // ---------------------------------------------------------------
  Future<void> loadDepartments() async {
    isDepartmentsLoading = true;
    departmentsError = null;
    notifyListeners();

    try {
      departments = await _apiService.getDepartments();
    } catch (e) {
      departmentsError = e.toString();
    }

    isDepartmentsLoading = false;
    notifyListeners();
  }

  // ---------------------------------------------------------------
  // LIVE VALIDATION: TUP ID
  // ---------------------------------------------------------------
  void onTupIdChanged(String value) {
    if (_tupIdDebounce?.isActive ?? false) _tupIdDebounce!.cancel();
    _tupIdDebounce = Timer(
      const Duration(milliseconds: 750),
      () => _validateTupId(value),
    );
  }

  Future<void> _validateTupId(String tupId) async {
    if (tupId.length != 6) {
      isTupIdValid = false;
      tupIdError = tupId.isEmpty ? null : 'TUP ID must be 6 digits';
      notifyListeners();
      return;
    }
    isTupIdChecking = true;
    tupIdError = null;
    notifyListeners();

    final result = await _apiService.checkTupId(tupId);
    isTupIdChecking = false;
    if (result['status'] == 'success') {
      isTupIdValid = true;
      tupIdError = null;
    } else {
      isTupIdValid = false;
      tupIdError = result['message'];
    }
    notifyListeners();
  }

  // ---------------------------------------------------------------
  // LIVE VALIDATION: EMAIL
  // ---------------------------------------------------------------
  void onEmailChanged(String value) {
    if (_emailDebounce?.isActive ?? false) _emailDebounce!.cancel();
    _emailDebounce = Timer(
      const Duration(milliseconds: 750),
      () => _validateEmail(value),
    );
  }

  Future<void> _validateEmail(String email) async {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@tup\.edu\.ph$');
    if (!emailRegex.hasMatch(email)) {
      isEmailValid = false;
      emailError = email.isEmpty ? null : 'Invalid TUP email format';
      notifyListeners();
      return;
    }
    isEmailChecking = true;
    emailError = null;
    notifyListeners();

    final result = await _apiService.checkEmail(email);
    isEmailChecking = false;
    if (result['status'] == 'success') {
      isEmailValid = true;
      emailError = null;
    } else {
      isEmailValid = false;
      if (result['message'] != null &&
          (result['message'] as String).contains('unique')) {
        emailError = 'This email already exists.';
      } else {
        emailError = result['message'];
      }
    }
    notifyListeners();
  }

  // ---------------------------------------------------------------
  // STEP NAVIGATION
  // ---------------------------------------------------------------
  void goToStep(int step) {
    currentStep = step;
    notifyListeners();
  }

  void goBack() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------
  // REGISTRATION — Step 1 → Step 2
  // Returns an error string if validation fails, null if OK.
  // ---------------------------------------------------------------
  String? validateStep1() {
    if (!isTupIdValid || !isEmailValid) {
      return 'Please wait for TUP-ID and Email to be validated.';
    }
    return null; // all good — View can advance to step 2
  }

  // ---------------------------------------------------------------
  // REGISTRATION — Step 2: Send registration data to backend
  // Returns true on success (View will advance to step 3).
  // ---------------------------------------------------------------
  Future<bool> proceedToVerification(Map<String, String> userData) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _apiService.register(userData);
    isLoading = false;

    if (result['status'] == 'success') {
      currentStep = 2;
      _startResendCooldown();
      notifyListeners();
      return true;
    } else {
      errorMessage = result['message'] ?? 'An unknown server error occurred.';
      notifyListeners();
      return false;
    }
  }

  // ---------------------------------------------------------------
  // REGISTRATION — Step 3: Verify OTP
  // Returns true on success (View will show success dialog).
  // ---------------------------------------------------------------
  Future<bool> finalizeRegistration(Map<String, String> verificationData) async {
    isLoading = true;
    notifyListeners();

    final result = await _apiService.verify(verificationData);
    isLoading = false;
    notifyListeners();

    return result['status'] == 'success';
  }

  // ---------------------------------------------------------------
  // OTP RESEND
  // ---------------------------------------------------------------
  Future<String?> resendOtp(String email) async {
    if (resendCooldownValue > 0) return null;
    isResendLoading = true;
    notifyListeners();

    final result = await _apiService.resendOtp(email);
    isResendLoading = false;

    if (result['status'] == 'success') {
      _startResendCooldown();
    }
    notifyListeners();
    // Return the message so the View can show a SnackBar
    return result['message'] ?? 'An unknown error occurred.';
  }

  void _startResendCooldown() {
    _resendCooldownTimer?.cancel();
    resendCooldownValue = 60;
    _resendCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCooldownValue > 0) {
        resendCooldownValue--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  // ---------------------------------------------------------------
  // SETTERS (called by View form fields)
  // ---------------------------------------------------------------
  void setUserType(String? value) {
    userType = value;
    notifyListeners();
  }

  void setDepartmentId(String? value) {
    selectedDepartmentId = value;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  // ---------------------------------------------------------------
  // CLEANUP — cancel all timers when done
  // ---------------------------------------------------------------
  @override
  void dispose() {
    _tupIdDebounce?.cancel();
    _emailDebounce?.cancel();
    _resendCooldownTimer?.cancel();
    super.dispose();
  }
}
