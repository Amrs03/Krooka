// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:krooka/detailedReport4.dart';
import 'myVehicles.dart';
import 'globalVariables.dart';
import 'reportAccidents.dart';
import 'signInPage.dart';
import 'Wrapper/AuthWrapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'detailedReport2.dart';
class homePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
        routes: {
          '/DR2' : (context) => detailedReport2(),
          '/DR4' : (context) => detailedReport4()
        } ,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthService _auth = AuthService();
  int selectedIndex=0;

  //method to update the new selected index
  void navigateBottomBar(int index){
    setState(() {
      selectedIndex = index;
    });
  }
  final List pages = [
    //homepage
    MyHomePage(),
    //profile
    AuthWrapper(child: MyVehicles()),
    //setings
    SignInPage(),
    //toDoPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body : selectedIndex != 0 ? pages[selectedIndex] : 
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => reportAccidents()),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                padding: EdgeInsets.only(left : 40),
                height: MediaQuery.sizeOf(context).height*0.15,
                width : MediaQuery.sizeOf(context).width*0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)
                  )
                ),
                child: Center(
                  child: ListTile(
                    leading: Icon(Icons.car_crash, size : 50),
                    title: Text("Report Accident", style: TextStyle(fontSize: 28)),
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                padding: EdgeInsets.only(left : 40),
                height: MediaQuery.sizeOf(context).height*0.15,
                width : MediaQuery.sizeOf(context).width*0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)
                  )
                ),
                child: Center(
                  child: ListTile(
                    leading: Icon(Icons.car_rental, size: 50),
                    title: Text("My Vehicles", style: TextStyle(fontSize: 30)), 
                  ),
                ),
              )
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                padding: EdgeInsets.only(left : 40),
                height: MediaQuery.sizeOf(context).height*0.15,
                width : MediaQuery.sizeOf(context).width*0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)
                  )
                ),
                child: Center(
                  child: ListTile(
                    leading: Icon(Icons.recent_actors, size: 50),
                    title: Text("Past Accidents", style: TextStyle(fontSize: 30)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          final authState = snapshot.data;
          if (authState != null) {
            final AuthChangeEvent event = authState.event;
            switch (event) {
              case AuthChangeEvent.signedIn:
                return BottomNavigationBar(
                  currentIndex: selectedIndex,
                  onTap: (index) async {
                    if (index == 2) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Sign Out'),
                            content: Text('Are you sure you want to sign out?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Close the dialog without signing out
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  // Proceed with sign out
                                  try {
                                    await _auth.signOut();
                                    print('AuthID : ${AuthService.authID}');
                                    setState(() {
                                      selectedIndex = 0;
                                    });
                                    // Close the dialog after sign out
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to sign out, please try again')),
                                    );
                                    print('Error signing out: ${e.toString()}');
                                    Navigator.of(context).pop(); // Close the dialog even if sign-out fails
                                  }
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      setState(() {
                        selectedIndex = index;
                      });
                    }
                  },
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
                    BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
                  ]
                );
              default:
                return BottomNavigationBar(
                  currentIndex: selectedIndex,
                  onTap: navigateBottomBar,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
                    BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login')
                  ]
              );
            }
          }
          return BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: navigateBottomBar,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login')
            ]
          );
        }
      )
    );
  }
}


