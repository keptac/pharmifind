import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pharmifind/drugs/searchDrug.dart';
import 'package:pharmifind/pharmacies/pharmacyDisplay.dart';

import 'dashboard_one/dashboard_menu_row.dart';
import 'designs/background.dart';
import 'designs/profile_tile.dart';
import 'drugs/drugsDisplay.dart';
import 'pharmacies/locations.dart';
import 'pharmacies/pharmacy_services.dart';
import 'package:localstorage/localstorage.dart';

class DashboardOnePage extends StatefulWidget {
  @override
  _DashboardOnePageState createState() => _DashboardOnePageState();
}

class _DashboardOnePageState extends State<DashboardOnePage> {
  final LocalStorage storage = LocalStorage('pharmifind');
  Size deviceSize;
  GoogleMapController mapController;
  LocationData userLocation;
  var location = Location();
  List<Pharmacy> _pharmacies;
  final _search = TextEditingController();
  var username = "";

  @override
  void initState() {
    username = storage.getItem('username');
    super.initState();
    _getPharmacies();
  }

  void _getPharmacies() {
    PharmacyService.getPharmacies().then((pharmacies) {
      setState(() {
        _pharmacies = pharmacies;
      });
      print("Length ${pharmacies.length}");
    });
  }

  Future<LocationData> _getLocation() async {
    LocationData currentLocation;
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _markers.clear();
      for (final pharmacy in _pharmacies) {
        double lat = double.parse(pharmacy.lat);
        double long = double.parse(pharmacy.long);
        final marker = Marker(
          markerId: MarkerId(pharmacy.name),
          position: LatLng(lat, long),
          infoWindow: InfoWindow(
            title: pharmacy.name,
            snippet: pharmacy.address,
          ),
        );
        _markers[pharmacy.name] = marker;
      }
    });
  }

  final LatLng _center = const LatLng(-17.829732153190125, 31.044149276453563);

  Widget appBarColumn(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 18.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        defaultTargetPlatform == TargetPlatform.android
                            ? Icons.info
                            : Icons.info_outline_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => null),
                  ProfileTile(
                    title: "Hi, " + username,
                    subtitle: "Welcome to the Pharmi Find",
                    textColor: Colors.white,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      );

  Widget searchCard() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: TextField(
                    controller: _search,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search for a drug"),
                  ),
                ),
                InkWell(
                    child: Icon(Icons.search),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchDrug(title: _search.text),
                        ),
                      );
                      print(_search.text);
                    }),
              ],
            ),
          ),
        ),
      );

  Widget actionMenuCard() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  DashboardMenuRow(
                    firstIcon: FontAwesomeIcons.pills,
                    firstOnPressed: DrugDisplay(),
                    firstLabel: "Drugs",
                    firstIconCircleColor: Colors.blue,
                    thirdIcon: FontAwesomeIcons.hospital,
                    thirdOnPressed: PharmacyDisplay(),
                    thirdLabel: "Pharmacies",
                    thirdIconCircleColor: Colors.green,
                    fourthIcon: FontAwesomeIcons.locationArrow,
                    fourthOnPressed: '/Shopping List',
                    fourthLabel: "Health Tips",
                    fourthIconCircleColor: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

// Call Google Maps API
  Widget mapCard() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('Pharmacy locator',
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 350.0,
                // Google Map API Function
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 15.0,
                  ),
                  markers: _markers.values.toSet(),
                ),
                // child: GoogleMap(
                //   onMapCreated: _onMapCreated,
                //   initialCameraPosition: CameraPosition(
                //     target: userLocation != null
                //         ? LatLng(userLocation.latitude, userLocation.longitude)
                //         : _center,
                //     zoom: 15.0,
                //   ),
                //   markers: _markers.values.toSet(),
                // ),
              ),
            ],
          ),
        ),
      );

  Widget allCards(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            appBarColumn(context),
            SizedBox(
              height: deviceSize.height * 0.01,
            ),
            searchCard(),
            SizedBox(
              height: deviceSize.height * 0.01,
            ),
            actionMenuCard(),
            SizedBox(
              height: deviceSize.height * 0.01,
            ),
            mapCard()
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    _getLocation().then((value) {
      setState(() {
        userLocation = value;
      });
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Background(
            showIcon: false,
          ),
          allCards(context),
        ],
      ),
    );
  }
}
