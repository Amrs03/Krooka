import 'package:flutter/material.dart';
import 'globalVariables.dart';
import 'reportAccidents.dart';
import 'registerPage.dart';
import 'signInPage.dart';
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
  int selectedIndex=0;

  //method to update the new selected index
  void navigateButtomBar(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  final List pages = [
    //homepage
    MyHomePage(),
    //profile
    reportAccidents(),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: navigateButtomBar,
        type: BottomNavigationBarType.fixed,
        items:[
          //home
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home',),

          //profile
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile',),

          //Login
          BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login',),
        ]
      )
    );
  }
}



