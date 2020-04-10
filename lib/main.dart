import 'package:flutter/material.dart';
import 'package:pharmifind/loginModel.dart';
import 'package:pharmifind/loginService.dart';
import 'dashboard_one.page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pharmi Find',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: MyHomePage(title: 'Pharmi Find Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Account> _users;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final LocalStorage storage = LocalStorage('pharmifind');

  var _username = TextEditingController();
  var _password = TextEditingController();
  static const ROOT = 'http://192.168.0.25/DrugsDB/login.php';

  @override
  void initState() {
    super.initState();
    _users = [];
  }

  void _loginDet() {
    LoginService.verifyPassword(_username.text, _password.text).then((users) {
      setState(() {
        _users = users;
      });

      if (_users.isNotEmpty) {
        storage.setItem('username', _username.text);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardOnePage()),
        );
      }
    });
  }

  // Future<List<Account>> _verifyPassword() async {
  //   try {
  //     var map = Map<String, dynamic>();
  //     map['username'] = _username.text;
  //     map['password'] = _password.text;

  //     final response = await http.post(ROOT, body: map);
  //     if (200 == response.statusCode) {
  //       List<Account> list = parseResponse(response.body);
  //       if (list.isNotEmpty) {
  //        await Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => DashboardOnePage()),
  //         );
  //         return list;
  //       } else {
  //         print("Invalid username/username");
  //           return list;
  //       }
  //     } else {
  //        print("500r");
  //       return List<Account>();
  //     }
  //   } catch (e) {
  //      print("API DOWN");
  //     return List<Account>();
  //   }
  // }

  // static List<Account> parseResponse(String responseBody) {
  //   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  //   return parsed.map<Account>((json) => Account.fromJson(json)).toList();
  // }

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      controller: _username,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      controller: _password,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.orange,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          _loginDet();
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                SizedBox(
                  height: 150.0,
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  'PHARMI FIND',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 55.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButton,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
