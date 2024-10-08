// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:krooka/globalVariables.dart';
import 'package:krooka/pastAccidnets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'AddCar.dart';


class MyVehicles extends StatefulWidget {
  const MyVehicles({super.key,});


  @override
  State<MyVehicles> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyVehicles> {
  
  int MyitemCount = 0;
  final supabase = Supabase.instance.client;
  String aId = AuthService.authID!;

  String? FirstName;
  String? LastName;
  String? DoB;
  String? PhoneNumber;

  List<int> chassisNumbers = [];


  @override
  void initState(){
    super.initState();
    _getUserInfo();
    _getCars();
  }
  
  Future<void> _getUserInfo() async {
    dynamic response = await supabase.from('User').select().eq('AuthID', aId).single();
    setState(() {
      FirstName = response["FirstName"] as String?;
      LastName = response["LastName"] as String?;
      DoB = DateTime.parse(response["DoB"]).toIso8601String().split('T')[0] ;
      PhoneNumber = response["PhoneNum"] as String?;
    });
    }

  Future<List<Map<String, dynamic>>> _getCars() async {
    final uid = await supabase.from("User").select().eq("AuthID", aId).single();
    final response = await supabase.from("Have").select().eq("IdNumber", uid["IdNumber"]);
    final result = response.map<Map<String, dynamic>>((car) => car as Map<String, dynamic>).toList();
    print("GetCars: $result");
    return result;
    
  }

  Future<Map<String, dynamic>> _getCarDetails(int chassisNumber) async {
    final car = await supabase.from("Car").select().eq("ChassisNumber", chassisNumber).single();
    print("getCarDetails: $car");
    return car;
  }
  void _refreshCars() {
  setState(() {
    _getCars();
  });
}

Future<void> _deleteCar(int chassisNumber) async {
  try{
    final uid = await supabase.from("User").select().eq("AuthID", aId).single();
    await supabase.from("Have").delete().eq('ChassisNumber', chassisNumber).eq('IdNumber', uid["IdNumber"]); 
    print("Car deleted from 'Have' table as it had no more associations.");

    final response = await supabase
      .from("Have")
      .select('IdNumber')
      .eq('ChassisNumber', chassisNumber);
    print("Response from Have table: ${response}");

    if (response.isEmpty) {
    await supabase.from("Car").delete().eq('ChassisNumber', chassisNumber);
    print("Car deleted from Car table as it had no more associations.");
    
    } else {
      print("Car still has other users; it will not be deleted from the Car table.");
    }
    setState(() {});
  }
  catch(e){
    print("Error: ${e.toString()}");
  }
}

  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.sizeOf(context).width;
    final ScreenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 7, bottom: 3),
            height: ScreenHeight *0.05,
            color: const Color.fromARGB(255, 248, 200, 57),
            child: Center(
              child: Text("Profile" ,style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ),
          Stack(
            children:[
              Container(
                height: ScreenHeight*0.17,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 248, 200, 57),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))
                ),
              )
              ,Center(
                child: Container(
                width: ScreenWidth *0.75,
                height: ScreenHeight*0.2,
                margin: EdgeInsets.only(top:ScreenHeight *0.06),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color.fromARGB(255, 255, 192, 3), width: 2),
                  boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Slightly transparent shadow
                    spreadRadius: 5, // How much the shadow spreads
                    blurRadius: 10, // Smoothens the edges of the shadow
                    offset: Offset(0, 5), // Horizontal and vertical shadow offset
                  ),
                ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Column(
                      
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0,),
                          child: Row(
                            children: [
                              Icon(Icons.person_2_outlined),
                              SizedBox(width:ScreenWidth*0.03),
                              Text(" $FirstName $LastName" , style: TextStyle(fontSize: ScreenWidth*0.03 ,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            children: [
                              Icon(Icons.cake_outlined),
                              SizedBox(width:ScreenWidth*0.03),
                              Text(" $DoB",style: TextStyle(fontSize: ScreenWidth*0.03 ,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            children: [
                              Icon(Icons.phone_outlined),
                              SizedBox(width:ScreenWidth*0.03),
                              Text(" $PhoneNumber" ,style: TextStyle(fontSize: ScreenWidth*0.03 , fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                       
                      ],
                    ),
                    
                  ],
                ),
                
                            ),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color:  const Color.fromARGB(255, 255, 192, 3) , width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Slightly transparent shadow
                        spreadRadius: 2, // How much the shadow spreads
                        blurRadius: 10, // Smoothens the edges of the shadow
                        offset: Offset(0, -5), // Horizontal and vertical shadow offset
                      ),
                    ],
                  
                  ),
                  child: CircleAvatar(
                    radius: ScreenWidth *0.11,
                    backgroundColor: Colors.white,
                    child:Icon(Icons.person_2 , size: ScreenWidth*0.15,color: Colors.black,)
                  ),
                ),
              ),
            ]
          ),
          Container(
            margin: EdgeInsets.only(left: 30, top: 15),
            child: Text("My Cars ", style: TextStyle(fontSize: ScreenWidth*0.05 , fontWeight: FontWeight.bold),),
          ),

          
          Container(
                  margin: EdgeInsets.all(10),
                  height: ScreenHeight * 0.55,
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _getCars(),
                    builder: (context, carSnapshot) {
                      if (carSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (carSnapshot.hasError) {
                        return Center(child: Text("Error: ${carSnapshot.error}"));
                      } else {
                        final cars = carSnapshot.data!;
                        return ListView.builder(
                          itemCount: cars.length + 1,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            if (index == cars.length) {
                              return Container(
                                width: ScreenWidth * 0.8,
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Add a Car",
                                        style: TextStyle(fontSize: 20, color: Colors.grey[500]),
                                      ),
                                      SizedBox(height: 30),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey[600]!, width: 2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => AddCar()),
                                            ).then((dynamic){
                                              _refreshCars();
                                            });
                                          },
                                          child: Icon(
                                            Icons.add,
                                            size: 50,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              final car = cars[index];
                              
                              return FutureBuilder<Map<String, dynamic>>(
                                future: _getCarDetails(car['ChassisNumber']),
                                builder: (context, carDetailSnapshot) {
                                  if (carDetailSnapshot.connectionState == ConnectionState.waiting) {
                                    return Container(
                                      width: ScreenWidth * 0.8,
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else if (carDetailSnapshot.hasError) {
                                    return Container(
                                      width: ScreenWidth * 0.8,
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Center(
                                        child: Text("Error: ${carDetailSnapshot.error}"),
                                      ),
                                    );
                                  } else {
                                    final carDetails = carDetailSnapshot.data!;
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      width: ScreenWidth * 0.8,
                                      height: ScreenHeight * 0.5,
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(color: const Color.fromARGB(255, 255, 192, 3), width: 2 ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2), // Slightly transparent shadow
                                            spreadRadius: 1, // How much the shadow spreads
                                            blurRadius: 10, // Smoothens the edges of the shadow
                                            offset: Offset(0, 5), // Horizontal and vertical shadow offset
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              "Car ${index + 1}",
                                              style: TextStyle(fontSize: ScreenWidth * 0.05, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(height: ScreenHeight * 0.01),
                                          Padding(
                                            padding: const EdgeInsets.all(9.0),
                                            child: Row(
                                              //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Manufacturer:\u00A0",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenWidth * 0.035, color: Colors.white,
                                                      shadows: [
                                                        Shadow(
                                                          offset: Offset(-1, -1),
                                                          color: Colors.black, // Black shadow on the top-left
                                                          blurRadius: 1.5,
                                                        ),
                                                        Shadow(
                                                          offset: Offset(1, -1),
                                                          color: Colors.black, // Black shadow on the top-right
                                                          blurRadius: 1.5,
                                                        ),
                                                        Shadow(
                                                          offset: Offset(1, 1),
                                                          color: Colors.black, // Black shadow on the bottom-right
                                                          blurRadius: 1.5,
                                                          
                                                        ),
                                                          Shadow(
                                                            offset: Offset(-1, 1),
                                                            color: Colors.black, // Black shadow on the bottom-left
                                                            blurRadius: 1.5,
                                                          ),
                                                        ]
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  carDetails["Manufacturer"].toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenWidth * 0.045 ,),
                                                ),
                                                Spacer()
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(9.0),
                                            child: Row(
                                              //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Model: ",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenWidth * 0.035,color: Colors.white,
                                                    shadows: [
                                                      Shadow(
                                                        offset: Offset(-1, -1),
                                                        color: Colors.black, // Black shadow on the top-left
                                                        blurRadius: 1.5,
                                                      ),
                                                      Shadow(
                                                        offset: Offset(1, -1),
                                                        color: Colors.black, // Black shadow on the top-right
                                                        blurRadius: 1.5,
                                                      ),
                                                      Shadow(
                                                        offset: Offset(1, 1),
                                                        color: Colors.black, // Black shadow on the bottom-right
                                                        blurRadius: 1.5,
                                                        
                                                      ),
                                                      Shadow(
                                                        offset: Offset(-1, 1),
                                                        color: Colors.black, // Black shadow on the bottom-left
                                                        blurRadius: 1.5,
                                                      ),
                                                    ]
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  carDetails["Model"].toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: ScreenWidth * 0.045),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(9.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Year: ",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenWidth * 0.035, color: Colors.white,
                                                    shadows: [
                                                      Shadow(
                                                        offset: Offset(-1, -1),
                                                        color: Colors.black, // Black shadow on the top-left
                                                        blurRadius: 1.5,
                                                      ),
                                                      Shadow(
                                                        offset: Offset(1, -1),
                                                        color: Colors.black, // Black shadow on the top-right
                                                        blurRadius: 1.5,
                                                      ),
                                                      Shadow(
                                                        offset: Offset(1, 1),
                                                        color: Colors.black, // Black shadow on the bottom-right
                                                        blurRadius: 1.5,
                                                        
                                                      ),
                                                      Shadow(
                                                        offset: Offset(-1, 1),
                                                        color: Colors.black, // Black shadow on the bottom-left
                                                        blurRadius: 1.5,
                                                      ),
                                                    ]
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  carDetails["Year"].toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: ScreenWidth * 0.045),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(9.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Color: ",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenWidth * 0.035, color: Colors.white,
                                                    shadows: [
                                                      Shadow(
                                                        offset: Offset(-1, -1),
                                                        color: Colors.black, // Black shadow on the top-left
                                                        blurRadius: 1.5,
                                                      ),
                                                      Shadow(
                                                        offset: Offset(1, -1),
                                                        color: Colors.black, // Black shadow on the top-right
                                                        blurRadius: 1.5,
                                                      ),
                                                      Shadow(
                                                        offset: Offset(1, 1),
                                                        color: Colors.black, // Black shadow on the bottom-right
                                                        blurRadius: 1.5,
                                                        
                                                      ),
                                                      Shadow(
                                                        offset: Offset(-1, 1),
                                                        color: Colors.black, // Black shadow on the bottom-left
                                                        blurRadius: 1.5,
                                                      ),
                                                    ]
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  carDetails["Color"].toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: ScreenWidth * 0.045),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(9.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "Plate Number: ",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenWidth * 0.035, color: Colors.white,
                                                    shadows: [
                                                      Shadow(
                                                        offset: Offset(-1, -1),
                                                        color: Colors.black, // Black shadow on the top-left
                                                        blurRadius: 1.5,
                                                      ),
                                                      Shadow(
                                                        offset: Offset(1, -1),
                                                        color: Colors.black, // Black shadow on the top-right
                                                        blurRadius: 1.5,
                                                      ),
                                                      Shadow(
                                                        offset: Offset(1, 1),
                                                        color: Colors.black, // Black shadow on the bottom-right
                                                        blurRadius: 1.5,
                                                        
                                                      ),
                                                      Shadow(
                                                        offset: Offset(-1, 1),
                                                        color: Colors.black, // Black shadow on the bottom-left
                                                        blurRadius: 1.5,
                                                      ),
                                                    ]
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  carDetails["PlateNumber"].toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: ScreenWidth * 0.045),
                                                ),
                                                Spacer(),
                                                
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(width: ScreenWidth*0.15,),
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 6.0),
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color.fromARGB(255, 249, 208, 87),
                                                    foregroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15),
                                                      side :BorderSide(
                                                      color: Colors.black,
                                                      width: 1,
                                                    )
                                                    )
                                                    
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(context, 
                                                    MaterialPageRoute(builder: (context) => PastAccidents(plateNumber: carDetails['PlateNumber'],)),
                                                    );
                                                  },
                                                  child: Text(
                                                    "View history",
                                                    //style: TextStyle(color: Colors.black),
                                                  ),
                                                ),
                                              )
                                            ),
                                            SizedBox(width: ScreenWidth*0.05,),
                                            IconButton(
                                              onPressed: (){
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context){
                                                    return AlertDialog(
                                                      title: Text('Delete Car'),
                                                      content: Text('Are you sure you want to Delete Car ${index+1}?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text('Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            // Proceed with sign out
                                                            try {
                                                              _deleteCar(car["ChassisNumber"]);
                                                              Navigator.of(context).pop();
                                                            } catch (e) {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(content: Text('Failed to Delete the car, please try again')),
                                                              );
                                                              print('Error Deleting the car: ${e.toString()}');
                                                              Navigator.of(context).pop(); 
                                                            }
                                                          },
                                                          child: Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                );
                                                
                                                },
                                                 icon: Icon(Icons.delete))
                                        ]),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                ),
        ],
      )
    );
  }
}
