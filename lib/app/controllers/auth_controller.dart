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
  String? token; // holds the auth token for secure API requests

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
      if (result['data'] != null && result['data']['user'] != null) {
        try {
          loggedInUser = UserModel.fromMap(result['data']['user']);
          token = result['data']['access_token'];
        } catch (e) {
          debugPrint('Error parsing user data: $e');
          errorMessage = 'Parse error: $e';
          notifyListeners();
          return false;
        }
      } else {
        errorMessage = 'No user object returned from API. Raw data: ${result['data']}';
        notifyListeners();
        return false;
      }
      notifyListeners();
      return true; // signal success to the View → View will then navigate
    } else {
      errorMessage = result['message'] ?? 'An unknown error occurred.';
      notifyListeners(); // tells the View to rebuild and show the error message
      return false;
    }
  }

  // Helper used by ProfileController to update the UI globally
  void updateUserLocally(UserModel user) {
    loggedInUser = user;
    notifyListeners();
  }

  // Clears the error message (e.g., when the user starts typing again)
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  // --- Logout Logic ---
  // Clears the user state and calls the API to invalidate the token.
  Future<void> logout() async {
    if (token != null) {
      // Call the API service to revoke the token on the backend
      await _apiService.logout(token!);
    }
    // Clear local state
    loggedInUser = null;
    token = null;
    errorMessage = null;
    notifyListeners();
  }
}
