// import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'locations.dart';
import 'pharmacy_services.dart';

class PharmacyDisplay extends StatefulWidget {
  PharmacyDisplay() : super();

  final String title = 'Pharmacies';

  @override
  PharmacyDisplayState createState() => PharmacyDisplayState();
}

class PharmacyDisplayState extends State<PharmacyDisplay> {
  Size deviceSize;
  List<Pharmacy> _pharmacies;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;
  final LatLng _center = const LatLng(-17.829732153190125, 31.044149276453563);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    _pharmacies = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _getPharmacies();
  }

  void _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  void _getPharmacies() {
    PharmacyService.getPharmacies().then((pharmacies) {
      setState(() {
        _pharmacies = pharmacies;
      });
      _showProgress(widget.title);
      print("Length ${pharmacies.length}");
    });
  }

  void _showDialog(Pharmacy pharmacy) {
    final marker = Marker(
      markerId: MarkerId(pharmacy.name),
      position: LatLng(double.parse(pharmacy.lat), double.parse(pharmacy.long)),
      infoWindow: InfoWindow(
        title: pharmacy.name,
        snippet: pharmacy.address,
      ),
    );
    setState(() {
      markers[MarkerId(pharmacy.name)] = marker;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Phramacy Location"),
          content: SizedBox(
            height: 300,
            width: 300,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 10.0,
              ),
              markers: Set<Marker>.of(markers.values),
            ),
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

  Widget descStack(Pharmacy pharmacy) => Positioned(
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
                    pharmacy.name,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _dataBody() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: ListView.builder(
        itemBuilder: (context, position) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text('$position'),
              ),
              title: Text(_pharmacies[position].name),
              subtitle: Text(_pharmacies[position].address),
              trailing: Icon(
                Icons.directions,
                color: Colors.blue[900],
                size: 28.0,
              ),
              onTap: () => _showDialog(_pharmacies[position]),
            ),
          );
        },
        itemCount: _pharmacies.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
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
              _getPharmacies();
            },
          )
        ],
      ),
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage(
                'assets/images/pharmacy.jpg',
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
                    Colors.orange[800].withOpacity(0.8),
                    Colors.blue[900].withOpacity(0.7),
                    Colors.blue[900].withOpacity(0.9),
                  ],
                  stops: [
                    0.0,
                    0.8,
                    1.0
                  ])),
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
      ]),
    );
  }
}
