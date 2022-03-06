import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'adminServices.dart';

class AddPharmacy extends StatefulWidget {
  @override
  AddPharmacyState createState() => AddPharmacyState();
}

class AddPharmacyState extends State<AddPharmacy> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  var _pharmacyName = TextEditingController();
  var _address = TextEditingController();
  var errorMsg = '';
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
  }

  void _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _getLoc() async {
    var localAddress = _address.text + " " + "Harare";
    var addresses = await Geocoder.local.findAddressesFromQuery(localAddress);
    var first = addresses.first;
    print(first.coordinates.latitude);
    print(first.coordinates.longitude);
    _addNewPharmacy(first.coordinates.latitude, first.coordinates.longitude);
  }

  void _addNewPharmacy(lat, lon) {
    AdminServices.addNewPharmacy(_pharmacyName.text, _address.text, lat, lon)
        .then((response) {
      if (response == "success") {
        this.setState(() {
          errorMsg = 'Success';
        });
      } else {
        this.setState(() {
          errorMsg = response;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    final _pharmacyNameField = TextField(
      controller: _pharmacyName,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter Pharmacy Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12.0))),
    );

    final pharmacyField = TextField(
      controller: _address,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter Address",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12.0))),
    );

    final addButton = Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blueAccent,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          _getLoc();
        },
        child: Text("Submit",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Center(
            child: Text(
              "Add Pharmacy",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Container(
          height: deviceSize.height,
          // color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Text(errorMsg,
                    style: TextStyle(
                        color: Colors.red,
                        fontStyle: FontStyle.italic,
                        fontSize: 12)),
                SizedBox(height: 15.0),
                _pharmacyNameField,
                SizedBox(height: 20.0),
                pharmacyField,
                SizedBox(height: 25.0),
                addButton,
                // SizedBox(height: 35.0),
              ],
            ),
          ),
        ));
  }
}
