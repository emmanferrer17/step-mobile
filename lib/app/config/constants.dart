class ApiConstants {
  // IMPORTANT: Palitan lagi ang IP address kapag nagbago ang network.
  static const String ipAddress = '192.168.0.44';
  static const String baseUrl = 'http://$ipAddress:8080/api';
  static const String storageUrl = 'http://$ipAddress:8080/';

  // Auth Endpoints
  static const String loginUrl = '$baseUrl/user/login';
  static const String registerUrl = '$baseUrl/user/register';
  static const String verifyUrl = '$baseUrl/user/verify';
  static const String checkTupIdUrl = '$baseUrl/user/check-tupid';
  static const String checkEmailUrl = '$baseUrl/user/check-email';
  static const String resendOtpUrl = '$baseUrl/user/resend-otp';
  static const String logoutUrl = '$baseUrl/user/logout';
  static const String updateProfileUrl = '$baseUrl/user/profile/update';
  static const String updatePasswordUrl = '$baseUrl/user/password/update';
  static const String updateAvatarUrl = '$baseUrl/user/avatar/update';
  
  // Department Endpoints
  static const String departmentsUrl = '$baseUrl/departments';
}
