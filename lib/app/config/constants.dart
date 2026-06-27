class ApiConstants {
  // [CONNECTION MODE]
  // 1. USB Debugging: Use 'localhost' and run 'adb reverse tcp:8080 tcp:8080'
  // 2. Wi-Fi Debugging: Use your PC's IP (e.g., '192.168.x.x')
  // // //
  static const String ipAddress = '192.168.0.44';

  static const String baseUrl = 'http://$ipAddress:8080/api';
  static const String storageUrl = 'http://$ipAddress:8080/';
  //
  // static const String ipAddress = 'itrac.tupt.edu.ph';
  //
  // static const String baseUrl = 'https://itrac.tupt.edu.ph/api';
  // static const String storageUrl = 'https://itrac.tupt.edu.ph/';

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
  static const String updateItemImageUrl = '$baseUrl/user/mr/items/update-image';
  static const String deleteItemImageUrl = '$baseUrl/user/mr/items/delete-image';
  static const String updateItemLocationUrl = '$baseUrl/user/mr/items/update-location';
  static const String assignMrUrl = '$baseUrl/user/mr/assign';
  static const String lookupMrUrl = '$baseUrl/user/mr/lookup';
  static const String mrItemsUrl = '$baseUrl/user/mr/items';
  
  // Department Endpoints
  static const String departmentsUrl = '$baseUrl/user/departments';

  // Assets
  static const String manualAssetPath = 'assets/docs/manual.pdf';
}

