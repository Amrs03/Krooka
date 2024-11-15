import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'globalVariables.dart';

class PastAccidents extends StatefulWidget {
  final String plateNumber;
  const PastAccidents({
    super.key,
    required this.plateNumber,
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
  List <Accident> accidents = [];
   bool isLoading = true;  // For managing loading state
  String? errorMessage;   // For managing error state

  void _getCarDetails() async {
    final car = await supabase.from("Car").select().eq("PlateNumber", widget.plateNumber).single();
    setState(() {
      carManufacturer = car["Manufacturer"];
      carModel = car['Model'];
      carYear = car['Year'];
      carColor = car['Color'];
    });
  }

  void _getAccidents () async {
    try {
      List<Map<String, dynamic>> result = await supabase.from('Been In').select('AccidentID, Status').eq('PlateNumber', widget.plateNumber);
      for (int i = 0; i < result.length; i++) {
        Accident acc = new Accident();
        acc.AccidentID = result[i]['AccidentID'];
        acc.Status = result[i]['Status'];
        Map AccInfo = await getAccidentInfo(result[i]['AccidentID']);
        acc.Longitude = AccInfo['longitude'];
        acc.Latitude = AccInfo['latitude'];

        acc.Date_Time = AccInfo['Date_Time']; 
        List<Placemark> placemarks = await placemarkFromCoordinates(acc.Latitude, acc.Longitude);
        Placemark place = placemarks[0];
        acc.Location = "${place.subLocality} - ${place.thoroughfare}";

        accidents.add(acc);   
      }
      accidents = accidents.reversed.toList();
      setState(() {
        isLoading = false;
      });
    }
    catch(e) {
      print ('Error getting the accidents : $e');
      isLoading = false;
    }
  }

  Future<Map> getAccidentInfo (int ID) async {
    Map<String, dynamic> result = await supabase.from('Accident').select('latitude, longitude, Date_Time').eq('AccidentID', ID).single();
    return result;
  }
  String getTime(BuildContext context, int index){
    String result;
    List time = DateTime.parse(accidents[index].Date_Time).toString().split('.').first.split(' ').last.split(':');
    result = "${time[0]}:${time[1]}"; 
    return result;
  }

  @override
    void initState() {
    _getCarDetails();
    _getAccidents();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.sizeOf(context).width;
    final ScreenHeight = MediaQuery.sizeOf(context).height;
    
    return Scaffold(
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        color: Colors.black.withOpacity(0.2),
        spreadRadius: 2,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Padding(
    padding: const EdgeInsets.only(top: 25.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: ScreenWidth * 0.11,
            backgroundColor: Color(0xFFF5F5FA),
            child: Icon(
              Icons.car_crash_outlined,
              size: ScreenWidth * 0.2,
              color: Color(0xFF0A061F),
            ),
          ),
        ),
        Container(
          width: ScreenWidth * 0.66,
          height: ScreenHeight * 0.15,
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
          decoration: BoxDecoration(
            color: Color(0xFF0A061F),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        " $carManufacturer $carModel",
                        style: TextStyle(
                          fontSize: ScreenWidth * 0.033,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis, // Add ellipsis if text is too long
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.directions_car_outlined ,color: Colors.white,),
                        SizedBox(width: ScreenWidth*0.02,),
                        Text(
                          "${widget.plateNumber}",
                          style: TextStyle(
                            fontSize: ScreenWidth * 0.03,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    
                  ],
                ),
              ),
              SizedBox(height: ScreenHeight*0.02,),
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_month, color: Colors.white, size: ScreenWidth*0.06,),
                        SizedBox(width: ScreenWidth * 0.03),
                        Text(
                          "$carYear",
                          style: TextStyle(
                            fontSize: ScreenWidth * 0.03,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.color_lens_outlined, color: Colors.white),
                        SizedBox(width: ScreenWidth * 0.03),
                        Text(
                          "$carColor",
                          style: TextStyle(
                            fontSize: ScreenWidth * 0.03,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
      ],
    ),
  ),
),
        Container(
          margin: EdgeInsets.only(left: 20, top: 10, bottom: 5),
          child: Text(
            "Accidents (${accidents.length})",
            style: TextStyle(
                fontSize: ScreenWidth * 0.05, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: accidents.length,
                  itemBuilder: (context, index) {
                    return  Container(
                      height: ScreenHeight * 0.2,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // Slightly transparent shadow
                            spreadRadius: 1,                      // Spread radius
                            blurRadius: 10,                       // Smoothens the edges of the shadow
                            offset: Offset(0, 5),                 // Horizontal and vertical shadow offset
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${accidents.length - index}",
                              style: TextStyle(
                                fontSize: ScreenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A061F),
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: ScreenHeight*0.02,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0 , vertical: 2),
                              child: Column(
                                children: [
                                  Row(
                                    
                                    children: [
                                      Icon(Icons.room),
                                      SizedBox(width: ScreenWidth*0.03,),
                                      Flexible(
                                        child: Text(
                                          "${accidents[index].Location}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: ScreenWidth * 0.033,
                                            color: Color(0xFF0A061F),
                                          ),
                                         overflow: TextOverflow.ellipsis, 
                                         maxLines: 1,// Add ellipsis for overflow
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: ScreenHeight * 0.02),
                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_month, color: Color(0xFF0A061F)),
                                          SizedBox(width: ScreenWidth * 0.03),
                                          Text(
                                            "${DateTime.parse(accidents[index].Date_Time).toString().split('.').first.split(' ').first}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0A061F),
                                              fontSize: ScreenWidth * 0.033,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          Icon(Icons.access_time, color: Color(0xFF0A061F)),
                                          SizedBox(width: ScreenWidth * 0.03),
                                          Text(
                                            "${getTime(context, index)}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0A061F),
                                              fontSize: ScreenWidth * 0.033,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer()
                                    ],
                                  ),
                                  SizedBox(height: ScreenHeight * 0.02),
                                ],
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  );
  }
}