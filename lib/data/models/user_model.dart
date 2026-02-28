// [MVC - MODEL]
// UserModel represents the data of a logged-in user
// as returned by the backend API after login.
//
// Instead of using: result['data']['user_email']
// We now use: user.email  <-- cleaner and avoids typos!

class UserModel {
  final int id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String suffix;
  final String tupId;
  final String email;
  final String userType;
  final int? departmentId; // nullable — some user types may not have a dept

  const UserModel({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.suffix,
    required this.tupId,
    required this.email,
    required this.userType,
    this.departmentId,
  });

  // fromMap: converts raw API Map data into a UserModel object.
  // Called after a successful login or registration response.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['user_id'] as int,
      firstName: map['user_firstname'] as String,
      middleName: (map['user_middlename'] as String?) ?? '',
      lastName: map['user_lastname'] as String,
      suffix: (map['user_suffix'] as String?) ?? '',
      tupId: map['user_tupid'] as String,
      email: map['user_email'] as String,
      userType: map['user_type'] as String,
      departmentId: map['selected_department_id'] != null
          ? int.tryParse(map['selected_department_id'].toString())
          : null,
    );
  }

  // toMap: converts this object into the Map format expected by the backend.
  // Used when sending registration data to the API.
  Map<String, String> toRegistrationMap({
    required String password,
    required String departmentId,
  }) {
    return {
      'user_firstname': firstName,
      'user_middlename': middleName,
      'user_lastname': lastName,
      'user_suffix': suffix,
      'user_tupid': tupId,
      'user_email': email,
      'user_password': password,
      'user_type': userType,
      'selected_department_id': departmentId,
    };
  }

  // Get the user's full name in one convenient property
  String get fullName =>
      '$firstName $middleName $lastName ${suffix.isNotEmpty ? suffix : ''}'
          .trim();

  @override
  String toString() => 'UserModel(id: $id, email: $email, type: $userType)';
}
