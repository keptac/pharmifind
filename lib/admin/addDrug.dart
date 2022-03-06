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
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _addNewDrug() {
    AdminServices.addNewDrug(drugName.text, _pharmacy.text).then((response) {
      if (response == "success") {
        _showSnackBar(context, "Drug Added successfully");
      } else {
        _showSnackBar(context, response);
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
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
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
          height: deviceSize.height,
          // color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10.0),
                drugNameField,
                SizedBox(height: 25.0),
                addButton
              ],
            ),
          ),
        ));
  }
}
