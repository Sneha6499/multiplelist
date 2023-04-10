

import 'dart:convert';

import 'package:apilogin/signup.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'note.dart';

class NewPage extends StatefulWidget {
  NewPage({Key? key}) : super(key: key);

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  String token = "";
  List<dynamic> users = [];
  List<dynamic> users1 = [];


  @override
  void initState() {

    super.initState();
    getCred();
    fetchUsers();
    fetchUsers1();

  }

  Future<void> getCred() async {
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    setState(() {
      token = pref1.getString("login")!;
    }
    );
  }
  //var uri = new Uri.http("example.org", "/path", { "q" : "{http}" });
  Future<void> fetchUsers() async {
    print("fetchUsers called");
    const url1 = "https://reqres.in/api/users?page=1";
    final uri1 = Uri.parse(url1);
    final response = await http.get(uri1);

    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users = json['data'];
    });}

  Future<void> fetchUsers1() async {
    print("fetchUsers2 called");
    const url2 = "https://reqres.in/api/users?page=2";
    final uri2 = Uri.parse(url2);
    final response = await http.get(uri2);

    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users1 = json['data'];
    });}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop:()=> _dialogBox(context),


      child: Material(
        child: Column(
            children: [
              SizedBox(
                height: 60,

              ),
              Padding(
                padding: const EdgeInsets.only(left: 220.0),
                child: OutlinedButton.icon(onPressed: () async {
                  SharedPreferences pref1 = await SharedPreferences
                      .getInstance();
                  await pref1.remove('login');

                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return SignupScreen();
                      }
                      ),
                          (route) => false);
                },
                  icon: Icon(Icons.login),
                  label: Text("Logout"),
                ),
              ),
              Expanded(

                child: ListView.builder(

                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final firstName = user['first_name'];
                      final lastName = user['last_name'];
                      final email = user['email'];
                      final imageurl = user['avatar'];
                      return ListTile(

                        //leading: Text("${index+1}"),
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(100),

                            child: Image.network(imageurl)),
                        //child: Text('${index+1}')),
                        title: Text(firstName + " " + lastName),
                        subtitle: Text(email)
                        ,
                      );
                    }


                ),



              ),
              Expanded(

                child: ListView.builder(

                    itemCount: users1.length,
                    itemBuilder: (context, index) {
                      final user = users1[index];
                      final firstName = user['first_name'];
                      final lastName = user['last_name'];
                      final email = user['email'];
                      final imageurl = user['avatar'];
                      return ListTile(

                        //leading: Text("${index+1}"),
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(100),

                            child: Image.network(imageurl)),
                        //child: Text('${index+1}')),
                        title: Text(firstName + " " + lastName),
                        subtitle: Text(email)
                        ,
                      );
                    }


                ),

              )
            ]
        ),
      ),
    );
  }


  Future<bool>_dialogBox(BuildContext context) async{
    bool? exitApp = await showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text("Really ??"),
            content: const Text("Do You want to closs the app"),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop(false);
              },
                  child: const Text("No")),
              TextButton(onPressed: (){
                Navigator.of(context).pop(true);
              },
                  child: const Text("Yes"))
            ],
          );
        });
    return exitApp ?? false;
  }

}


