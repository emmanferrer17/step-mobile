import 'dart:convert';
import 'package:flutter/foundation.dart'; // provides ChangeNotifier
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/services/api_service.dart';
import '../../data/models/user_model.dart';

// [MVC - CONTROLLER]
// AuthController handles ALL login logic.
class AuthController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // --- State variables ---
  bool isLoading = false;
  String? errorMessage;
  UserModel? loggedInUser; // holds the user data after successful login
  String? token; // holds the auth token for secure API requests

  // Getter to check if user is currently logged in
  bool get isLoggedIn => loggedInUser != null && token != null;

  // Checks if there's a stored session and loads it if valid (under 30 days)
  Future<void> checkSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('auth_token');
      final storedUserJson = prefs.getString('auth_user');
      final storedLoginTimeStr = prefs.getString('auth_login_time');

      if (storedToken == null || storedUserJson == null || storedLoginTimeStr == null) {
        await clearSession();
        return;
      }

      final loginTime = DateTime.parse(storedLoginTimeStr);
      final difference = DateTime.now().difference(loginTime);
      if (difference > const Duration(days: 30)) {
        // Session expired, clear stored session
        await clearSession();
        return;
      }

      // Valid session, load data into state variables
      token = storedToken;
      loggedInUser = UserModel.fromMap(json.decode(storedUserJson));
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading stored session: $e');
      await clearSession();
    }
  }

  // Helper to persist the session details
  Future<void> saveSession(String token, UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('auth_user', json.encode(user.toMap()));
      await prefs.setString('auth_login_time', DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('Error saving session: $e');
    }
  }

  // Helper to clear session variables and local storage
  Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('auth_user');
      await prefs.remove('auth_login_time');
    } catch (e) {
      debugPrint('Error clearing session: $e');
    } finally {
      token = null;
      loggedInUser = null;
      notifyListeners();
    }
  }

  // --- Login Logic ---
  Future<bool> login(String email, String password) async {
    // Clear any previous error and show loading spinner
    isLoading = true;
    errorMessage = null;
    notifyListeners(); // tells the View to rebuild and show the spinner

    final result = await _apiService.login(email, password);

    isLoading = false;

    if (result['status'] == 'success') {
      if (result['data'] != null && result['data']['user'] != null) {
        try {
          loggedInUser = UserModel.fromMap(result['data']['user']);
          token = result['data']['access_token'];
          await saveSession(token!, loggedInUser!);
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
  void updateUserLocally(UserModel user) async {
    loggedInUser = user;
    if (token != null) {
      await saveSession(token!, user);
    }
    notifyListeners();
  }

  // Clears the error message (e.g., when the user starts typing again)
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  // --- Logout Logic ---
  Future<void> logout() async {
    if (token != null) {
      try {
        // Call the API service to revoke the token on the backend
        await _apiService.logout(token!);
      } catch (e) {
        debugPrint('Backend logout failed: $e');
      }
    }
    // Clear local session details and state
    await clearSession();
    errorMessage = null;
  }
}
