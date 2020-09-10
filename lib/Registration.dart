import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'Login_page.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
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

  register(String first_name, String last_name, String address, String phone_number, String email) async {

    Map data = {
      "first_name":first_name,
      "last_name":last_name,
      'address':address,
      "phone_number":phone_number,
      "email":email,
    };
    var jsonResponse = null;
    var response = await http.post("https://calendlio.sarayulabs.com/api/auth/register",
        headers: {HttpHeaders.authorizationHeader: "9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b"} ,
        body: data
    );
    if(response.statusCode == 201) {

      jsonResponse = json.decode(response.body);

      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
      }
    }
    else {
      setState(() {
        _isLoading = false;
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
        onPressed: emailController.text == ""||phone_numberController.text==""||first_nameController.text==''||addressController.text==''? null : () {
          setState(() {
            _isLoading = true;
          });

            register(first_nameController.text,last_nameController.text,addressController.text,phone_numberController.text,emailController.text,);

          },


        elevation: 0.0,
        color: Colors.purple,
        child: Text("Register", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }
  final TextEditingController first_nameController = new TextEditingController();
  final TextEditingController last_nameController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();
  final TextEditingController phone_numberController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();


  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
            TextFormField(
              controller: first_nameController,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                hintText: "First Name",
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70),
              ),
            ),

          SizedBox(height: 30.0),
          TextFormField(
            controller: last_nameController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              hintText: "Last Name",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),

          SizedBox(height: 30.0),
          TextFormField(
            controller:addressController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              hintText: "Address",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),

          SizedBox(height: 30.0),

          TextFormField(
            controller: phone_numberController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.phone, color: Colors.white70),
              hintText: "Pho. No.",
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

          SizedBox(height: 30.0),
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.mail, color: Colors.white70),
              hintText: "email",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
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
