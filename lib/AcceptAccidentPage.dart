import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class acceptAccident extends StatefulWidget {
  const acceptAccident({super.key});

  @override
  State<acceptAccident> createState() => _acceptAccidentState();
}

class _acceptAccidentState extends State<acceptAccident> {
  List<File> _images = [];
  final bucket = Supabase.instance.client.storage.from('accident-images');
  final SupabaseClient supabase = Supabase.instance.client;
  bool contextActionPerform = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getPhotos (int accidentID) async {
    try {
      dynamic result = await supabase.from('Accident_Photos').select('filePath').eq('accidentId', accidentID);
      print (result);
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

  @override
  Widget build(BuildContext context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    if (!contextActionPerform) {
      
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Accept accident ${data['ID']}'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: (){
              OpenGoogleMaps(data['lat'], data['long']);
            },
            child: Text('Go to location')
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Image.file(
                _images[index],
                fit: BoxFit.cover,
              );
            },
          ),
        ],
      ),
    );
  }
}