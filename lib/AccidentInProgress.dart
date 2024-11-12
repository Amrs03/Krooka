// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InProgress extends StatefulWidget {
  final Map<String, dynamic> data;

  const InProgress({required this.data});

  @override
  State<InProgress> createState() => _InProgressState();
}

class _InProgressState extends State<InProgress> {
  final SupabaseClient supabase = Supabase.instance.client;
  late LatLng accidentLocation;
  late LatLng officerLocation;
  Completer<GoogleMapController> _controller = Completer();
  Marker? _officerMarker;
  Marker? _accidentMarker;
  late Future<void> _accLocFuture;
  Map<PolylineId, Polyline> polylines = {};
  late dynamic estimatedTime;
  late String officerName;

  Future<void> setAccLoc () async {
    try{
      dynamic accInfo = await supabase.from('Accident').select('latitude, longitude, OfficerID').eq('AccidentID', widget.data['ID']).single();
      dynamic offInfo = await supabase.from('Officer').select('Name ,currentLat, currentLong').eq('OfficerID', accInfo['OfficerID']).single();
      officerName = offInfo['Name'];
      officerLocation = LatLng(double.parse(offInfo['currentLat'].toString()), double.parse(offInfo['currentLong'].toString()));
      accidentLocation = LatLng(double.parse(accInfo['latitude'].toString()), double.parse(accInfo['longitude'].toString()));
      _officerMarker = Marker(
        markerId: MarkerId('officerMarker'),
        position: officerLocation,
      );
      _accidentMarker = Marker(
        markerId: MarkerId('accidentMarker'),
        position: accidentLocation
      );
      dynamic coordiantes = await getPolylinePoints();
      generatePolylineFromPoints(coordiantes);
      dynamic estTime = await _getEstimatedTime(officerLocation.latitude, officerLocation.longitude, accidentLocation.latitude, accidentLocation.longitude);
      estimatedTime = estTime['duration_in_traffic'];
      _subscribleToLocationChange(accInfo['OfficerID']);
    }
    catch(e) {
      print ('Error getting the officer/accident location : $e');
    }
  }

  void _subscribleToLocationChange (dynamic ID) {
    supabase.channel('Officer').onPostgresChanges(
      event: PostgresChangeEvent.all, 
      schema: 'public',
      table: 'Officer',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq, 
        column: 'OfficerID', 
        value: ID
      ),
      callback: (payload){
        _updateOfficerLocation(payload.newRecord['currentLat'], payload.newRecord['currentLong']);
      }
    ).subscribe();
  }

  Future<void> _updateOfficerLocation(double newLat, double newLong) async {
    final GoogleMapController controller = await _controller.future;
    officerLocation = LatLng(newLat, newLong);
    dynamic coordiantes = await getPolylinePoints();
    generatePolylineFromPoints(coordiantes);
    dynamic estTime = await _getEstimatedTime(officerLocation.latitude, officerLocation.longitude, accidentLocation.latitude, accidentLocation.longitude);
    estimatedTime = estTime['duration_in_traffic'];
    setState(() {
      _officerMarker = Marker(
        markerId: MarkerId('officerMarker'),
        position: officerLocation,
      );
      controller.animateCamera(
        CameraUpdate.newLatLng(officerLocation)
      );
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: dotenv.env['API_KEY'],
      request: PolylineRequest(
        origin: PointLatLng(officerLocation.latitude, officerLocation.longitude), 
        destination: PointLatLng(accidentLocation.latitude, accidentLocation.longitude), 
        mode: TravelMode.driving
      )
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point){
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    else {
      print (result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolylineFromPoints (List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(polylineId: id, color:Colors.black, points: polylineCoordinates, width: 4);
    setState(() {
      polylines[id] = polyline;
    });
  }

  Future<Map<String, String>> _getEstimatedTime(double officerLat, double officerLng, double accidentLat, double accidentLng) async {
    final String apiKey = '${dotenv.env['API_KEY']}';
    final String url =
      'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$officerLat,$officerLng&destinations=$accidentLat,$accidentLng&departure_time=now&traffic_model=best_guess&key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['rows'].isNotEmpty && data['rows'][0]['elements'].isNotEmpty) {
          String durationInTraffic = data['rows'][0]['elements'][0]['duration_in_traffic']['text'] ?? 'Unavailable';
          return {
            'duration_in_traffic': durationInTraffic, // Add duration in traffic to the return map
          };
        } 
        else {
          return {'duration_in_traffic': 'No data'};
        }
      } 
      else {
        print('Failed to fetch distance and time data. Status code: ${response.statusCode}');
        return {'duration_in_traffic': 'Error'};
      }
    } 
    catch (e) {
      print('Error: $e');
      return {'distance': 'Error', 'duration': 'Error', 'duration_in_traffic': 'Error'};
    }
  }

  @override
  void initState() {
    super.initState();
    _accLocFuture = setAccLoc();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.sizeOf(context).width;
    final ScreenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: FutureBuilder(
        future: _accLocFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done){
            return Stack(
              children:[ 
                GoogleMap(
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: officerLocation,
                    zoom: 16
                  ),
                  markers: {
                    _officerMarker!,
                    _accidentMarker!
                  },
                  polylines: Set<Polyline>.of(polylines.values),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                   height: ScreenHeight * 0.2,
                   width: ScreenWidth*1,
                   padding: EdgeInsets.only(top: 10 , bottom: 2),
                  //  margin: EdgeInsets.only(right: ScreenWidth*0.01,left: ScreenWidth*0.01),
                   decoration: BoxDecoration(
                     color: Color(0xFF0A061F),
                     borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(30)),
                   ),
                    child: Column(
                      children: [
                        Container(
                          height: ScreenHeight *0.065,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[200]
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person),
                                SizedBox(width:3),
                                Text(officerName),
                              ],
                            )
                          ),
                         ),
                         Container(
                          height: ScreenHeight *0.065,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[200]
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.timelapse),
                                SizedBox(width: 5,),
                                Text("Est Time : $estimatedTime")
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),      
    );    
  }   
}   