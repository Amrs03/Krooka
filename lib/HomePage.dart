import 'package:flutter/material.dart';
import 'globalVariables.dart';
import 'reportAccidents.dart';
import 'registerPage.dart';
class homePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      endDrawer: AppDrawer(),
      body: Center(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.car_crash),
              title: Text("Report Accident"),
              onTap: () {
                // Navigate to another page when the ListTile is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => reportAccidents()),
                );
              }
            ),
            ListTile(
              leading: Icon(Icons.car_rental),
              title: Text("My Vehicles"),
              onTap: () {
                print('My Vehicles');
              },
              //onTap: , add the logic here
            ),
            ListTile(
              leading: Icon(Icons.recent_actors),
              title: Text("Past Accidents"),
              //onTap: , add the logic here
            ),
            ListTile(
              leading: Icon(Icons.recent_actors),
              title: Text("Past Accidents"),
              //onTap: , add the logic here
            ),
            Expanded(child: Container()),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text("Register"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => registerPage()),
                );
              },
              //onTap: , add the logic here
            ),

          ],
        ),
      ),

    );
  }
}



