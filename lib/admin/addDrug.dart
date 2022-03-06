import 'package:flutter/material.dart';
import 'adminServices.dart';

class AddDrugs extends StatefulWidget {
  @override
  AddDrugsState createState() => AddDrugsState();
}

class AddDrugsState extends State<AddDrugs> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  var drugName = TextEditingController();
  var _pharmacy = TextEditingController();
  var _price = TextEditingController();
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

  void _addNewDrug() {
    print("Adding drug");
    AdminServices.addNewDrug(drugName.text, _pharmacy.text, _price.text)
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

    final drugNameField = TextField(
      controller: drugName,
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
      keyboardType: TextInputType.number,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Drug Price",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12.0))),
    );

    final pharmacyField = TextField(
      controller: _pharmacy,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Select Pharmacy",
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
        body: Container(
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
                pharmacyField,
                SizedBox(height: 15.0),
                addButton,
                // SizedBox(height: 35.0),
              ],
            ),
          ),
        ));
  }
}
