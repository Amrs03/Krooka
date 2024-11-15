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
            height: ScreenHeight * 0.22,
            decoration: BoxDecoration(
              color: Color(0xFFF5F5FA),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25), 
                bottomRight: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                  spreadRadius: 2,                      // Spread radius
                  blurRadius: 8,                        // Blur radius
                  offset: Offset(0, 4),                 // Horizontal & Vertical offset (0 for x, positive for downward y)
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Row(
                crossAxisAlignment:CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                   Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF0A061F) , width: 6),
                    ),
                    child: CircleAvatar(
                      radius: ScreenWidth *0.11,
                      backgroundColor: Colors.white,
                      child:Icon(Icons.person_2 , size: ScreenWidth*0.2,color: Color(0xFF0A061F),)
                    ),
                    ),
              
              Container(
              width: ScreenWidth *0.66,
              height: ScreenHeight*0.15,
              padding: EdgeInsets.symmetric(vertical: 4 , horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFF0A061F),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0,),
                        child: Row(
                          children: [
                            Icon(Icons.person_2_outlined ,  color: Colors.white),
                            SizedBox(width:ScreenWidth*0.03),
                            Text(" $FirstName $LastName" , style: TextStyle(fontSize: ScreenWidth*0.03 ,fontWeight: FontWeight.bold, color: Colors.white),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Row(
                          children: [
                            Icon(Icons.cake_outlined ,  color: Colors.white),
                            SizedBox(width:ScreenWidth*0.03),
                            Text(" $DoB",style: TextStyle(fontSize: ScreenWidth*0.03 ,fontWeight: FontWeight.bold , color: Colors.white),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Row(
                          children: [
                            Icon(Icons.phone_outlined ,color: Colors.white,),
                            SizedBox(width:ScreenWidth*0.03),
                            Text(" $PhoneNumber" ,style: TextStyle(fontSize: ScreenWidth*0.03 , fontWeight: FontWeight.bold, color: Colors.white),),
                          ],
                        ),
                      ),
                     
                    ],
                  ),
                  
                ],
              ),
              
                          ),
                ],
              ),
            ),
          )
          ,
           
       
          
          Container(
            margin: EdgeInsets.only(left: 30, top: 20),
            child: Text("My Vehicles ", style: TextStyle(fontSize: ScreenWidth*0.05 , fontWeight: FontWeight.bold, color: Color(0xFF0A061F)),),
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
                          itemBuilder: (context, index) {
                            if (index == cars.length) {
                              return Container(
                                height: ScreenHeight*0.23,
                                width: ScreenWidth * 0.8,
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  borderRadius: BorderRadius.circular(15),
                                  
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Add a Car",
                                        style: TextStyle(fontSize: 20, color: Colors.grey[500]),
                                      ),
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
                                            size: 40,
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
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      width: ScreenWidth * 0.9,
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: Color(0xFF0A061F), width: 2 ),
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
                                          Row(
                                            children: [
                                              Text(
                                                "${index + 1}",
                                                style: TextStyle(fontSize: ScreenWidth * 0.04, fontWeight: FontWeight.bold ,),
                                                textAlign: TextAlign.left,
                                              ),
                                              Spacer(),
                                              Center(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${carDetails["Manufacturer"].toString()} ${carDetails["Model"].toString()}",
                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenWidth * 0.045 , color: Color(0xFF0A061F)),
                                                    ),
                                                  
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Text(" ")
                                            ],
                                          ),
                                          
                                                
                                               
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              
                                              Text(
                                                carDetails["Year"].toString(),
                                                style: TextStyle( color: Color(0xFF0A061F), fontSize: ScreenWidth * 0.04),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: ScreenHeight*0.01,),
                                          Divider(
                                            color:  Color(0xFF0A061F), 
                                            thickness: 2,   
                                          ),
                                           SizedBox(height: ScreenHeight*0.01,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.color_lens_outlined),
                                                  SizedBox(width: ScreenWidth*0.02,),
                                                  Text(
                                                    carDetails["Color"].toString(),
                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A061F), fontSize: ScreenWidth * 0.037),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.directions_car_outlined),
                                                  SizedBox(width: ScreenWidth*0.02,),
                                                  Text(
                                                    carDetails["PlateNumber"].toString(),
                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A061F), fontSize: ScreenWidth * 0.037),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: ScreenHeight*0.01,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                height: ScreenHeight*0.042,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color(0xFF0A061F),
                                                    foregroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                      side :BorderSide.none
                                                    ),
                                                    
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(context, 
                                                    MaterialPageRoute(builder: (context) => PastAccidents(plateNumber: carDetails['PlateNumber'],)),
                                                    );
                                                  },
                                                  child: Text(
                                                    "View history",
                                                    style: TextStyle(fontSize: ScreenWidth*0.035),
                                                  ),
                                                ),
                                              ),
                                                IconButton(
                                                  onPressed: (){
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context){
                                                        return AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(25),
                                                            side: BorderSide(
                                                              color: Colors.black,
                                                              width: 2,
                                                            ),
                                                          ),
                                                          title: Text('Delete Car', style: TextStyle(fontWeight: FontWeight.bold),),
                                                          content: Text('Are you sure you want to Delete Car ${index+1}?'),
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
                                                              child: Text('Cancel',style: TextStyle(fontSize: ScreenWidth*0.035),),
                                                            ),
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Color(0xFF0A061F),
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
                                                              child: Text('Delete',style: TextStyle(fontSize: ScreenWidth*0.035),),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                    );
                                                    
                                                    },
                                                    icon: Icon(Icons.delete , size: ScreenWidth*0.075, color: Color(0xFF0A061F),))
                                                  ],
                                                ),
                                          
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
