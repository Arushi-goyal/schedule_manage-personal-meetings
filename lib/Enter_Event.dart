import 'dart:convert';
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:schedule_manage_meeting/main.dart';
import 'package:http/http.dart' as http;





class Event extends StatefulWidget {
  @override
  _EventState createState() => _EventState();
}
class _EventState extends State<Event> {
  bool _isLoading = false;
  final format = DateFormat("yyyy-MM-dd HH:mm:ss:ms");

   @override
  Widget build(BuildContext context) {
     //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      appBar: AppBar(
        title:Text("event"),
        leading: new IconButton(icon: new Icon(Icons.arrow_back),
            color:Colors.white,
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
                    }
      ),
      ),
      body:
        Container(
            child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
                children: <Widget>[
                  headerSection(),
                  textSection(),
                  buttonSection(),
                ],
            ),

     )
    );
  }

  event(String description, String start_datetime, String end_datetime) async {

    Map data = {
      'description':description,
      'start_datetime':start_datetime,
      "end_datetime":end_datetime

    };
    var jsonResponse = null;
    var response = await http.post("https://calendlio.sarayulabs.com/api/bookings",
        headers: {HttpHeaders.proxyAuthenticateHeader: "9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b"} ,
        body: data
    );
    if(response.statusCode == 201) {
      print("Created");
      jsonResponse = json.decode(response.body);
      print(jsonResponse);


      if(jsonResponse != null) {
        setState(() {
          _isLoading=false;
        });
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
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
        onPressed:descriptionController.text==""|| start_datetimeController.text== ""||end_datetimeController.text==""? null : () {
          // setState(() {
          //   //event(descriptionController.text, start_datetimeController.text, end_datetimeController.text);
          // });
          event(descriptionController.text, start_datetimeController.text, end_datetimeController.text);
        },
        elevation: 0.0,
        color: Colors.purple,
        child: Text("Add Event", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }





  final TextEditingController descriptionController = new TextEditingController();
  final TextEditingController start_datetimeController =new TextEditingController();
  final  TextEditingController end_datetimeController= new TextEditingController();
  Container textSection() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
    child: Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
      ),
      SizedBox(height: 10,width:0.6,
      ),
      TextField(
        controller: descriptionController,
        decoration: InputDecoration(
          hintText: "Add Event",
          //fillColor: Colors.grey,
          //focusColor: Colors.grey,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueAccent,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),

      ),
      Padding(
        padding:EdgeInsets.all(10.0),
      ),
      //Text("Start-datetime(${format.pattern})"),
      SizedBox(height:6,width:2.0),
      DateTimeField(
        controller: start_datetimeController,
        decoration: InputDecoration(
          hintText: "Start Event",
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        format: format,
        onShowPicker: (context, currentValue) async{
          final date=await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100)
          );
          if (date!=null){
            final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );var dateTime = DateTimeField.combine(date, time);
            return dateTime;
          }else{

            return currentValue;
          }
        },
      ),

      Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),

      ),
      Padding(
        padding:EdgeInsets.all(10.0),
      ),

      SizedBox(height:6,width:2.0),
      DateTimeField(
        controller: end_datetimeController,
        decoration: InputDecoration(
          hintText: "End Event",
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        format: format,
        onShowPicker: (context, currentValue) async{
          final date=await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100)
          );
          if (date!=null){
            final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );var dateTime = DateTimeField.combine(date, time);
            return dateTime;
          }else{

            return currentValue;
          }
        },
      ),

     ],
    ),
    );
  }


  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("Add Event",
          style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 40.0,
              fontWeight: FontWeight.bold)),
    );
  }





}

