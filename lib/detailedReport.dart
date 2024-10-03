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
        print ('address : $address');
        String addressStr;
        if (address.thoroughfare == ""){
          addressStr = "N/A, ${address.subLocality}";
        }
        else { 
          addressStr = "${address.thoroughfare}, ${address.subLocality}";
        }
        print (addressStr);
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
        zoom: 16.0,
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
                _locationController.clear();
              });
            },
            onCameraIdle: () {
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: _currentAddress,
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 12),
                      onTap: () {
                        setState(() {
                          _currentAddress = "";
                        });
                      },
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
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Icon(
                Icons.location_on,
                size: 20.0,
                color: Colors.red,
              ),
            ),
          ),
          Positioned(
            bottom:10,
            left: MediaQuery.of(context).size.width * 0.35,
            right: MediaQuery.of(context).size.width * 0.35,
            child: GestureDetector(
              onTap: () {
                print("Address :${_currentAddress.toString()}");
                Navigator.pushNamed(context, '/DR2', arguments: <String, dynamic>{
                  'lat' : _currentPosition.latitude,
                  'long' : _currentPosition.longitude
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width:MediaQuery.sizeOf(context).width *0.2,
                  height: MediaQuery.sizeOf(context).height *0.1,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Center(child: Text("Confirm",style: TextStyle(fontWeight: FontWeight.bold))),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 25),
        child: FloatingActionButton(
          onPressed: () {
            _getCurrentLocation();
          },
          child: Icon(Icons.my_location),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartDocked,
    );
  }
}
