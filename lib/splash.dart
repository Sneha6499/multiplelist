import 'dart:async';
import 'package:apilogin/logout.dart';
import 'package:apilogin/newpage.dart';
import 'package:apilogin/signup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _Splash();
}


class _Splash extends State<Splash> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2),
            ()=> checkLogin()
    );
  }
  void checkLogin()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String? val = pref.getString("login");
    if( val!=null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return LogOut(
            );
          },
        ),
            (raute) => false,
      );
    }
    else{
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return const SignupScreen(


            );
          },
        ),
            (raute) => false,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Home"));
  }
}