import 'package:flutter/material.dart';
import 'globalVariables.dart';
import 'detailedReport.dart';
import 'Wrapper/AuthWrapper.dart';


class reportAccidents extends StatefulWidget {
  @override
  _reportAccidentsState createState() => _reportAccidentsState();
}

class _reportAccidentsState extends State<reportAccidents> {

  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.sizeOf(context).width;
    final ScreenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(),
      body: Center(
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>AuthWrapper(child: mapsWidget(),))
                    );
                  },
                  child: Container(
                    height: ScreenHeight*0.22,
                    width: ScreenWidth*0.45,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text("Detailed Report" , style: TextStyle(
                            fontSize: ScreenWidth*0.05,
                            fontWeight: FontWeight.bold
                            
                          ),textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                    
                  ),
                ),
              ],
            ),
            Container(
              height: ScreenHeight*0.22,
                    width: ScreenWidth*0.45,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text("Quick Report",style: TextStyle(
                      fontSize: ScreenWidth*0.05,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                    )
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}



