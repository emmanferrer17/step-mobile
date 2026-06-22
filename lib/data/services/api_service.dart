import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../app/config/constants.dart'; // [MVC] Use ApiConstants instead of hardcoded URLs
import '../models/department_model.dart';  // [MVC] Typed model for Department data

// [MVC - SERVICE LAYER]
// ApiService is responsible for ALL communication with the backend.
// It should NOT contain any UI logic (no setState, no Navigator).
// Controllers will call these methods and handle the results.

class ApiService {
  // --- Validation Methods ---
  Future<Map<String, dynamic>> checkTupId(String tupId) async {
    final url = Uri.parse(ApiConstants.checkTupIdUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {'user_tupid': tupId},
      ).timeout(const Duration(seconds: 5));
      return _handleResponse(response);
    } catch (e) {
      return {'status': 'error', 'message': 'Connection failed: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> checkEmail(String email) async {
    final url = Uri.parse(ApiConstants.checkEmailUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {'user_email': email},
      ).timeout(const Duration(seconds: 5));
      return _handleResponse(response);
    } catch (e) {
      return {'status': 'error', 'message': 'Connection failed: ${e.toString()}'};
    }
  }

  // --- Resend OTP Method ---
  Future<Map<String, dynamic>> resendOtp(String email) async {
    final url = Uri.parse(ApiConstants.resendOtpUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {'user_email': email},
      ).timeout(const Duration(seconds: 15)); // Longer timeout for email
      return _handleResponse(response);
    } catch (e) {
      return {'status': 'error', 'message': 'Connection failed: ${e.toString()}'};
    }
  }

  // --- Department Fetch Method ---
  Future<List<DepartmentModel>> getDepartments() async {
    final url = Uri.parse(ApiConstants.departmentsUrl);
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> rawList = json.decode(response.body);
        return rawList.map((item) => DepartmentModel.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load departments. Status code: ${response.statusCode}');
      }
    } on SocketException {
       throw Exception('Connection Error: Could not connect to the server.');
    } on TimeoutException {
      throw Exception('Connection Timeout: The server took too long to respond.');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  // --- Auth Methods ---
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(ApiConstants.loginUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'user_email': email,
          'user_password': password,
        },
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': 'Connection Error: Could not connect to the server.'};
    } on TimeoutException {
      return {'status': 'error', 'message': 'Connection Timeout: The server took too long to respond.'};
    } catch (e) {
      return {'status': 'error', 'message': 'An unexpected error occurred: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> register(Map<String, String> userData) async {
    final url = Uri.parse(ApiConstants.registerUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: userData,
      ).timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': 'Connection Error: Could not connect to the server.'};
    } on TimeoutException {
      return {'status': 'error', 'message': 'Connection Timeout: The server took too long to respond.'};
    } catch (e) {
      return {'status': 'error', 'message': 'An unexpected error occurred: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> verify(Map<String, String> verificationData) async {
    final url = Uri.parse(ApiConstants.verifyUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: verificationData,
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': 'Connection Error: Could not connect to the server.'};
    } on TimeoutException {
      return {'status': 'error', 'message': 'Connection Timeout: The server took too long to respond.'};
    } catch (e) {
      return {'status': 'error', 'message': 'An unexpected error occurred: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> logout(String token) async {
    final url = Uri.parse(ApiConstants.logoutUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': 'Connection Error: Could not connect to the server.'};
    } on TimeoutException {
      return {'status': 'error', 'message': 'Connection Timeout: The server took too long to respond.'};
    } catch (e) {
      return {'status': 'error', 'message': 'An unexpected error occurred: ${e.toString()}'};
    }
  }

  // --- Profile Edit Methods ---
  Future<Map<String, dynamic>> updateProfile(Map<String, String> profileData, String token) async {
    final url = Uri.parse(ApiConstants.updateProfileUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: profileData,
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': 'Connection Error: Could not connect to the server.'};
    } on TimeoutException {
      return {'status': 'error', 'message': 'Connection Timeout: The server took too long to respond.'};
    } catch (e) {
      return {'status': 'error', 'message': 'An unexpected error occurred: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> updatePassword(Map<String, String> passwordData, String token) async {
    final url = Uri.parse(ApiConstants.updatePasswordUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: passwordData,
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': 'Connection Error: Could not connect to the server.'};
    } on TimeoutException {
      return {'status': 'error', 'message': 'Connection Timeout: The server took too long to respond.'};
    } catch (e) {
      return {'status': 'error', 'message': 'An unexpected error occurred: ${e.toString()}'};
    }
  }
  Future<Map<String, dynamic>> updateAvatar(File imageFile, String token) async {
    final url = Uri.parse(ApiConstants.updateAvatarUrl);
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      request.files.add(await http.MultipartFile.fromPath('profile_photo', imageFile.path));

      var streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      var response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': 'Connection Error: Could not connect to the server.'};
    } on TimeoutException {
      return {'status': 'error', 'message': 'Connection Timeout: The server took too long to respond.'};
    } catch (e) {
      return {'status': 'error', 'message': 'An unexpected error occurred: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> updateItemImage(int itemId, File imageFile, String token) async {
    final url = Uri.parse(ApiConstants.updateItemImageUrl);
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      request.fields['item_id'] = itemId.toString();
      
      request.files.add(await http.MultipartFile.fromPath(
        'item_image', 
        imageFile.path,
      ));

      var streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      var response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': 'Connection Error: Could not connect to the server.'};
    } on TimeoutException {
      return {'status': 'error', 'message': 'Connection Timeout: The server took too long to respond.'};
    } catch (e) {
      return {'status': 'error', 'message': 'An unexpected error occurred: ${e.toString()}'};
    }
  }

  /// Syncs all item images (ordered existing paths + new files) in one atomic request.
  Future<Map<String, dynamic>> syncItemImages(int itemId, List<String> existingImages, List<File> newImages, String token) async {
    final url = Uri.parse(ApiConstants.updateItemImageUrl);
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      request.fields['item_id'] = itemId.toString();
      
      // Send existing images as a JSON-encoded string for robust parsing on the backend
      request.fields['existing_images'] = json.encode(existingImages);

      // Add new images as files using the array key 'item_image[]'
      for (var file in newImages) {
        var multipartFile = await http.MultipartFile.fromPath(
          'item_image[]', 
          file.path,
        );
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send().timeout(const Duration(seconds: 90));
      var response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': 'Connection Error: Could not connect to the server.'};
    } on TimeoutException {
      return {'status': 'error', 'message': 'Connection Timeout: The server took too long to respond.'};
    } catch (e) {
      return {'status': 'error', 'message': 'An unexpected error occurred: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> deleteItemImage(int itemId, String imagePath, String token) async {
    final url = Uri.parse(ApiConstants.deleteItemImageUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'item_id': itemId.toString(),
          'image_path': imagePath,
        },
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': 'Connection Error: Could not connect to the server.'};
    } on TimeoutException {
      return {'status': 'error', 'message': 'Connection Timeout: The server took too long to respond.'};
    } catch (e) {
      return {'status': 'error', 'message': 'An unexpected error occurred: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> updateItemLocation(int itemId, String? building, String? roomNo, String token) async {
    final url = Uri.parse(ApiConstants.updateItemLocationUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'item_id': itemId.toString(),
          'building': building ?? '',
          'room_no': roomNo ?? '',
        },
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': 'Connection Error: Could not connect to the server.'};
    } on TimeoutException {
      return {'status': 'error', 'message': 'Connection Timeout: The server took too long to respond.'};
    } catch (e) {
      return {'status': 'error', 'message': 'An unexpected error occurred: ${e.toString()}'};
    }
  }

  // --- MR Assign Method ---
  Future<Map<String, dynamic>> assignMrItems(String qrCode, String token) async {
    final url = Uri.parse(ApiConstants.assignMrUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {'mr_qr_code': qrCode},
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': 'Connection Error: Could not connect to the server.'};
    } on TimeoutException {
      return {'status': 'error', 'message': 'Connection Timeout: The server took too long to respond.'};
    } catch (e) {
      return {'status': 'error', 'message': 'An unexpected error occurred: ${e.toString()}'};
    }
  }

  // --- MR Lookup Method ---
  Future<Map<String, dynamic>> lookupMrItem(String qrCode, String token) async {
    final url = Uri.parse(ApiConstants.lookupMrUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {'mr_qr_code': qrCode},
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': 'Connection Error: Could not connect to the server.'};
    } on TimeoutException {
      return {'status': 'error', 'message': 'Connection Timeout: The server took too long to respond.'};
    } catch (e) {
      return {'status': 'error', 'message': 'An unexpected error occurred: ${e.toString()}'};
    }
  }

  // --- Fetch MR Items Method ---
  Future<Map<String, dynamic>> getMrItems(String token) async {
    final url = Uri.parse(ApiConstants.mrItemsUrl);
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': 'Connection Error: Could not connect to the server.'};
    } on TimeoutException {
      return {'status': 'error', 'message': 'Connection Timeout: The server took too long to respond.'};
    } catch (e) {
      return {'status': 'error', 'message': 'An unexpected error occurred: ${e.toString()}'};
    }
  }

  // --- Helper Function ---
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final responseBody = json.decode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'status': 'success', 'data': responseBody};
      } else {
        return {
          'status': 'error',
          'message': responseBody['messages']?['error'] ?? responseBody['message'] ?? 'An unknown server error occurred.',
          'statusCode': response.statusCode,
          'data': responseBody, // Include raw body so controllers can parse specific validation errors (e.g., password mismatch)
        };
      }
    } on FormatException {
      return {
        'status': 'error',
        'message': 'Server returned an invalid response (Status code: ${response.statusCode}).',
        'statusCode': response.statusCode,
      };
    }
  }
}
