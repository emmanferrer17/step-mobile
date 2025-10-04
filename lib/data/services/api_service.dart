import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiService {
  // IMPORTANT: Replace with your computer's current network IP address.
  static const String _ipAddress = '192.168.0.44'; 
  static const String _baseUrl = 'http://$_ipAddress:8080/api';

  // --- Validation Methods ---
  Future<Map<String, dynamic>> checkTupId(String tupId) async {
    final url = Uri.parse('$_baseUrl/user/check-tupid');
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
    final url = Uri.parse('$_baseUrl/user/check-email');
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
  
  // --- NEW: Resend OTP Method ---
  Future<Map<String, dynamic>> resendOtp(String email) async {
    final url = Uri.parse('$_baseUrl/user/resend-otp');
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
  Future<List<dynamic>> getDepartments() async {
    final url = Uri.parse('$_baseUrl/departments');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
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
    final url = Uri.parse('$_baseUrl/user/login');
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
    final url = Uri.parse('$_baseUrl/user/register');
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
    final url = Uri.parse('$_baseUrl/user/verify');
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
