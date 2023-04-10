import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'logout.dart';
import 'newpage.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var emailcontroller = TextEditingController();
  var passcontroller = TextEditingController();

  // final Function(bool?) _handleRemeberme;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();

    _loadUserEmailPassword();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 30),
                ),
                TextFormField(
                  controller: emailcontroller,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passcontroller,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.password)),
                ),
                SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () {
                    login();
                    _handleRemeberme();
                  },
                  icon: Icon(Icons.login),
                  label: Text("Login"),
                ),
                SizedBox(
                    height: 24.0,
                    width: 24.0,
                    child: Theme(
                      data: ThemeData(
                          unselectedWidgetColor: Color(0xff00C8E8) // Your color
                          ),
                      child: Checkbox(
                          activeColor: Color(0xff00C8E8),
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value!;
                            });
                          }),
                    )),
                SizedBox(width: 10.0),
                Text("Remember Me",
                    style: TextStyle(
                        color: Color(0xff646464),
                        fontSize: 12,
                        fontFamily: 'Rubic'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loadUserEmailPassword() async {
    print("Load Email");
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      bool? _remeberMe = _prefs.getBool("remember_me");

      print(_remeberMe);
      print(_email);
      print(_password);
      _remeberMe == true
          ? setState(() {
              _isChecked = _remeberMe!;
              emailcontroller.text = _email;
              passcontroller.text = _password;
            })
          : null;
    } catch (e) {
      print(e);
    }
  }

  void login() async {
    if (passcontroller.text.isNotEmpty && emailcontroller.text.isNotEmpty) {
      var response = await http.post(Uri.parse("https://reqres.in/api/login"),
          body: ({
            "email": emailcontroller.text,
            "password": passcontroller.text
          }));
      if (response.statusCode == 200) {

        pageRoute('token');
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("invalid")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Blank value")));
    }
  }

  void pageRoute(String token) async {
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    await pref1.setString("login", token);
    _loadUserEmailPassword();

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return LogOut();
    }), (route) => false);
  }

  void _handleRemeberme() {
    print("Handle Rember Me");
    //_isChecked = value!;
    SharedPreferences.getInstance().then(
      (prefs) {
        //   if(_isChecked == true){
        prefs.setBool("remember_me", _isChecked);
        prefs.setString('email', emailcontroller.text);
        prefs.setString('password', passcontroller.text);
        //  }
        //else {
        // }
      },
    );
    //
    // );
  }
}
