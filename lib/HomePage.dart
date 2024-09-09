import 'package:flutter/material.dart';
import 'globalVariables.dart';

void main() {
  runApp(homePage());
}

class homePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page'),
    Text('Report Accident'),
    Text('Profile Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      endDrawer: AppDrawer(),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(height: 120.0),
            ListTile(
              leading: Icon(Icons.car_crash),
              title: Text("Report Accident"),
              //onTap: , add the logic here
            ),
            ListTile(
              leading: Icon(Icons.car_rental),
              title: Text("My Vehicles"),
              //onTap: , add the logic here
            ),
            ListTile(
              leading: Icon(Icons.recent_actors),
              title: Text("Past Accidents"),
              //onTap: , add the logic here
            )
          ],
        )
      ),

    );
  }
}



