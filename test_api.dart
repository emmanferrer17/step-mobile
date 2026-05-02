import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lib/data/models/user_model.dart';

void main() async {
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8080/api/user/login'),
      headers: {'Accept': 'application/json'},
      body: {
        'user_email': 'patrickjustin_ariado@tup.edu.ph',
        'user_password': 'password'
      }
    );
    print('STATUS CODE: \${response.statusCode}');
    print('BODY: \${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['user'] != null) {
         final user = UserModel.fromMap(data['user']);
         print('PARSED USER: \$user');
      } else {
         print('NO USER OBJECT');
      }
    }
  } catch (e) {
    print('ERROR: \$e');
  }
}
