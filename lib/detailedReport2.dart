// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
//if there are injuries and or not all poeple invloved are present call 911

class detailedReport2 extends StatefulWidget {
  @override
  _detailedReport2State createState() => _detailedReport2State();
}

class _detailedReport2State extends State<detailedReport2> {
  // Variables to track the selected yes/no for each option
  String? _option1;
  String? _option2;
  String? _option3;
  int _counter = 1;
  void _incrementCounter () {
    setState(() {
      _counter++;
    });
  }
  void _decrementCounter () {
    if (_counter-1 >= 1){
      setState(() {
        _counter--;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    final ScreenWidth = MediaQuery.sizeOf(context).width;
    final ScreenHeight = MediaQuery.sizeOf(context).height;



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5FA),
      ),
      backgroundColor: const Color.fromARGB(255, 235, 234, 234),
      body: Stack(
        children:[
          
          Container(
              height: ScreenHeight,
              width: ScreenWidth,
              color: Color(0xFF0A061F),
            ),
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                color:Color(0xFFF5F5FA),
                height: ScreenHeight,
                width: ScreenWidth,
              ),
            ),
            
         Padding(
           padding: const EdgeInsets.symmetric(vertical: 10 , horizontal: 25.0),
           child: Column(
            children: [
              Center(
                child: Text(
                  'Choose an option for each:',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              // Option 1
              
              // Option 2
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(child: Text("Is everyone involved present ?", style: TextStyle(fontSize:ScreenWidth*0.04, fontWeight: FontWeight.bold)),padding: EdgeInsets.only(left: 20 ,top: 12)),
                      ListTile(
                        title: const Text('Yes', style: TextStyle(fontWeight: FontWeight.bold)),
                        leading: Radio<String>(
                          activeColor: Color(0xFF0A061F),
                          value: 'Yes',
                          groupValue: _option2,
                          onChanged: (String? value) {
                            setState(() {
                              _option2 = value;
                              }
                            );
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('No', style: TextStyle(fontWeight: FontWeight.bold)),
                        leading: Radio<String>(
                          activeColor: Color(0xFF0A061F),
                          value: 'No',
                          groupValue: _option2,
                          onChanged: (String? value) {
                            setState(() {
                              _option2 = value;
                              }
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20, top : 20),
                        child: Text(
                          'Number of involved Cars : ',
                          style: TextStyle(fontSize: ScreenWidth*0.04, fontWeight: FontWeight.bold)
                        ),
                      ),
                            
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: (){
                              _decrementCounter();
                            },  
                            icon: Icon(Icons.remove_circle_outlined, size: 38 , color: Color(0xFF0A061F),)
                          ),
                          Center(
                            child: Text(
                              '$_counter',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _incrementCounter();
                            }, 
                            icon: Icon(Icons.add_circle_outlined, size : 38 ,color: Color(0xFF0A061F))
                          )
                        ],
                      ),
                      SizedBox(height: 15,)
                    ],
                  ),
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0A061F),
                            foregroundColor: Color(0xFFF5F5FA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 40),
                          ) ,
                      onPressed: () {
                        if(_option2 == null){
                           ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please fill the info"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                        else
                        if (_option2 == 'No') {
                           Navigator.of(context).popUntil(ModalRoute.withName('/'));
                      
                          showDialog(
                            barrierDismissible: true,
                            context: context, 
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              
                                title: Text('Can\'t report an accident', style: TextStyle(fontWeight: FontWeight.bold),),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Reason :'),
                                    Text.rich(
                                      TextSpan(
                                        text: 'Not all the members are present, ', // Normal text
                                        style: TextStyle( color: Colors.black), // Base text style
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Call 911', // Text to be bold
                                            style: TextStyle(fontWeight: FontWeight.bold), // Bold style
                                          ),
                                          TextSpan(
                                            text: ' for help', // Normal text
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red[300],
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.close_outlined),
                                      onPressed: (){
                                        Navigator.pop(context);
                                       
                                      }, 
                                    ),
                                  )
                                ],
                              );
                            }
                          );
                        }
                        else {
                          Navigator.pushNamed(
                            context, 
                            '/DR4',
                            arguments: <String, dynamic> {
                              'Lat' : data['lat'],
                              'Long' : data['long'],
                              'Inj' : _option1,
                              'Insurance' : _option3,
                              'Counter' : _counter
                            }
                          );
                        }
                      },
                      child: Text('Next' , style: TextStyle(color: Colors.white),),
                    ),
                ],
              ),
              SizedBox(height: ScreenHeight*0.17,)
            ],
                   ),
         ),
        ]
      ),
    );
  }
}



class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip( size) {
    var path = Path();

   path.lineTo(0, size.height * 0.8);

  path.quadraticBezierTo(
    size.width * 0.125, size.height * 0.73,   
    size.width * 0.5, size.height * 0.8      
  );

  path.quadraticBezierTo(
    size.width * 0.875, size.height * 0.87,  
    size.width, size.height * 0.8            
  );

  
  path.lineTo(size.width, 0);
  path.lineTo(0, 0); 
    path.close(); 
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}