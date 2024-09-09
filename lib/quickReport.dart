
//this page to be implemented late with back end dev

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SelectLocationPage extends StatefulWidget {
  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  LatLng? _selectedLocation;
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      _mapController.animateCamera(CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude)));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  String _getGoogleMapsLink(LatLng location) {
    return 'https://www.google.com/maps?q=${location.latitude},${location.longitude}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        actions: [
          if (_selectedLocation != null)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                final locationLink = _getGoogleMapsLink(_selectedLocation!);
                // Do something with the location link (e.g., return to previous page)
                Navigator.pop(context, locationLink);
              },
            ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(31.963158, 35.930359), // Default to Amman, Jordan
          zoom: 14,
        ),
        onTap: _onTap,
        markers: _selectedLocation != null
            ? {
          Marker(
            markerId: MarkerId('selected-location'),
            position: _selectedLocation!,
          ),
        }
            : {},
      ),
      floatingActionButton: _selectedLocation != null
          ? FloatingActionButton.extended(
        onPressed: () {
          final locationLink = _getGoogleMapsLink(_selectedLocation!);
          Navigator.pop(context, locationLink); // Return the link
        },
        label: Text('Get Location Link'),
        icon: Icon(Icons.location_on),
      )
          : null,
    );
  }
}
