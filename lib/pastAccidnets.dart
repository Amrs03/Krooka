import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PastAccidents extends StatefulWidget {
  final int chassisNumber;
  const PastAccidents({
    super.key,
    required this.chassisNumber,
    });
  

  @override
  State<PastAccidents> createState() => _PastAccidentsState();
}

class _PastAccidentsState extends State<PastAccidents> {

  final supabase = Supabase.instance.client;
  var carManufacturer;
  var carModel;
  var carYear;
  var carColor;
  var carPlateNumber;
  void _getCarDetails(int chassisNumber) async {
  final car = await supabase.from("Car").select().eq("ChassisNumber", chassisNumber).single();
  print("Car selected");
  setState(() {
    carManufacturer = car["Manufacturer"];
    carModel = car['Model'];
    carYear = car['Year'];
    carColor = car['Color'];
    carPlateNumber = car["PlateNumber"];
  });
  
  

  }

  @override
    void initState(){
    super.initState();
    _getCarDetails(widget.chassisNumber);
  }
  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.sizeOf(context).width;
    final ScreenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Car History"),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            height: ScreenHeight*0.2,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children:
                      [
                      Icon(Icons.car_crash , size: ScreenWidth*0.2,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text("Car : $carManufacturer $carModel " , style: TextStyle(fontSize: ScreenWidth*0.035),),
                            ),
                            
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text("Year : $carYear" ,style: TextStyle(fontSize: ScreenWidth*0.035),),
                                ),
                                SizedBox(width: ScreenWidth*0.1,),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text("Color : $carColor" ,style: TextStyle(fontSize: ScreenWidth*0.035),),
                                ),
                              ],
                            ),
                            Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text("Plate-Number :  $carPlateNumber" ,style: TextStyle(fontSize: ScreenWidth*0.035),),
                                ),
                          ],
                        ),
                      ),
                
              
                      ],
                    ),
          ),
            Container(
            margin: EdgeInsets.only(left: 30, top: 6),
            child: Text("Accidents ", style: TextStyle(fontSize: ScreenWidth*0.05 , fontWeight: FontWeight.bold),),
          ),
          Container(
            height: ScreenHeight*0.2,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey , width: 2)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text("Accident 1", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0, top:4.0),
                    child: Text("Date & Time : " , style: TextStyle(fontSize: ScreenWidth*0.03),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text("Location : ",style: TextStyle(fontSize: ScreenWidth*0.03),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text("Status : ",style: TextStyle(fontSize: ScreenWidth*0.03),),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}