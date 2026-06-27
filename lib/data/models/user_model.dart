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
  final String? roleName;
  final String? departmentName;
  final String? profilePhoto;
  final String contactNo;

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
    this.roleName,
    this.departmentName,
    this.profilePhoto,
    required this.contactNo,
  });

  // fromMap: converts raw API Map data into a UserModel object.
  // Called after a successful login or registration response.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['user_id'] is int ? map['user_id'] : int.tryParse(map['user_id']?.toString() ?? '0') ?? 0,
      firstName: (map['user_firstname'] as String?) ?? '',
      middleName: (map['user_middlename'] as String?) ?? '',
      lastName: (map['user_lastname'] as String?) ?? '',
      suffix: (map['user_suffix'] as String?) ?? '',
      tupId: (map['user_tupid'] as String?) ?? '',
      email: (map['user_email'] as String?) ?? '',
      userType: (map['user_type'] as String?) ?? '',
      departmentId: (map['department_id'] != null || map['selected_department_id'] != null || map['department_id_fk'] != null)
          ? int.tryParse((map['department_id'] ?? map['selected_department_id'] ?? map['department_id_fk']).toString())
          : null,
      roleName: map['roles'] != null && (map['roles'] as List).isNotEmpty
          ? map['roles'][0]['role_name'] as String?
          : null,
      departmentName: map['departments'] != null && (map['departments'] as List).isNotEmpty
          ? (map['departments'] as List).map((d) => d['dep_name']).join(', ')
          : null,
      profilePhoto: map['user_profile_photo'] as String?,
      contactNo: (map['user_contactno'] as String?) ?? 'N/A',
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
      'user_contactno': contactNo,
      'user_suffix': suffix,
      'user_tupid': tupId,
      'user_email': email,
      'user_password': password,
      'user_type': userType,
      'department_id': departmentId,
      'selected_department_id': departmentId,
    };
  }

  // Creates a new UserModel instance with selectively updated fields.
  UserModel copyWith({
    String? firstName,
    String? middleName,
    String? lastName,
    String? suffix,
    String? contactNo,
    String? profilePhoto,
  }) {
    return UserModel(
      id: id,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      suffix: suffix ?? this.suffix,
      tupId: tupId,
      email: email,
      userType: userType,
      departmentId: departmentId,
      roleName: roleName,
      departmentName: departmentName,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      contactNo: contactNo ?? this.contactNo,
    );
  }

  // toMap: converts this object into a Map format suitable for JSON serialization and local storage.
  Map<String, dynamic> toMap() {
    return {
      'user_id': id,
      'user_firstname': firstName,
      'user_middlename': middleName,
      'user_lastname': lastName,
      'user_suffix': suffix,
      'user_tupid': tupId,
      'user_email': email,
      'user_type': userType,
      'department_id': departmentId,
      'roles': roleName != null ? [{'role_name': roleName}] : null,
      'departments': departmentName != null ? [{'dep_name': departmentName}] : null,
      'user_profile_photo': profilePhoto,
      'user_contactno': contactNo,
    };
  }

  // Get the user's full name in one convenient property
  String get fullName =>
      '$firstName $middleName $lastName ${suffix.isNotEmpty ? suffix : ''}'
          .trim();

  @override
  String toString() => 'UserModel(id: $id, email: $email, type: $userType)';
}
