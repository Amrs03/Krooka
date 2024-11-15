import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PhotoDialog extends StatelessWidget {
  final Uint8List photoBytes;

  const PhotoDialog({required this.photoBytes});

  @override
  Widget build(BuildContext context) {
    final ScreenHeight = MediaQuery.sizeOf(context).height;
    final ScreenWidth = MediaQuery.sizeOf(context).width;
    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.8),
      insetPadding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: ScreenHeight*0.6,
            maxWidth: ScreenWidth*0.9
          ),
          child: Image.memory(
            photoBytes,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class acceptAccident extends StatefulWidget {
  final Map<String, dynamic> data;

  const acceptAccident({required this.data});

  @override
  State<acceptAccident> createState() => _acceptAccidentState();
}

class _acceptAccidentState extends State<acceptAccident> {
  List<Uint8List> imageBytes = [];
  final SupabaseClient supabase = Supabase.instance.client; 
  bool done = false;
  List<String> _plates =[];
  Map<String,dynamic> applicantInfo = {};
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _locationPermission();
    getPhotos(widget.data['ID']);
    getApplicantInfo(widget.data['ID']);
    startTimer();
  }

  Future<void> _locationPermission() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Please enable the location on your phone');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Please allow the app to use the location of your device');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Please allow the app to use the location of your device, by changing the permission rules in the settings -> apps');
      }
    }
    catch(e) {
      print('Can\'t get the current location : $e');
      Navigator.pop(context);
    }
  }

  void startTimer () async {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      await _saveCurrentLocation();
    });
  }

  Future<void> _saveCurrentLocation() async {
    try {
      print ('Updating the location ...');
      Position position = await Geolocator.getCurrentPosition();
      await supabase
        .from('Officer')
        .update({'currentLat': position.latitude, 'currentLong' : position.longitude})
        .eq('OfficerID', widget.data['officerID']);
      print ('Location has been updated \n :)');
    }
    catch(e) {
      print('Can\'t get the current location : $e');
      Navigator.pop(context);
    }
  }

  Future<void> getPhotos (int accidentID) async {
    try {
      if (imageBytes.isNotEmpty){
        return;
      }
      dynamic result = await supabase.from('Accident_Photos').select('filePath').eq('accidentId', accidentID);
      for (int i =0; i < result.length; i++){
        final response = await http.get(Uri.parse(result[i]['filePath']));
        if (response.statusCode == 200){
          imageBytes.add(response.bodyBytes);
        }
        else {
          throw Exception('http request failed :(');
        }
      }
      setState(() {done = true;});
    }
    catch(e) {
      print ('Error retrieving photos : $e');
    }
  }

  Future<void> OpenGoogleMaps (double lat, double long) async {
    try {
      final googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$long');
      if (await canLaunchUrl(googleMapsUrl)){
        await launchUrl(googleMapsUrl);
      }
      else {
        throw new Exception('Can\'t open Google Maps');
      }
    }
    catch(e) {
      print ('Cant open google maps : $e');
    }
  }

  Future<void> getPlates (int accidentID) async{
    try{
       if (_plates.isNotEmpty) {
        return;
      }
      dynamic plates =[];
      plates = await supabase.from("Been In").select("PlateNumber").eq('AccidentID', accidentID);
      plates.forEach((plate) {
        _plates.add(plate['PlateNumber']);
      });
    }
    catch(e){
      print("error: ${e.toString()}");
    }
  }

  Future<void> getApplicantInfo(int accidentId) async{
    try{
      dynamic ApplicantId;
      ApplicantId = await supabase.from('Accident').select('applicantID').eq('AccidentID', accidentId).single();
      print(ApplicantId);
      dynamic result;
      result= await supabase.from("User").select('FirstName, LastName, PhoneNum').eq("IdNumber", ApplicantId['applicantID']).single();
      print(result['FirstName']);
      applicantInfo['FirstName'] = result['FirstName'];
      applicantInfo['LastName'] = result['LastName'];
      applicantInfo['PhoneNum'] = result['PhoneNum'];
      setState(() {});
    }
    catch(e){
      print("Error : ${e.toString()}");
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async{
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber
      );
     if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    throw 'Could not launch $launchUri';
  }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when disposing the widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.sizeOf(context).width;
    final ScreenHeight = MediaQuery.sizeOf(context).height;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(0xFFF5F5FA),
        body: Column(
          children: [
            SizedBox(height: ScreenHeight*0.05),
            GestureDetector(
              onTap: (){
                OpenGoogleMaps(widget.data['lat'], widget.data['long']);
              },
              child: Container(
                width: ScreenWidth*0.8,
                height: ScreenHeight *0.075,
                decoration: BoxDecoration(
                  
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xFF7DA0CA)
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Text("Go to location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22 ,color: Colors.white)),
                      SizedBox(width: 10),
      
                     Icon(Icons.room_outlined, size: 28 , color: Colors.white,),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              //height: ScreenHeight * 0.3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenWidth*0.05),
                child: GridView.builder(
                  
                  shrinkWrap: true, // Allows the GridView to size itself based on its content
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10
                  ),
                  itemCount: widget.data['NumOfPhotos'],
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap:() {
                        if (done){
                          showDialog(
                            context: context, 
                            builder:(context) => PhotoDialog(photoBytes:  imageBytes[index])
                          );
                        }
                      },
                      child: done ? ClipRRect(
                        borderRadius: BorderRadius.circular(15), // Adjust the radius for the circular effect
                        child: Image.memory(imageBytes[index], fit: BoxFit.cover)): Center(child: CircularProgressIndicator())
                    );
                  }
                ),
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: FutureBuilder(
                future: Future.wait([
                  getPlates(widget.data['ID']),
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                  } else if (snapshot.hasError) {
                    return Container(
                      width: ScreenWidth * 0.8,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text("Error: ${snapshot.error}"),
                      ),
                    );
                  } else {
                    // Assuming _images and _plateNumbers are defined and populated in getPhotos and getPlates
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: ScreenWidth * 0.1),
                      child: Column(
                        children:[
                          Expanded(
                            child: ListView.builder(
                              itemCount: _plates.length, // Assuming _plateNumbers is defined
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.symmetric(horizontal: 5 , vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 1 ,color: Colors.black)
                                  ),
                                  child: Text(
                                    _plates[index],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          // Display Photos
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              width: ScreenWidth*1,
              height: ScreenHeight*0.3,
              padding: EdgeInsets.only(top: 10 , bottom: 2),
              margin: EdgeInsets.only(right: ScreenWidth*0.003,left: ScreenWidth*0.003 ,top: 2),
              decoration: BoxDecoration(
                color: Color(0xFF0A061F),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                
              ),
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          height: ScreenHeight *0.065,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                          decoration: BoxDecoration(
                          
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xFF0A061F),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.8), // White shadow with opacity
                                spreadRadius: 1, // How much the shadow spreads out
                                blurRadius: 2, // Softness of the shadow
                                offset: Offset(1, 4), // Horizontal and vertical position of the shadow
                              ),
                            ],
                          ),
                          
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_outline_outlined, color: Colors.white,),
                                SizedBox(width:3),
                                Text("${applicantInfo['FirstName']} ${applicantInfo['LastName']}",style: TextStyle(color: Colors.white,fontSize: ScreenWidth*0.035) ,),
                              ],
                            )
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _makePhoneCall(applicantInfo['PhoneNum']);
                            print("test");
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            height: ScreenHeight *0.065,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                            decoration: BoxDecoration(
                              
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xFF0A061F),
                              boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.8), // White shadow with opacity
                                spreadRadius: 1, // How much the shadow spreads out
                                blurRadius: 2, // Softness of the shadow
                                offset: Offset(1, 4), // Horizontal and vertical position of the shadow
                              ),
                            ],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.phone , color: Colors.white,),
                                  SizedBox(width: 5,),
                                  Text("${applicantInfo['PhoneNum']}",style: TextStyle(color: Colors.white,fontSize: ScreenWidth*0.035) )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: ScreenHeight*0.02,),
                    GestureDetector(
                      onTap: (){
                        // OpenGoogleMaps(widget.data['lat'], widget.data['long']);
                         
                      },
                      child: Container(
                        width: ScreenWidth*0.9,
                        height: ScreenHeight *0.07,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            await supabase.from('Accident').update({'Status' : 'complete'}).eq('AccidentID', widget.data['ID']);
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Text("Finished", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                          ),
                        ),
                      ),
                    ),
                  ],
                 ),
               ),
             ),
          ],
        ),
      ),
    );
  }
}