import 'dart:convert';
import 'lib/data/models/user_model.dart';

void main() {
  String jsonStr = '{"user_id":4,"user_firstname":"Patrick Justin","user_email":"patrickjustin_ariado@tup.edu.ph","user_middlename":"Laurente","user_lastname":"Ariado","user_suffix":null,"user_fullname":"Patrick Justin Laurente Ariado","user_type":"Faculty","user_tupid":"182020","user_contactno":null,"user_profile_photo":null,"roles":[],"departments":[]}';
  Map<String, dynamic> map = json.decode(jsonStr);
  try {
    UserModel user = UserModel.fromMap(map);
    print('SUCCESS: \$user');
  } catch (e, stacktrace) {
    print('ERROR: \$e');
    print(stacktrace);
  }
}
