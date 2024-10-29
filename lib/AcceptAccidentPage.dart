import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class acceptAccident extends StatefulWidget {
  final Map<String, dynamic> data;

  const acceptAccident({required this.data});

  @override
  State<acceptAccident> createState() => _acceptAccidentState();
}

class _acceptAccidentState extends State<acceptAccident> {
  List<String> _images = [];
  final SupabaseClient supabase = Supabase.instance.client; 
  bool contextActionPerform = false;


  @override
  void initState() {
    super.initState();
    // getPhotos(widget.data['ID']);
  }

  Future<void> getPhotos (int accidentID) async {
    try {
      dynamic result = await supabase.from('Accident_Photos').select('filePath').eq('accidentId', accidentID);
      result.forEach((url) {
        _images.add(url['filePath']);
      });
      // setState(() {});
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
    _images.clear();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Accept accident ${widget.data['ID']}'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: (){
              OpenGoogleMaps(widget.data['lat'], widget.data['long']);
            },
            child: Text('Go to location')
          ),
          Expanded(
            child: FutureBuilder(
              future: getPhotos(widget.data['ID']),
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
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        _images[index],
                        fit: BoxFit.cover,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}