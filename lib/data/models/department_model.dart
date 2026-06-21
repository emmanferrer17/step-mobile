// [MVC - MODEL]
// DepartmentModel represents the data structure of a Department
// as returned by the backend API (/api/departments).
//
// Instead of using raw Map data like: department['dep_id']
// We now use: department.id  <-- safer, cleaner, and autocomplete works!

class DepartmentModel {
  final int id;
  final String name;
  final int? parentId;

  // Constructor: requires both id and name
  const DepartmentModel({
    required this.id,
    required this.name,
    this.parentId,
  });

  // fromMap: converts raw API Map data into a DepartmentModel object.
  // Called when we receive a response from the backend.
  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    // Check multiple possible keys to be robust against API variations
    final idValue = map['dep_id'] ?? map['id'] ?? '0';
    final nameValue = map['dep_name'] ?? map['name'] ?? '';
    
    // Attempt to find parent ID in various common formats (flat or nested)
    dynamic parentIdValue = map['parent_dep_id'] ?? map['parentId'] ?? map['parent_id'];
    
    // If not found, check if it's nested in a 'parent' object
    if (parentIdValue == null && map['parent'] is Map) {
      parentIdValue = map['parent']['dep_id'] ?? map['parent']['id'];
    }

    return DepartmentModel(
      id: idValue is int ? idValue : int.tryParse(idValue.toString()) ?? 0,
      name: nameValue.toString(),
      parentId: parentIdValue == null 
          ? null 
          : (parentIdValue is int 
              ? parentIdValue 
              : int.tryParse(parentIdValue.toString())),
    );
  }

  // toMap: converts this object back into a Map.
  // Useful if we ever need to send department data to the API.
  Map<String, dynamic> toMap() {
    return {
      'dep_id': id,
      'dep_name': name,
      'parent_dep_id': parentId,
    };
  }

  @override
  String toString() => 'DepartmentModel(id: $id, name: $name)';
}
