import 'package:flutter/material.dart';
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
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;

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
      print("Length ${drugs.length}");
    });
  }

  Widget imageStack() => Image.asset(
        "assets/images/pill.jpg",
        fit: BoxFit.cover,
      );

  //stack3
  Widget distanceStack(String pharmacy, double rating) => Positioned(
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
                pharmacy,
                style: TextStyle(color: Colors.white, fontSize: 7.0),
              ),
              SizedBox(
                width: 2.0,
              ),
              Text(
                rating.toString() + ' KM',
                style: TextStyle(color: Colors.white, fontSize: 7.0),
              )
            ],
          ),
        ),
      );

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
                Text(drug.price,
                    style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold))
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
          return Card(
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
