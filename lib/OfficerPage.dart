// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:krooka/globalVariables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'AcceptAccidentPage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;

import 'signInPage.dart';


class OfficerPage extends StatefulWidget {
  @override
  _OfficerPageState createState() => _OfficerPageState();
}

class _OfficerPageState extends State<OfficerPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> pendingAccidents = [];
  Timer? _timer;
  bool _isLoading =true;
  late Position officerLocation;

  @override
  void initState() {
    super.initState();
    loadAccident();
    _subscribeToAccidentUpdates();
    _startTimer(); // Start the timer to refresh "time ago" every minute
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when disposing the widget
    super.dispose();
  }

  // Start a timer to refresh "time ago" every minute
  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {}); // Rebuild the widget every minute to update time ago
    });
  }

  void loadAccident () async {
    try {
      officerLocation = await _getOfficerLocation();
      dynamic result  = await supabase.from('Accident').select().eq('Status', 'pending');
      for (var accident in result) {
        _handleAccidentUpdates(accident);
      }
      if (result.isEmpty) {
        setState(() {
          _isLoading = false;
        });
      }
    }
    catch(e) {
      print ("Error getting the accident : $e");
    }
  }

  void _subscribeToAccidentUpdates() {
    supabase.channel('Accident').onPostgresChanges(
      event: PostgresChangeEvent.all,                   // I think this must be insert only
      schema: 'public',
      table: 'Accident',
      callback: (payload) {
        _handleAccidentUpdates(payload.newRecord);
      },
    ).subscribe();
  }

   void _handleAccidentUpdates(Map <String,dynamic> accident) async {
    double latitude = accident['latitude']; // Adjust key names as needed
    double longitude = accident['longitude']; // Adjust key names as needed
    // Calculate distance to the accident
    // double distanceInKm = _calculateDistance(
    //   officerLocation.latitude,
    //   officerLocation.longitude,
    //   latitude,
    //   longitude,
    // );
    // Check if the accident is within 20 km
    // if (distanceInKm <= 20 && accident['Status'] != 'in-progress') 
    if ( accident['Status'] == 'pending') {
      // Fetch sublocality for the accident location
      String sublocality = await _getSublocality(latitude, longitude);
      Map<String, String> distanceInfo = await _getDistanceAndTime(latitude, longitude, officerLocation.latitude, officerLocation.longitude);

      // Check if accident is already in the list
      // If it's a new accident, add it to the list with sublocality
      setState(() {
        pendingAccidents.add({
          ...accident,
          'sublocality': sublocality,
          'distance': distanceInfo['distance'],
          'duration': distanceInfo['duration'],
          'duration_in_traffic': distanceInfo['duration_in_traffic'],
        });
      });
    }
    else {
      pendingAccidents.removeWhere((accidentz) => accidentz['AccidentID'] == accident['AccidentID']);
    }
  // After all updates, sort the list by Date_Time to ensure newest accidents are on top
    setState(() {
      pendingAccidents.sort((a, b) {
        DateTime dateA = DateTime.parse(a['Date_Time']);
        DateTime dateB = DateTime.parse(b['Date_Time']);
        return dateB.compareTo(dateA); // Sort newest first
      });
      _isLoading = false;
    });
  }
// Haversine formula to calculate distance between two lat/lng points
double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const int radius = 6371; // Radius of the Earth in kilometers
  double dLat = _degreesToRadians(lat2 - lat1);
  double dLon = _degreesToRadians(lon2 - lon1);

  double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_degreesToRadians(lat1)) * math.cos(_degreesToRadians(lat2)) *
      math.sin(dLon / 2) * math.sin(dLon / 2);
  double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return radius * c; // Distance in kilometers
}

