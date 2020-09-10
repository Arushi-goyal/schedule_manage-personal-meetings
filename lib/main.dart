import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Enter_Event.dart';
import 'Login_page.dart';
import 'Otp.dart';
import 'Registration.dart';
import 'profile.dart';
import 'package:table_calendar/table_calendar.dart';


void main() => runApp(MyApp());
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Code Land",
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(
          accentColor: Colors.white70,

      ),

    );
  }
}

class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  CalendarController _controller;
  SharedPreferences sharedPreferences;

@override
  void initState() {
    super.initState();
    checkLoginStatus();
    _controller=CalendarController();
  }

   checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString('auth_token') == null) {
      print(sharedPreferences);
       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Code Land", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          //button for log out
          FlatButton(
            onPressed: () {
              sharedPreferences.clear();
              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
            },
            child: Text("Log Out", style: TextStyle(color: Colors.white)),
          ),

         //button for add events
          FlatButton(

            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Event()), (Route<dynamic> route) => false);
            },
            child: Text("Add", style: TextStyle(color: Colors.white)),
          ),

          //button for profile
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => profile()), (Route<dynamic> route) => false);
            },
            child: Text("Profile", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body:SingleChildScrollView(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              calendarStyle: CalendarStyle(
                todayColor: Colors.orange,
                selectedColor: Theme.of(context).primaryColor
              ),
            calendarController: _controller,)

          ],
        )

      )
    );
  }
}