import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class PhotoDialog extends StatelessWidget {
  final String photoUrl;

  const PhotoDialog({required this.photoUrl});

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
          child: Hero(
            tag: photoUrl,
            child: Image.network(
              photoUrl,
              fit: BoxFit.contain,
            ),
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
      if (_images.isNotEmpty) {
        return;
      }
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
    final ScreenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: ScreenHeight*0.05),
          GestureDetector(
            // onTap: (){},
            child: Container(
              width: ScreenWidth*0.8,
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
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: ScreenWidth*0.1),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GestureDetector(
                              onTap: (){
                                showDialog(
                                  context: context,
                                  builder: (context) => PhotoDialog(photoUrl: _images[index])
                                );
                              },
                              child: Hero(
                                tag: _images[index], 
                                child: Image.network(
                                  _images[index],
                                  fit:BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(Icons.error, color: Colors.red),
                                    );
                                  }
                                )
                              )
                            ),
                          ),
                        );
                      },
                    ),
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