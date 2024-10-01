import 'dart:async';
import 'package:flutter/material.dart';
import 'detailedReport2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class detailedReport extends StatefulWidget {
  @override
  _detailedReportState createState() => _detailedReportState();
}

class _detailedReportState extends State<detailedReport> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng _currentPosition = LatLng(31.955162860469148, 35.91534546775252); // Default to San Francisco
  TextEditingController _locationController = TextEditingController();
  String _currentAddress = "Searching address...";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }
  Future<void> _getCurrentLocation() async {
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
      Position position = await Geolocator.getCurrentPosition();
      setState (()  
        {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _goToCurrentPosition();
          _getAddressFromLatLng(_currentPosition);
        }
      );
    }
    catch(e) {
      print('Can\'t get the current location : $e');
      Navigator.pop(context);
    }
  }

   Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark address = placemarks[0];
        String addressStr = "${address.street}, ${address.country}";
        setState(() {
          _currentAddress = addressStr;
        });
      }
    } catch (e) {
      print("Error getting address: $e");
      setState(() {
        _currentAddress = "Address not found";
      });
    }
  }

  Future<void> _goToCurrentPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: _currentPosition,
        zoom: 14.0,
      ),
    ));
  }
  Future<void> _searchLocation(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        final target = LatLng(locations.first.latitude, locations.first.longitude);
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLng(target));
        setState(() {
          _currentPosition = target;
          _getAddressFromLatLng(_currentPosition);
        });
      }
    } catch (e) {
      print('$location is not found : $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Maps Location Search"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 12,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMove: (Position) {
              setState(() {
                _currentPosition = Position.target;
              });
              _getAddressFromLatLng(_currentPosition);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            top: 20,
            left: 15,
            right: 15,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: 'Enter location',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      if (_locationController.text.isNotEmpty) {
                        _searchLocation(_locationController.text);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          Center(
            child: Icon(
              Icons.location_on,
              size: 40.0,
              color: Colors.red,
            ),
          ),
          Positioned(
            bottom: 50,
            left: 15,
            right: 15,
            child: Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.white,
              child: Text(
                _currentAddress,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getCurrentLocation();
        },
        child: Icon(Icons.my_location),
      ),
    );
  }
}
