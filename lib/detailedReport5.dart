import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krooka/HomePage.dart';
import 'package:krooka/globalVariables.dart';
import 'package:krooka/myVehicles.dart';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class detailedReport5 extends StatefulWidget {
  @override
  _detailedReport5State createState() => _detailedReport5State();
}

class _detailedReport5State extends State<detailedReport5> {
  final ImagePicker _picker = ImagePicker();
  final bucket = Supabase.instance.client.storage.from('accident-images');
  final SupabaseClient supabase = Supabase.instance.client;
  List<File> _images = [];
  bool hasNavigated = false;

  // Function to pick an image from the camera
  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  // Function to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _uploadImagesToStorage (int id) async {
    try {
      for (int i = 0; i < _images.length; i++){
        Uint8List fileBytes = await _images[i].readAsBytes();
        String filePath = 'user-uploads/$id-${i+1}';
        await bucket.uploadBinary(filePath, fileBytes, fileOptions: FileOptions(contentType: 'image/jpeg'));
        String signedUrl = await bucket.createSignedUrl(filePath, 604800);
        await supabase.from("Accident_Photos").insert({
          "accidentId" : id,
          "filePath" : signedUrl,
        });
      }
    }
    catch(e) {
      print('Error uploading image : $e');
    }    
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void checkIfOfficerAccepted(int AccidentID ,double lat , double long) {
    supabase.channel('Accident').onPostgresChanges(
    event: PostgresChangeEvent.update,
    schema: 'public',
    table: 'Accident',
    filter: PostgresChangeFilter(
      type: PostgresChangeFilterType.neq, 
      column: 'OfficerID', 
      value: null,
    ),
    callback: (payload) {
      if (payload.newRecord['AccidentID'] == AccidentID && !hasNavigated) {
        hasNavigated = true;
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pushReplacementNamed(context, '/InProgress', arguments: <String, dynamic>{
          'Lat' : lat,
          'Long' : long,
          'ID' : AccidentID
        });
      }
    },
  ).subscribe();
  }

  void showWaitingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          title:Text("Waiting for officer approval..." ,style:TextStyle(fontSize: 16 , fontWeight: FontWeight.bold),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15),
              Text("Your report has been issued. Get to the side of the road."),
              SizedBox(height: 30),
              SpinKitFadingCircle(color: Colors.black, size: 50.0),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accident photos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Take photos for the report:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Buttons to take photos or select from gallery
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _pickImageFromCamera,
                  child: Text('Take Photo'),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: _pickImageFromGallery,
                  child: Text('From Gallery'),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Display the photos taken by the user
            Expanded(
              child: GridView.builder(
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous page
                  },
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      if (_images.isEmpty) {
                        _showSnackBar("Please upload the photos of the accident");
                      }
                      else {
                        showWaitingDialog();

                        dynamic data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                        print (data);
                        dynamic userID = await supabase.from('User').select('IdNumber').eq('AuthID', AuthService.authID!).single();
                        final response = await supabase.from('Accident').insert({
                          "Injuries" : data['Inj'] == 'Yes' ? true : false,
                          "NumberOfCars" : data['Plates'].length,
                          "latitude" : data['Lat'],
                          "longitude" : data['Long'],
                          "applicantID" : userID['IdNumber']
                        }).select('AccidentID').single();
                        List plates = data['Plates'];
                        plates.forEach((plate) async{
                          print (plate);
                          await supabase.from("Been In").insert({
                            "PlateNumber" : plate,
                            "AccidentID" : response['AccidentID'],
                            "EligForComp" : false,
                            "Status" : "Pending",
                          });
                        });
                        await _uploadImagesToStorage(response["AccidentID"]);

                        checkIfOfficerAccepted(response['AccidentID'] , data['Lat'], data['Long']);

                      }
                    }
                    catch(e){
                      print('Error submitting the report : $e');
                    }
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
