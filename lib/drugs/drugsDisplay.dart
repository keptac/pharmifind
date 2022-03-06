import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmifind/pharmacies/locations.dart';
import 'package:pharmifind/pharmacies/pharmacy_services.dart';
import 'drugs.dart';
import 'services.dart';

class DrugDisplay extends StatefulWidget {
  DrugDisplay() : super();

  final String title = 'Drugs Store';

  @override
  DrugDisplayState createState() => DrugDisplayState();
}

class DrugDisplayState extends State<DrugDisplay> {
  List<Drug> _drugs;
  List<Pharmacy> _pharmacies;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;
  List<Pharmacy> _searchResult = [];
  List<Pharmacy> _searchLocResult;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    final LatLng _center = const LatLng(-17.829732153190125, 31.044149276453563);
  @override
  void initState() {
    super.initState();
    _drugs = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _getDrugs();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _createTable() {
    _showProgress('Creating Table...');
    Services.createTable().then((result) {
      if ('success' == result) {
        // Table is created successfully.
        _showSnackBar(context, result);
        _showProgress(widget.title);
      } else {
        _showSnackBar(context, result);
        _showProgress(widget.title);
      }
    });
  }

  _getDrugs() {
    _showProgress('Loading Drugs...');
    Services.getDrugs().then((drugs) {
      setState(() {
        _drugs = drugs;
      });
      _showProgress(widget.title); // Reset the title...
    });

    PharmacyService.getPharmacies().then((pharmacies) {
      setState(() {
        _pharmacies = pharmacies;
      });
    });
  }

  void _showDialog(String pharmacyId, Drug drug) {
    _searchLocResult = [];

    _pharmacies.forEach((pharmacy) {
      if (pharmacy.id.contains(pharmacyId)) {
        _searchLocResult.add(pharmacy);
      }
    });

    final marker = Marker(
      markerId: MarkerId(_searchLocResult[0].name),
      position: LatLng(double.parse(_searchLocResult[0].lat),
          double.parse(_searchLocResult[0].long)),
      infoWindow: InfoWindow(
        title: _searchLocResult[0].name,
        snippet: _searchLocResult[0].address,
      ),
    );
    setState(() {
      markers[MarkerId(_searchLocResult[0].name)] = marker;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pharmacy Directions"),
          content: Column(
            children: <Widget>[
              SizedBox(
                height: 300,
                width: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 15.0,
                  ),
                  markers: Set<Marker>.of(markers.values),
                ),
              ),
              SizedBox(
                width: 300,
                child: Center(
                  child: Text(
                    '\n\n ' + drug.name + '\n\n \$' + drug.price,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget imageStack() => Image.asset(
        "assets/images/pill.jpg",
        fit: BoxFit.cover,
      );

  //stack3
  Widget distanceStack(String pharmacyId, double rating) {
    _searchResult = [];

    _pharmacies.forEach((pharmacy) {
      if (pharmacy.id.contains(pharmacyId)) {
        _searchResult.add(pharmacy);
      }
    });

    print(_searchResult[0].name);

    return Positioned(
      top: 0.0,
      left: 0.0,
      child: Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            color: Colors.blue[900].withOpacity(0.9),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0))),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.location_on,
              color: Colors.yellow,
              size: 10.0,
            ),
            SizedBox(
              width: 2.0,
            ),
            Text(
              _searchResult[0].name,
              style: TextStyle(color: Colors.white, fontSize: 7.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget descStack(Drug drug) => Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: Container(
          decoration: BoxDecoration(color: Colors.blue[900].withOpacity(0.5)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    drug.name,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Text(
                  drug.price,
                  style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      );

  Widget _dataBody() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.builder(
        itemBuilder: (context, position) {
          return InkWell(
            onTap: () =>
                _showDialog(_drugs[position].pharmacy, _drugs[position]),
            child: Card(
              elevation: 10.0,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Stack(
                  children: <Widget>[
                    imageStack(),
                    descStack(_drugs[position]),
                    distanceStack(_drugs[position].pharmacy, 4.0)
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: _drugs.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      ),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Center(
          child: Text(
            _titleProgress,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getDrugs();
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(
                  'assets/images/pills.jpg',
                ),
              ),
            ),
            height: deviceSize.height,
          ),
          Container(
            height: deviceSize.height,
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.orange[600].withOpacity(0.8),
                  Colors.blue[900].withOpacity(0.8),
                  Colors.blue[900].withOpacity(0.9),
                ],
                stops: [0.0, 0.7, 1.0],
              ),
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(),
                Expanded(
                  child: _dataBody(),
                ),
              ],
            ),
          ),
        ],
      ),

//      floatingActionButton: FloatingActionButton(
//        onPressed: () {},
//        child: Icon(Icons.add),
//      ),
    );
  }
}
