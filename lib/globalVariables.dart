import 'package:flutter/material.dart';
import 'dart:convert';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/homePage');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
          //if logged in display sign out if not display sign in
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              // Implement logout functionality here
            },
          ),
        ],
      ),
    );
  }
}

class User {

  late String FirstName;
  late String LastName;
  late int IdNumber;
  late int PhoneNum;
  late DateTime DoB;
  late String passWord;

  User(this.FirstName, this.LastName, this.IdNumber, this.PhoneNum, this.DoB, this.passWord); //Constructor...We will get the values from the DB

  Map<String, dynamic> toJson() {
    return {
      'FirstName': FirstName,
      'LastName': LastName,
      'IdNumber' : IdNumber,
      'Phone number' : PhoneNum,
      'Date of birth' : DoB.toIso8601String(),
      'Password' : passWord
    };
  }
  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Accident {

  late int AccidentID;
  late String Location; //location will be saved as a google maps link
  late int NumberOfCars;
  late bool Injuries;
}

class Car {

  late int ChassisNumber;
  late int OwnerID;
  late String PlateType;
  late int PlateNumber;
}

class Officer {

  late int OfficerID;
  late String Name;
  late String Department; //or whatever the department format is
}

class Report {

  late int ReportID;
  late int OfficerID; //from officer
  late String ReportType;
  late int AccidentID;
  late String Description;
  late String Status;
}

class TowTrucks {

  late int TruckID;
  late String Name;
  late int PhoneNumber;
}

//This list is to be implemented in the database
List <User> registeredUsers = [];
