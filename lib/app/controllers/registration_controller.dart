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
    // New Format: XXXX0-00-0000 (13 characters)
    final tupIdRegex = RegExp(r'^[A-Z]{4}\d-\d{2}-\d{4}$');
    if (!tupIdRegex.hasMatch(tupId)) {
      isTupIdValid = false;
      tupIdError = tupId.isEmpty ? null : 'Invalid TUP-ID format (e.g., INST1-23-0252)';
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
  // DEPARTMENT GROUPING
  // ---------------------------------------------------------------
  Map<String, List<DepartmentModel>> get groupedDepartments {
    final Map<String, List<DepartmentModel>> groups = {
      "Director's Office & Direct Services": [],
      "Assistant Director For Administration And Finance Office": [],
      "Assistant Director for Research and Extension Office": [],
      "Assistant Director for Academic Affairs Office": [],
    };

    const directorsOfficeId = 35;
    const adminFinanceId = 40;
    const researchExtensionId = 38;
    const academicAffairsId = 36;

    // Helper to find a specific department by ID
    DepartmentModel? findDept(int id) {
      try {
        return departments.firstWhere((d) => d.id == id);
      } catch (_) {
        return null;
      }
    }

    // 1. Director's Office & Direct Services
    final directorParent = findDept(directorsOfficeId);
    if (directorParent != null) {
      groups["Director's Office & Direct Services"]!.add(directorParent);
      final children = departments.where((d) {
        final pId = d.parentId;
        return pId == directorsOfficeId && ![adminFinanceId, researchExtensionId, academicAffairsId].contains(d.id);
      }).toList();
      children.sort((a, b) => a.name.compareTo(b.name));
      groups["Director's Office & Direct Services"]!.addAll(children);
    }

    // 2. Assistant Director For Administration And Finance Office
    final adminFinanceParent = findDept(adminFinanceId);
    if (adminFinanceParent != null) {
      groups["Assistant Director For Administration And Finance Office"]!.add(adminFinanceParent);
      final children = departments.where((d) {
        final pId = d.parentId;
        return pId == adminFinanceId;
      }).toList();
      children.sort((a, b) => a.name.compareTo(b.name));
      groups["Assistant Director For Administration And Finance Office"]!.addAll(children);
    }

    // 3. Assistant Director for Research and Extension Office
    final researchExtensionParent = findDept(researchExtensionId);
    if (researchExtensionParent != null) {
      groups["Assistant Director for Research and Extension Office"]!.add(researchExtensionParent);
      final children = departments.where((d) {
        final pId = d.parentId;
        return pId == researchExtensionId;
      }).toList();
      children.sort((a, b) => a.name.compareTo(b.name));
      groups["Assistant Director for Research and Extension Office"]!.addAll(children);
    }

    // 4. Assistant Director for Academic Affairs Office
    final academicAffairsParent = findDept(academicAffairsId);
    if (academicAffairsParent != null) {
      groups["Assistant Director for Academic Affairs Office"]!.add(academicAffairsParent);
      final children = departments.where((d) {
        final pId = d.parentId;
        return pId == academicAffairsId;
      }).toList();
      children.sort((a, b) => a.name.compareTo(b.name));
      groups["Assistant Director for Academic Affairs Office"]!.addAll(children);
    }

    // Remove empty groups if any
    groups.removeWhere((key, value) => value.isEmpty);

    return groups;
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
