import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task/api_routes/api_routes.dart';
import 'package:task/model/user_model.dart';

class UserApiServices {
  static Future<UserModel?> getApiUser() async {
    http.Response response = await http.get(Uri.parse(ApiRoutes.user));

    var result = jsonDecode(response.body);
    print('Responce=====>>>>$result');

    return userModelFromJson(response.body);
  }
}
