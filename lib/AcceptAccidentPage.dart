import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

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


  @override
  void initState() {
    super.initState();
    getPhotos(widget.data['ID']);
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.sizeOf(context).width;
    final ScreenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: ScreenHeight*0.05),
          GestureDetector(
            onTap: (){
              OpenGoogleMaps(widget.data['lat'], widget.data['long']);
            },
            child: Container(
              width: ScreenWidth*0.9,
              height: ScreenHeight *0.075,
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
                    Icon(Icons.room, size: 26),
                    SizedBox(width: 10),
                    Text("Go to location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenWidth*0.05),
              child: GridView.builder(
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
                    child: done ? Image.memory(imageBytes[index], fit: BoxFit.cover): Center(child: CircularProgressIndicator())
                  );
                }
              ),
            ),
          ) 
        ],
      ),
    );
  }
}