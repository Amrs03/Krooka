import 'package:flutter/material.dart';
import 'globalVariables.dart';


class reportAccidents extends StatefulWidget {
  @override
  _reportAccidentsState createState() => _reportAccidentsState();
}

class _reportAccidentsState extends State<reportAccidents> {

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
                title: Text("Detailed Report"),
                //onTap: , add the logic here
              ),
              ListTile(
                leading: Icon(Icons.car_rental),
                title: Text("Quick Report"),
                //onTap: , add the logic here
              )
            ],
          )
      ),

    );
  }
}



