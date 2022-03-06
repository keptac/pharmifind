import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.

class AdminServices {
  static const addDrugRoot = 'http://pharmifind.ginomai.co.zw/addDrug.php';
  static const addPharmacyRoot =
      'http://pharmifind.ginomai.co.zw/addPharmacy.php';

  static Future<String> addNewDrug(drugName, drugPrice, pharmacy) async {
    try {
      var map = Map<String, dynamic>();
      map['drugName'] = drugName.toString();
      map['drugPrice'] = drugPrice.toString();
      map['pharmacy'] = pharmacy.toString();

      final response = await http.post(addDrugRoot, body: map);
      print(response.body);
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

  static Future<String> addNewPharmacy(pharmacyName, address, lat, long) async {
    try {
      var map = Map<String, dynamic>();
      map['pharmacyName'] = pharmacyName.toString();
      map['address'] = address.toString();
      map['lat'] = lat.toString();
      map['long'] = long.toString();

      final response = await http.post(addPharmacyRoot, body: map);
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
}
