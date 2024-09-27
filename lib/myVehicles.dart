// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:krooka/globalVariables.dart';
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
    setState(() {
      
    });
    } else {
      print("Car still has other users; it will not be deleted from the Car table.");
    }
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
      appBar: AppBar(
        title: Text("Profile"),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Container(
            height: ScreenHeight*0.2,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(30)
              
            ),
            child: Row(
              children: [
                Icon(Icons.person_2 , size: ScreenWidth*0.32,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text("Name : $FirstName $LastName" , style: TextStyle(fontSize: ScreenWidth*0.03),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text("Date Of Birth : $DoB",style: TextStyle(fontSize: ScreenWidth*0.03),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text("Phone Number : $PhoneNumber" ,style: TextStyle(fontSize: ScreenWidth*0.03),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text("Num. Of Accidents : " ,style: TextStyle(fontSize: ScreenWidth*0.03),),
                    ),
                  ],
                ),
                
              ],
            ),
            
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
                                        color: Colors.grey[400],
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
                                        color: Colors.grey[400],
                                        borderRadius: BorderRadius.circular(25),
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
                                              children: [
                                                Text(
                                                  "Car Manufacturer: ",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenWidth * 0.035),
                                                ),
                                                Text(
                                                  carDetails["Manufacturer"].toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: ScreenWidth * 0.04),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(9.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Car Model: ",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenWidth * 0.035),
                                                ),
                                                Text(
                                                  carDetails["Model"].toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: ScreenWidth * 0.04),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(9.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Year: ",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenWidth * 0.035),
                                                ),
                                                Text(
                                                  carDetails["Year"].toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: ScreenWidth * 0.04),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(9.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Car Color: ",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenWidth * 0.035),
                                                ),
                                                Text(
                                                  carDetails["Color"].toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: ScreenWidth * 0.04),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(9.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Plate Number: ",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenWidth * 0.035),
                                                ),
                                                Text(
                                                  carDetails["PlateNumber"].toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: ScreenWidth * 0.04),
                                                ),
                                                
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
                                                  onPressed: () {
                                                    _deleteCar(car["ChassisNumber"]);
                                                  },
                                                  child: Text(
                                                    "View history",
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                ),
                                              )
                                            ),
                                            SizedBox(width: ScreenWidth*0.05,),
                                            IconButton(onPressed: (){print("item deleted");}, icon: Icon(Icons.delete))
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
