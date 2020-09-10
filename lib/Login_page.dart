import 'dart:convert';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Otp.dart';
import 'Registration.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isLoading = false;



  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      appBar: AppBar(
        title: Text("Code Land", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>RegisterPage()), (Route<dynamic> route) => false);
            },
            child: Text("Register", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.teal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            headerSection(),
            textSection(),
            buttonSection(),
          ],
        ),
      ),
    );
  }

  sendotp(String phone_number) async {
    Map data = {
      "phone_number": phone_number,
    };


    var jsonResponse = null;
    var response = await http.post("https://calendlio.sarayulabs.com/api/verification/phone",
        headers: {HttpHeaders.authorizationHeader:"9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b"},
        body: data
    );
    if(response.statusCode == 204) {
      print("NO content");


      if(jsonResponse == null) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Sendotp()), (Route<dynamic> route) => false);
      }
    }
    else {
      setState(() {
        _isLoading = false;
        jsonResponse=json.decode(response.body);
      });
      print(response.body);
    }


  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed: phone_numberController.text == "" ? null : () {
          setState(() {
            _isLoading = true;

          });
            sendotp(phone_numberController.text);

        },
        elevation: 0.0,
        color: Colors.purple,
        child: Text("send otp", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  final TextEditingController phone_numberController = new TextEditingController();

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[

          TextFormField(
                controller: phone_numberController,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white70),
                decoration: InputDecoration(
                  icon: Icon(Icons.phone, color: Colors.white70),
                  hintText: "Phone Number",
                  border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                  hintStyle: TextStyle(color: Colors.white70),


                ),



          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child:Text(
              "Enter Country Code with + Sign is must",
              style: TextStyle(color: Colors.yellow ,fontSize:12.0,fontStyle: FontStyle.italic),

            ),
          ),

        ],
      ),
    );
  }
  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("Code Land",
          style: TextStyle(
              color: Colors.white70,
              fontSize: 40.0,
              fontWeight: FontWeight.bold)),
    );
  }
}
