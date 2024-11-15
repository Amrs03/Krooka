// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krooka/AccidentInProgress.dart';
import 'package:krooka/OfficerPage.dart';
import 'package:krooka/detailedReport.dart';
import 'package:krooka/detailedReport4.dart';
import 'package:krooka/detailedReport5.dart';
import 'package:krooka/officerSignIn.dart';
import 'myVehicles.dart';
import 'globalVariables.dart';
import 'reportAccidents.dart';
import 'signInPage.dart';
import 'Wrapper/AuthWrapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'detailedReport2.dart';
import 'AcceptAccidentPage.dart';


class homePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) =>SignInPage(),
          '/Homepage' : (context) => MyHomePage(),
          '/DR2' : (context) => detailedReport2(),
          '/DR4' : (context) => detailedReport4(),
          '/DR5' : (context) => detailedReport5(),
          '/InProgress' : (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
            return InProgressWrapper(child: InProgress(data: args), accidentID: args['ID']);
          },
          '/AcceptAccident' : (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return acceptAccident(data: args); // Pass arguments to NewRoute
          }
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
  int selectedIndex = 1;

  //method to update the new selected index
  void navigateBottomBar(int index){
    setState(() {
      selectedIndex = index;
    });
  }
    void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  final pagesWithoutNavBar = [2]; // Example: hide nav bar on Logout page (index 2)
  
  final List pages = [
     AuthWrapper(child: MyVehicles()),
    //homepage
    MyHomePage(),
    //profile
   
    //setings
    SignInPage(),
    //toDoPage()
  ];
  @override
  Widget build(BuildContext context) {
    final ScreenHeight = MediaQuery.sizeOf(context).height;
    final ScreenWidth = MediaQuery.sizeOf(context).width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body : selectedIndex != 1 ? pages[selectedIndex] : 
        Center(
          child: Stack(
            children:[
              Container(
                height: ScreenHeight,
                width: ScreenWidth,
                color: Color(0xF5F5FA),
              ),
              ClipPath(
                clipper: WaveClipper2(),
                child: Container(
                  color:Color(0xFF0A061F),
                  height: ScreenHeight,
                  width: ScreenWidth,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/logo.png'), fit: BoxFit.contain, alignment: Alignment(0, -0.4)) 
                )
              ),
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 26, vertical: 20),
                  child: Center(child: Text('Welcome back!', style: TextStyle(fontSize: ScreenWidth*0.065, fontWeight: FontWeight.bold, color: Color(0xFF0A061F)))),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AuthWrapper(child: mapsWidget(),)),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                    padding: EdgeInsets.only(left : 40),
                    height: MediaQuery.sizeOf(context).height*0.13,
                    width : MediaQuery.sizeOf(context).width*0.96,
                    decoration: BoxDecoration(
                      color: Color(0xFF0A061F),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black12 , width:2),
                      
                    ),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Report Accident", style: TextStyle(fontSize: ScreenWidth*0.05 , fontWeight: FontWeight.bold, color: Colors.white)),
                          Icon(Icons.car_crash, size : ScreenWidth*0.12, color: Colors.white,),
                        ],
                      ),

                    ),
                  ),
                ),
                SizedBox(height: 20)
              ],
            ),
            ],
          ),
        ),
        
        bottomNavigationBar:
         StreamBuilder(
          stream: Supabase.instance.client.auth.onAuthStateChange,
          builder: (context, snapshot) {
            final authState = snapshot.data;
            if (authState != null) {
              final AuthChangeEvent event = authState.event;
              switch (event) {
                case AuthChangeEvent.signedIn:
                  return BottomNavigationBar(
                    backgroundColor: Color(0xFF0A061F),
                    unselectedItemColor: Colors.white,
                    selectedItemColor: Colors.blueAccent,
                    currentIndex: selectedIndex,
                    onTap: (index) async {
                      if (index == 2) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              title: Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold),),
                              content: Text('Are you sure you want to sign out '),
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Color(0xFF0A061F),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: Colors.black,
                                        width: 1
                                      )
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: ScreenWidth*0.06),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel' ,style: TextStyle(fontSize: ScreenWidth*0.035),),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[300],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: Colors.black,
                                        width: 1
                                      )
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: ScreenWidth*0.06),
                                  ),
                                  onPressed: () async {
                                    await _auth.signOut();
                                    await Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => SignInPage()),
                                      (Route<dynamic> route) => false
                                    );
                                  },
                                  child: Text('Sign Out',style: TextStyle(fontSize: ScreenWidth*0.035),),
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
                      _buildNavigationBarItem(
                        icon: Icons.person,
                        label: 'Profile',
                        isSelected: selectedIndex == 0,
                      ),
                      _buildNavigationBarItem(
                        icon: Icons.home,
                        label: 'Home',
                        isSelected: selectedIndex == 1,
                      ),
                      _buildNavigationBarItem(
                        icon: Icons.logout,
                        label: 'Logout',
                        isSelected: selectedIndex == 2,
                      ),
                    ],
                  );
                default:
                  return BottomNavigationBar(
                    backgroundColor: Color(0xFF0A061F),
                    unselectedItemColor: Colors.white,
                    selectedItemColor: Colors.blueAccent,
                    currentIndex: selectedIndex,
                    onTap: _onItemTapped,
                    type: BottomNavigationBarType.fixed,
                     
                    items: [
                      _buildNavigationBarItem(
                        icon: Icons.person,
                        label: 'Profile',
                        isSelected: selectedIndex == 0,
                      ),
                      _buildNavigationBarItem(
                        icon: Icons.home,
                        label: 'Home',
                        isSelected: selectedIndex == 1,
                      ),
                      _buildNavigationBarItem(
                        icon: Icons.login,
                        label: 'Login',
                        isSelected: selectedIndex == 2,
                      ),
                    ],
                  );
              }
            }
            return BottomNavigationBar(
              backgroundColor: Color(0xFF0A061F),
              unselectedItemColor: Colors.white,
              selectedItemColor: Colors.blueAccent,
              currentIndex: selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              items: [
                _buildNavigationBarItem(
                  icon: Icons.person,
                  label: 'Profile',
                  isSelected: selectedIndex == 0,
                ),
                _buildNavigationBarItem(
                  icon: Icons.home,
                  label: 'Home',
                  isSelected: selectedIndex == 1,
                ),
                _buildNavigationBarItem(
                  icon: Icons.login,
                  label: 'Login',
                  isSelected: selectedIndex == 2,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  BottomNavigationBarItem _buildNavigationBarItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: isSelected
          ? Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.4), // Background color
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 8 ,horizontal:15 ),
              child: Icon(icon, color: Colors.blueAccent),
            )
          : Icon(icon),
      label: label,
    );
  }
}


class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height-size.height*0.375); // Start at bottom-left
    
    // First upward curve
    path.quadraticBezierTo(
      size.width / 4, size.height - size.height*0.45,  // First control point for upward curve
      size.width / 2, size.height - size.height*0.45,   // Peak of the upward curve
    );

    // Second downward curve
    path.quadraticBezierTo(
      size.width*0.9 , size.height - size.height*0.45,    // Control point for downward curve
      size.width, size.height - size.height*0.55,       // Bottom-right of the curve
    );

    // Complete the path by drawing up to the top-right corner and closing the shape
    path.lineTo(size.width, 0); // Move to top-right corner
    path.lineTo(0, 0); // Back to top-left corner
    path.close(); // Complete the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}