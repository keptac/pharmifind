import 'dart:convert';
import 'package:http/http.dart' as http;
import 'locations.dart';

class PharmacyService {
  static const ROOT = 'http:your_ip_address/DrugsDB/drug_actions.php';
  static const _GET_ALL_PHARMACIES_ACTION = 'GET_ALL_PHARMACIES';

  static Future<List<Pharmacy>> getPharmacies() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_PHARMACIES_ACTION;
      final response = await http.post(ROOT, body: map);
      // print('getPharmacies Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Pharmacy> list = parseResponse(response.body);
        return list;
      } else {
        return List<Pharmacy>();
      }
    } catch (e) {
      return List<Pharmacy>();
    }
  }

  static List<Pharmacy> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Pharmacy>((json) => Pharmacy.fromJson(json)).toList();
  }
}
