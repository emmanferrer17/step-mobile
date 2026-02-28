class ApiConstants {
  // IMPORTANT: Palitan lagi ang IP address kapag nagbago ang network.
  static const String ipAddress = '192.168.0.47';
  static const String baseUrl = 'http://$ipAddress:8080/api';

  // Auth Endpoints
  static const String loginUrl = '$baseUrl/user/login';
  static const String registerUrl = '$baseUrl/user/register';
  static const String verifyUrl = '$baseUrl/user/verify';
  static const String checkTupIdUrl = '$baseUrl/user/check-tupid';
  static const String checkEmailUrl = '$baseUrl/user/check-email';
  static const String resendOtpUrl = '$baseUrl/user/resend-otp';
  
  // Department Endpoints
  static const String departmentsUrl = '$baseUrl/departments';
}
