import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  late double Latitude;
  late double Longitude; //location will be saved as a google maps link
  late String Status;
  late String Date_Time;
  late String Location;
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
  static String? authID;

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
  Future<AuthResponse> civSignIn (ID, password) async {
    try{
      final profileResponse = await supabase.from('User').select().eq('IdNumber', ID);
      if (profileResponse.isEmpty) {
        throw Exception('User with this ID number does not exist');
      }
      final email = '$ID@example.com';
      AuthResponse result = await supabase.auth.signInWithPassword(
        password: password,
        email: email
      );
      authID = result.user!.id;
      return result;
    }
    catch(e) {
      rethrow;
    }
  }
  Future<AuthResponse> officerSignIn (ID, password) async {
    try{
      final profileResponse = await supabase.from('Officer').select().eq('OfficerID', ID);
      if (profileResponse.isEmpty) {
        throw Exception('Officer with this ID number does not exist');
      }
      final email = '$ID-officer@example.com';
      AuthResponse result = await supabase.auth.signInWithPassword(
        password: password,
        email: email
      );
      authID = result.user!.id;
      return result;
    }
    catch(e) {
      rethrow;
    }
  }

  Future<void> signOut () async {
    try {
      await supabase.auth.signOut();
      authID = "";
    }
    catch(e) {
      rethrow;
    }
  }
}

//This list is to be implemented in the database