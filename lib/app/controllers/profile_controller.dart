import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../data/services/api_service.dart';
import 'auth_controller.dart';

// [MVC - CONTROLLER]
// ProfileController handles profile editing logic, respecting the Single Responsibility Principle.
// It relies on AuthController to read the current token and update the global user state.

class ProfileController extends ChangeNotifier {
  final AuthController _authController;
  final ApiService _apiService = ApiService();

  ProfileController(this._authController);

  // Orchestrates calling the update profile and/or update password APIs.
  // Returns null on absolute success, or a Map<String, String> mapping field names to validation errors.
  Future<Map<String, String>?> updateAccountDetails({
    required Map<String, String> profileData,
    Map<String, String>? passwordData,
  }) async {
    final token = _authController.token;
    if (token == null) {
      return {'general': 'Not authenticated'};
    }

    // 1. Update Profile Information First
    final profileResult = await _apiService.updateProfile(profileData, token);
    if (profileResult['status'] != 'success') {
      final Map<String, String> errors = {};
      if (profileResult['data'] != null && profileResult['data']['errors'] != null) {
        final apiErrors = profileResult['data']['errors'];
        apiErrors.forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            errors[key] = value[0].toString();
          } else {
            errors[key] = value.toString();
          }
        });
      } else {
        errors['general'] = profileResult['message'] ?? 'Failed to update profile information.';
      }
      return errors;
    }

    // Update the local UserModel inside AuthController so the UI reflects the changes instantly
    if (_authController.loggedInUser != null) {
      final updatedUser = _authController.loggedInUser!.copyWith(
        firstName: profileData['user_firstname'],
        middleName: profileData['user_middlename'],
        lastName: profileData['user_lastname'],
        suffix: profileData['user_suffix'],
        contactNo: profileData['user_contactno'],
      );
      _authController.updateUserLocally(updatedUser);
    }

    // 2. Update Password if requested
    if (passwordData != null && passwordData['current_password']!.isNotEmpty) {
      final passwordResult = await _apiService.updatePassword(passwordData, token);
      if (passwordResult['status'] != 'success') {
        final Map<String, String> errors = {};
        if (passwordResult['data'] != null && passwordResult['data']['errors'] != null) {
          final apiErrors = passwordResult['data']['errors'];
          apiErrors.forEach((key, value) {
            if (value is List && value.isNotEmpty) {
              errors[key] = value[0].toString();
            } else {
              errors[key] = value.toString();
            }
          });
        } else {
          errors['general'] = passwordResult['message'] ?? 'Failed to update password.';
        }
        return errors;
      }
    }

    return null; // Null means complete success!
  }

  // Uploads a new profile photo and updates the local state on success.
  Future<String?> updateAvatar(File imageFile) async {
    final token = _authController.token;
    if (token == null) return 'Not authenticated';

    final result = await _apiService.updateAvatar(imageFile, token);
    
    if (result['status'] == 'success') {
      final photoUrl = result['data']['photo_url'] as String?;
      
      // Update the local UserModel with the newly uploaded image relative path
      if (_authController.loggedInUser != null) {
        // We only want to save the relative path 'img/profiles/...' 
        // to match how it is returned during normal login.
        // We can extract the relative part by splitting if necessary, or better yet
        // the API itself actually just returns the full URL in `photo_url`, but typically
        // we store the relative path. Wait! The API in AccountSettingsController says:
        // 'photo_url' => asset('img/profiles/' . $filename)
        // We will just let the app load the new image path. But wait, `profilePhoto` field
        // in UserModel uses relative path. Let's extract the relative path:
        
        String newRelativePath = '';
        if (photoUrl != null) {
          final uri = Uri.tryParse(photoUrl);
          if (uri != null) {
             newRelativePath = uri.path.startsWith('/') ? uri.path.substring(1) : uri.path;
             // Ensure it has img/profiles/
             if (!newRelativePath.contains('img/profiles/')) {
                 // fallback just to be safe
             }
          }
        }
        
        // Simpler way: just extract everything after 'public/' or just use a fixed regex
        // We know it is 'img/profiles/...'
        final pathParts = photoUrl?.split('img/profiles/');
        if (pathParts != null && pathParts.length > 1) {
           newRelativePath = 'img/profiles/${pathParts.last}';
        }

        if (newRelativePath.isNotEmpty) {
           final updatedUser = _authController.loggedInUser!.copyWith(
             profilePhoto: newRelativePath,
           );
           _authController.updateUserLocally(updatedUser);
        }
      }
      return null; // success
    } else {
      return result['message'] ?? 'Failed to upload image.';
    }
  }
}
