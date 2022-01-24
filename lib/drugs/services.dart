import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'drugs.dart';

class Services {
    static const ROOT = 'http://pharmifind.ginomai.co.zw/drug_actions.php';

  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';


  // Method to create the table Drugs.
  static Future<String> createTable() async {
    try {
      // add the parameters to pass to the request.
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error 1";
      }
    } catch (e) {
      return 'error-->: $e';
    }
  }

  static Future<List<Drug>> getDrugs() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        List<Drug> list = parseResponse(response.body);
        return list;
      } else {
        return List<Drug>();
      }
    } catch (e) {
      return List<Drug>();
    }
  }

  static List<Drug> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Drug>((json) => Drug.fromJson(json)).toList();
  }

}
