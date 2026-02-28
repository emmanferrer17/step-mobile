import 'package:flutter/foundation.dart'; // provides ChangeNotifier
import '../../data/services/api_service.dart';
import '../../data/models/user_model.dart';

// [MVC - CONTROLLER]
// AuthController handles ALL login logic.
//
// Before MVC: The login logic lived inside _WelcomePageState in main.dart.
//   - isLoading, errorMessage were widget state variables
//   - _login() was a method directly inside the widget
//
// After MVC (now): The View (WelcomePage) just calls controller.login()
// and listens for changes. The View no longer needs to know HOW login works.

class AuthController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // --- State variables (moved out of the Widget) ---
  bool isLoading = false;
  String? errorMessage;
  UserModel? loggedInUser; // holds the user data after successful login

  // --- Login Logic (moved out of _WelcomePageState._login()) ---
  // Returns true if login was successful, false otherwise.
  // The View uses the return value to decide whether to navigate.
  Future<bool> login(String email, String password) async {
    // Clear any previous error and show loading spinner
    isLoading = true;
    errorMessage = null;
    notifyListeners(); // tells the View to rebuild and show the spinner

    final result = await _apiService.login(email, password);

    isLoading = false;

    if (result['status'] == 'success') {
      // Optionally store logged-in user data if the API returns it
      if (result['data'] != null) {
        try {
          loggedInUser = UserModel.fromMap(result['data']);
        } catch (_) {
          // If the response format differs, we just skip storing the user
        }
      }
      notifyListeners();
      return true; // signal success to the View → View will then navigate
    } else {
      errorMessage = result['message'] ?? 'An unknown error occurred.';
      notifyListeners(); // tells the View to rebuild and show the error message
      return false;
    }
  }

  // Clears the error message (e.g., when the user starts typing again)
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