// Convert degrees to radians
double _degreesToRadians(double degrees) {
  return degrees * (math.pi / 180);
}
  String _calculateTimeAgo(String accidentTime) {
    try {
      final DateTime reportedTime = DateTime.parse(accidentTime).subtract(Duration(hours: 3)); // Adjust for GMT-3
      final DateTime currentTime = DateTime.now(); // Use local time
      final Duration difference = currentTime.difference(reportedTime);

      if (difference.inMinutes < 1) {
        return "Just now";
      } else if (difference.inMinutes < 60) {
        return "${difference.inMinutes} minutes ago";
      } else if (difference.inHours < 24) {
        return "${difference.inHours} hours ago";
      } else {
        return "${difference.inDays} days ago";
      }
    } catch (e) {
      print("Error parsing date: $e");
      return "Unknown time"; // Fallback in case of error
    }
  }

 Future<String> _getSublocality(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0]; // Get the first placemark

      // Create a list to store the location details
      List<String> locationDetails = [];  // Corrected to List<String>

      if (placemark.subLocality != null) {
        locationDetails.add(placemark.subLocality!);  // Use ! to assert it's not null
      }
      // Check for each level of detail and add to the list
      if (placemark.thoroughfare != null) {
        locationDetails.add(placemark.thoroughfare!);  // Use ! to assert it's not null
      }
      
      if (placemark.locality != null) {
        locationDetails.add(placemark.locality!);  // Use ! to assert it's not null
      }
      if(locationDetails.isNotEmpty){
        return locationDetails.join("_");
      }
      if (placemark.administrativeArea != null) {
        return placemark.administrativeArea!;
      }

    }
  } catch (e) {
    print("Error getting location: $e");
  }
  return "Unknown location";
}


Future<Position> _getOfficerLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When permission is granted, get the position.
  return await Geolocator.getCurrentPosition();
}

