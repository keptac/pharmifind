import 'package:flutter/material.dart';
import 'package:pharmifind/pharmacies/locations.dart';
import 'package:pharmifind/pharmacies/pharmacy_services.dart';
import 'adminServices.dart';

class AddDrugs extends StatefulWidget {
  @override
  AddDrugsState createState() => AddDrugsState();
}

class AddDrugsState extends State<AddDrugs> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  var _drugName = TextEditingController();
  var _price = TextEditingController();
  var errorMsg = '';
  Pharmacy selectedPharmacy;
  List<Pharmacy> _pharmacies;

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
    _getPharmacies();
  }

  void _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _getPharmacies() {
    PharmacyService.getPharmacies().then((pharmacies) {
      setState(() {
        _pharmacies = pharmacies;
      });
      print("Length ${pharmacies.length}");
    });
  }

  void _addNewDrug() {
    print("Adding drug");
    AdminServices.addNewDrug(_drugName.text, _price.text, selectedPharmacy.id)
        .then((response) {
      if (response == "success") {
        this.setState(() {
          errorMsg = "Drug Added successfully";
        });
      } else {
        errorMsg = response;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    final pharmaciesDropDown = Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: DropdownButton<Pharmacy>(
        focusColor: Colors.white,
        underline: Container(
          margin: EdgeInsets.all(20),
        ),
        value: selectedPharmacy,
        isExpanded: true,
        style: TextStyle(color: Colors.white),
        iconEnabledColor: Colors.black,
        items: _pharmacies.map<DropdownMenuItem<Pharmacy>>((var pharmacy) {
          return DropdownMenuItem<Pharmacy>(
            value: pharmacy,
            child: Text(
              pharmacy.name,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          );
        }).toList(),
        hint: Text(
          "Select Pharmacy",
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
        ),
        onChanged: (var value) {
          setState(() {
            selectedPharmacy = value;
          });
        },
      ),
    );

    final drugNameField = TextField(
      controller: _drugName,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Enter Drug Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
    final priceField = TextField(
      controller: _price,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Drug Price",
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
          _addNewDrug();
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
            "Add New Drug",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                drugNameField,
                SizedBox(height: 15.0),
                priceField,
                SizedBox(height: 15.0),
                pharmaciesDropDown,
                SizedBox(height: 15.0),
                addButton,
                // SizedBox(height: 35.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
