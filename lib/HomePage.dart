// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:krooka/OfficerPage.dart';
import 'package:krooka/detailedReport4.dart';
import 'package:krooka/detailedReport5.dart';
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
          '/DR4' : (context) => detailedReport4(),
          '/DR5' : (context) => detailedReport5()
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
  int selectedIndex = 0;

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
    final ScreenHeight = MediaQuery.sizeOf(context).height;
    final ScreenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body : selectedIndex != 0 ? pages[selectedIndex] : 
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => reportAccidents()),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                padding: EdgeInsets.only(left : 40),
                height: MediaQuery.sizeOf(context).height*0.15,
                width : MediaQuery.sizeOf(context).width*0.96,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black12 , width:2),
                  boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade500, // Shadow color with opacity
                                    spreadRadius: 1, // How wide the shadow spreads
                                    blurRadius: 7, // How soft the shadow looks
                                    offset: Offset(4.0, 4.0), // Horizontal and vertical shadow offset
                                  ),
                                  BoxShadow(
                                    color: Colors.white, // Shadow color with opacity
                                    spreadRadius: 1, // How wide the shadow spreads
                                    blurRadius: 7, // How soft the shadow looks
                                    offset: Offset(-4.0, -4.0), // Horizontal and vertical shadow offset
                                  ),
                                ],
                ),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.car_crash, size : 50),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("Report Accident", style: TextStyle(fontSize: ScreenWidth*0.05 , fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: Container(
                    height: ScreenHeight*0.18,
                    width: ScreenWidth*0.42,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12, width: 2),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade500, 
                                    spreadRadius: 1,
                                    blurRadius: 7, 
                                    offset: Offset(4.0, 4.0), 
                                  ),
                                  BoxShadow(
                                    color: Colors.white,
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: Offset(-4.0, -4.0), 
                                  ),
                                ],
                
                    ),
                    child: Center(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.directions_car ,size: 45),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text("My Vehicles", style: TextStyle(fontSize: ScreenWidth*0.04 , fontWeight: FontWeight.bold) , textAlign: TextAlign.center,),
                            ),
                          ],
                        ),
                         
                      ),
                    ),
                  )
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OfficerPage()),
                    );
                  },
                  child: Container(
                    height: ScreenHeight*0.18,
                    width: ScreenWidth*0.42,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12, width: 2),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade500, 
                                    spreadRadius: 1, 
                                    blurRadius: 7, 
                                    offset: Offset(4.0, 4.0), 
                                  ),
                                  BoxShadow(
                                    color: Colors.white,
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: Offset(-4.0, -4.0),
                                  ),
                                ],
                
                    ),
                    child: Center(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.recent_actors ,size: 45),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text("Accidents", style: TextStyle(fontSize: ScreenWidth*0.04,  fontWeight: FontWeight.bold) , textAlign: TextAlign.center,),
                            ),
                          ],
                        ),
                         
                      ),
                    ),
                  )
                ),
              ],
            ),
            SizedBox(height: 20,)
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
                                    setState(() {
                                      selectedIndex = 0;
                                    });
                                    Navigator.of(context).pop();
                                    await _auth.signOut();
                                    print('AuthID : ${AuthService.authID}');
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


