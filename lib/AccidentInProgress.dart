import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class InProgress extends StatefulWidget {
  final Map<String, dynamic> data;

  const InProgress({required this.data});

  @override
  State<InProgress> createState() => _InProgressState();
}

class _InProgressState extends State<InProgress> {
  final SupabaseClient supabase = Supabase.instance.client;
  LatLng? accidentLocation;
  LatLng? officerLocation;
  Completer<GoogleMapController> _controller = Completer();

  void setAccLoc () async {
    accidentLocation = LatLng(widget.data['Lat'], widget.data['Long']);
    dynamic result = await supabase.from('Accident').select('OfficerID').eq('AccidentID', widget.data['ID']).single();
    dynamic location = await supabase.from('Officer').select('currentLat, currentLong').eq('OfficerID', result['OfficerID']).single();
    officerLocation = LatLng(location['currentLat'], location['currentLong']);
    setState(() {});
  }

  void _subscribleToLocationChange () {
    print ('Test');
    supabase.channel('Officer').onPostgresChanges(
      event: PostgresChangeEvent.all, 
      schema: 'public',
      table: 'Officer',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq, 
        column: 'OfficerID', 
        value: '9876543210'
      ),
      callback: (payload){
        print ('entered : ${payload.newRecord}');
        officerLocation = LatLng(payload.newRecord['currentLat'], payload.newRecord['currentLong']);
        _goToOfficerPosition();
      }
    ).subscribe();
  }

  Future<void> _goToOfficerPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: officerLocation!,
        zoom: 16.0,
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    setAccLoc();
    _subscribleToLocationChange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            initialCameraPosition: CameraPosition(
              target: officerLocation!,
              zoom: 16
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Icon(
                Icons.location_on,
                size: 20.0,
                color: Colors.red,
              ),
            ),
          ),
        ]
      ),  
    );
  }
}