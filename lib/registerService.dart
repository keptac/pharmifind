import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:pharmifind/loginModel.dart';

class RegisterService {
  static const ROOT = 'http://pharmifind.ginomai.co.zw/register.php';

  static Future<String> newAccount(user, pass) async {
    try {
      var map = Map<String, dynamic>();
      map['username'] = user.toString();
      map['password'] = pass.toString();

      final response = await http.post(ROOT, body: map);
      print(response);
      if (200 == response.statusCode) {
        print("Successfully registered");

        return "success";
      } else {
        print("500");
        return "Registration Failed contact admin";
      }
    } catch (e) {
      print(e);
      print("API DOWN");
      return "Registration Failed contact admin";
    }
  }

  static List<Account> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Account>((json) => Account.fromJson(json)).toList();
  }
}