Future<Map<String, String>> _getDistanceAndTime(double officerLat, double officerLng, double accidentLat, double accidentLng) async {
  final String apiKey = '${dotenv.env['API_KEY']}';
  final String url =
      'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$officerLat,$officerLng&destinations=$accidentLat,$accidentLng&departure_time=now&traffic_model=best_guess&key=$apiKey';

      try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('API Response: $data');

      if (data['rows'].isNotEmpty && data['rows'][0]['elements'].isNotEmpty) {
        String distance = data['rows'][0]['elements'][0]['distance']['text'] ?? 'Unavailable';
        String duration = data['rows'][0]['elements'][0]['duration']['text'] ?? 'Unavailable';
        String durationInTraffic = data['rows'][0]['elements'][0]['duration_in_traffic']['text'] ?? 'Unavailable'; // New line to get duration in traffic
        print('API Response: $data');  // Log the entire response
        print("Duration in traffic : $durationInTraffic");

        return {
          'distance': distance,
          'duration': duration,
          'duration_in_traffic': durationInTraffic, // Add duration in traffic to the return map
        };
      } else {
        return {'distance': 'No data', 'duration': 'No data', 'duration_in_traffic': 'No data'};
      }
    } else {
      print('Failed to fetch distance and time data. Status code: ${response.statusCode}');
      return {'distance': 'Error', 'duration': 'Error', 'duration_in_traffic': 'Error'};
    }
  } catch (e) {
    print('Error: $e');
    return {'distance': 'Error', 'duration': 'Error', 'duration_in_traffic': 'Error'};
  }
}

  @override
   Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.sizeOf(context).width;
    final ScreenHeight = MediaQuery.sizeOf(context).height;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: _isLoading // Check if loading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator
            : Column(
              children: [
                Container(
                  height: ScreenHeight * 0.25,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5FA),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Shadow color with opacity
                        spreadRadius: 2,                      // Spread radius
                        blurRadius: 8,                        // Blur radius
                        offset: Offset(0, 4),                 // Horizontal & Vertical offset (0 for x, positive for downward y)
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: (){setState(() {});}, 
                            icon: Icon(Icons.refresh)
                          ),
                          IconButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: BorderSide(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    title: Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold),),
                                    content: Text('Are you sure you want to sign out '),
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
                                        child: Text('Cancel' ,style: TextStyle(fontSize: ScreenWidth*0.035),),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[300],
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
                                          await AuthService().signOut();
                                          await Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (context) => SignInPage()),
                                            (Route<dynamic> route) => false
                                          );
                                        },
                                        child: Text('Sign Out',style: TextStyle(fontSize: ScreenWidth*0.035),),
                                      ),
                                    ],
                                  );
                                },
                              );
                              },
                            icon: Icon(Icons.logout)
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0 , horizontal: 18),
                          child: Text("Pending Accident Requests", style: TextStyle(fontWeight: FontWeight.bold , fontSize: 28),),
                        )
                      ),
                    ]
                  ),
                ),
                SizedBox(height: ScreenHeight*0.03,),
                Expanded(
                  child: ListView.builder(
                      itemCount: pendingAccidents.length,
                      itemBuilder: (context, index) {
                        final accident = pendingAccidents[index];
                        String timeAgo = _calculateTimeAgo(accident['Date_Time']);
                        String location = accident['sublocality'] ?? "Unknown location";
                        
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          elevation: 2,
                          child: IntrinsicHeight(
                            child: Container(
                              width: ScreenWidth*0.7,
                              padding: EdgeInsets.only(left: 15 , right: 15 , top: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12) , bottomLeft:Radius.circular(12) ),
                              ),
                              child:Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:3 , left: 5 , bottom: 6 , right: 5),
                                    child: Row(
                                      children: [
                                        Icon(Icons.room),
                                        SizedBox(width: 10), // Add some spacing between the icon and the text
                                        Expanded(
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: location.split('_').take(1).join(' - '), 
                                                  style: TextStyle(fontWeight: FontWeight.bold , fontSize: ScreenWidth*0.035),
                                                ),
                                                TextSpan(text: '\n'),
                                                TextSpan(
                                                  text: location.split('_').length > 2 ? location.split('_').skip(1).join(' - ') : '',
                                                  style: TextStyle(fontWeight: FontWeight.bold ,fontSize: ScreenWidth*0.035 ,),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          //Text('Injuries: ${accident['Injuries']} | Cars: ${accident['NumberOfCars']}'),
                                         
                                          Padding(
                                            padding: const EdgeInsets.only(top:3 , left: 5 , bottom: 4 , right: 5),
                                            child: Row(
                                              children: [
                                                Icon(Icons.map), //route  //ramp_left
                                                SizedBox(width: 10,),
                                                Text('Distance: ${accident['distance']}', style: TextStyle(fontSize: ScreenWidth*0.035),),
                                              ],
                                            ),
                                          ), // Display distance here
                                          SizedBox(height: ScreenHeight*0.01,),
                                          //Text('Estimated Time: ${accident['duration']}'), // Display estimated time here
                                          Padding(
                                            padding: const EdgeInsets.only(top:3 , left: 5 , bottom: 4 , right: 5),
                                            child: Row(
                                              children: [
                                                Icon(Icons.access_time),
                                                //Icon(Icons.speed), //timer
                                                SizedBox(width: 10,),
                                                Text('ET : ${accident['duration_in_traffic']}', style: TextStyle(fontSize: ScreenWidth*0.035)),
                                              ],
                                            ),
                                          ), // Display estimated time in traffic
                                           Padding(
                                             padding: const EdgeInsets.only(top:8 , left: 5 , bottom: 4 , right: 5),
                                             child: Row(
                                              children: [
                                                SizedBox(width:5),
                                                Text('Reported $timeAgo', style: TextStyle(fontSize: ScreenWidth*0.03),),
                                              ],
                                            ),
                                           ),
                                        ],
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                    onTap: () async {
                                      try {
                                        await supabase
                                          .from('Accident')
                                          .update({'Status': 'in-progress'})
                                          .eq('AccidentID', accident['AccidentID']);
                                        dynamic result = await supabase.from('Officer').select('OfficerID').eq('AuthID', AuthService.authID!).single();
                                        await supabase
                                          .from('Accident')
                                          .update({'OfficerID': result['OfficerID']})
                                          .eq('AccidentID', accident['AccidentID']);
                                        dynamic query = await supabase.from('Accident_Photos').select().eq('accidentId', accident['AccidentID']);
                                        Navigator.pushNamed(context, '/AcceptAccident', arguments: <String, dynamic>{
                                          'ID' : accident['AccidentID'],
                                          'lat' : accident['latitude'],
                                          'long' : accident ['longitude'],
                                          'NumOfPhotos' : query.length,
                                          'officerID' : result['OfficerID']
                                        });
                                      }
                                      catch(e) {
                                        print ('Error accepting the accident : $e');
                                      }
                                    },
                                    child: Container(
                                      width: ScreenWidth*0.17,
                                      height: ScreenHeight*0.1,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 67, 154, 70),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.check , color: Colors.black,size: ScreenWidth*0.1,)),
                                  ),
                                    ],
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ),
              ],
            ),
      ),
    );
  }
}