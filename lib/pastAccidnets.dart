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
              children: [
                Icon(Icons.directions_car , size: ScreenWidth*0.2,),
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
                        child: Text("Plate-Number :  ${widget.plateNumber}" ,style: TextStyle(fontSize: ScreenWidth*0.035),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30, top: 6),
            child: Text("Accidents (${accidents.length})", style: TextStyle(fontSize: ScreenWidth*0.05 , fontWeight: FontWeight.bold),),
          ),
          isLoading ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator(),),
          ) :
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: accidents.length,
            itemBuilder: (context, index) {
              
              return Container(
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
                        child: Text("Accident ${accidents.length -(index)}", style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0, top:4.0),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month),
                            Text(" ${DateTime.parse(accidents[index].Date_Time).toString().split('.').first.split(' ').first}" , style: TextStyle(fontSize: ScreenWidth*0.03),),
                            Spacer(),
                            Icon(Icons.access_time),
                            Text(" ${getTime(context, index)}" , style: TextStyle(fontSize: ScreenWidth*0.03),),
                            Spacer()
                          ],
                        ),
                      ),
                      
                       Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
        
                        child: Row(
                          children: [
                            Icon(Icons.room),
                            Text(" ${accidents[index].Location}",style: TextStyle(fontSize: ScreenWidth*0.03),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0,),
                        child: Row(
                          children: [
                            Icon(Icons.pending_outlined),
                            Text(" ${accidents[index].Status}",style: TextStyle(fontSize: ScreenWidth*0.03,),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          )
        ],
      ),
    );
  }
}