import 'package:flutter/material.dart';
import 'package:pharmifind/admin/adminDashboard.dart';
import 'package:pharmifind/loginModel.dart';
import 'package:pharmifind/loginService.dart';
import 'package:pharmifind/register.dart';
import 'dashboard_one.page.dart';
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
  var errorMsg = "";
  static const ROOT = 'http://pharmifind.ginomai.co.zw/login.php';

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
        if (_username.text == "admin") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardOnePage()),
          );
        }
      } else {
        this.setState(() {
          errorMsg = "Invalid username or password";
        });
      }
    });
  }

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
      color: Colors.blueAccent,
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

    final registerButton = Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.grey,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RegisterPage()));
        },
        child: Text("Register new account",
            textAlign: TextAlign.center,
            style: style.copyWith(color: Colors.white)),
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
                Text(errorMsg,
                    style: TextStyle(
                        color: Colors.red,
                        fontStyle: FontStyle.italic,
                        fontSize: 12)),
                SizedBox(height: 10.0),
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
                registerButton
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
