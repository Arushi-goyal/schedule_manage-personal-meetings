import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';




class profile extends StatefulWidget {
  @override
  _profileState createState() => _profileState();
}
class _profileState extends State<profile> {
  Map mapResponse;
  Future fetchData() async{
    http.Response response;
    response=await http.get('https://calendlio.sarayulabs.com/api/me',
        headers: {HttpHeaders.proxyAuthenticateHeader:"9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b"} );

    if(response.statusCode==200){
      print("good");
      setState(() {
        mapResponse= json.decode(response.body);
      });
    }
  }


  @override
  void initState(){
    fetchData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(icon: new Icon(Icons.arrow_back),
            color:Colors.white,
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
            }
        ),
        title: Text("Profile"),

      ),
        body:
        mapResponse ==null?Container():Text(

          mapResponse["first_name"].toString(),
          style:TextStyle(fontSize: 20),
        ),








    );
  }




}

