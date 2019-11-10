import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'mainPage.dart';
import 'api.dart';
import 'googleButton.dart';

class SignInPage extends StatefulWidget{

  SignInPage();
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  Future<List<dynamic>> getPreviousEvents() async {
    var url = "https://www.thesportsdb.com/api/v1/json/1/eventslast.php?id=133738";
    var response = await http.get(url);
    var events_json = jsonDecode(response.body);
    events_json = events_json["results"];
    return events_json;
  }

  void allEves(context) async {
    var eves = await getPreviousEvents();
    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(eves)));
  }

  Future<bool> _loginUser() async {
    final api = await FBApi.signInWithGoogle();
    if (api != null) {
      return true;
    } else {
      return false;
    }
  }
  
 BoxDecoration _buildBackground() {
      return BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/ucl_logo.jpg"),
          fit: BoxFit.cover,
        ),
      );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Sports One")
      // ),
      body:
      Container(
        decoration: _buildBackground(),
        child:
        Center(
          child: 
        Column(
          children: <Widget>[
            SizedBox(height: 100,),
            Text("SPORTS ONE", style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 40, color: Colors.white),),
            SizedBox(height: 200,),
            GoogleSignInButton(
                onPressed:() async {
                  bool b = await _loginUser();

                            b
                                ? allEves(context)
                                : Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Wrong Email!'),
                                      ),
                                    );
                  },
              )
          ],
        ))) 
    );
  }
}