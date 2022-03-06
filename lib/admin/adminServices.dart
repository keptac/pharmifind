import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:pharmifind/loginModel.dart';

class AdminServices {
  static const ROOT = 'http://pharmifind.ginomai.co.zw/addDrug.php';

  static Future<String> addNewDrug(drugName, pharmacy) async {
    try {
      var map = Map<String, dynamic>();
      map['drugNamename'] = drugName.toString();
      map['pharmacy'] = pharmacy.toString();

      final response = await http.post(ROOT, body: map);
      print(response);
      if (200 == response.statusCode) {
        print("Successfully added");

        return "success";
      } else {
        print("500");
        return "Addition Failed contact admin";
      }
    } catch (e) {
      print(e);
      print("API DOWN");
      return "Addition Failed contact admin";
    }
  }

  static List<Account> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Account>((json) => Account.fromJson(json)).toList();
  }
}
