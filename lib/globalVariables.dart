import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';


String userID ="";

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

class AppUser {

  late String FirstName;
  late String LastName;
  late int IdNumber;
  late int PhoneNum;
  late DateTime DoB;
  late String passWord;

  AppUser(this.FirstName, this.LastName, this.IdNumber, this.PhoneNum, this.DoB, this.passWord); //Constructor...We will get the values from the DB

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

class AuthService {
  final supabase = Supabase.instance.client;

  Future<AuthResponse> signUp (email, password)async{
    try {
      final authResponse = await supabase.auth.signUp(
        password: password,
        email: email
      );
      return authResponse;
    }
    catch(e) {
      rethrow;
    }
  }
  Future<void> signIn (ID, password) async {
    try{
      final profileResponse = await supabase.from('User').select().eq('IdNumber', ID);
      if (profileResponse.isEmpty) {
        throw Exception('User with this ID number does not exist');
      }
      final email = '$ID@example.com';
      await supabase.auth.signInWithPassword(
        password: password,
        email: email
      );
      
    }
    catch(e) {
      rethrow;
    }

  }
}

//This list is to be implemented in the database
List <User> registeredUsers = [];
