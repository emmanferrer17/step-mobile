// [MVC - MODEL]
// DepartmentModel represents the data structure of a Department
// as returned by the backend API (/api/departments).
//
// Instead of using raw Map data like: department['dep_id']
// We now use: department.id  <-- safer, cleaner, and autocomplete works!

class DepartmentModel {
  final int id;
  final String name;

  // Constructor: requires both id and name
  const DepartmentModel({
    required this.id,
    required this.name,
  });

  // fromMap: converts raw API Map data into a DepartmentModel object.
  // Called when we receive a response from the backend.
  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      id: map['dep_id'] as int,
      name: map['dep_name'] as String,
    );
  }

  // toMap: converts this object back into a Map.
  // Useful if we ever need to send department data to the API.
  Map<String, dynamic> toMap() {
    return {
      'dep_id': id,
      'dep_name': name,
    };
  }

  @override
  String toString() => 'DepartmentModel(id: $id, name: $name)';
}
