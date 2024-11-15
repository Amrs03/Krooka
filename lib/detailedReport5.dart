import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krooka/HomePage.dart';
import 'package:krooka/globalVariables.dart';
import 'package:krooka/myVehicles.dart';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'detailedReport2.dart';


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
  bool isCancelled = false;

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
          'ID' : AccidentID
        });
      }
    },
  ).subscribe();
  }

  void showWaitingDialog(int accidentID) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
            title:Text("Waiting for officer approval..." ,style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Text("Your report has been issued."),
                Text("Get to the side of the road."),
                SizedBox(height: 30),
                Row(
                  children: [
                    Spacer(),
                    SpinKitFadingCircle(color: Color(0xFF0A061F), size: 50.0),
                    Spacer()
                  ],
                ),
                SizedBox(height: 15,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0A061F),
                    foregroundColor: Colors.white,
                     shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(10),
                   side: BorderSide(
                  color: Colors.black,
                   width: 1
                  )
                                                                    
                  ),
                                                                  
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: ()async{
                    await supabase.from('Accident').update({'Status' : 'canceled'}).eq('AccidentID', accidentID);
                    isCancelled = true;
                    Navigator.pop(context);
                  }, 
                  child: Text("Cancel",style: TextStyle(fontSize: 12)))
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
     final ScreenHeight = MediaQuery.of(context).size.height;
    final ScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xFFF5F5FA) ,
      ),
      body: Stack(
        children:[
          Container(
              height: ScreenHeight,
              width: ScreenWidth,
              color: Color(0xFF0A061F),
            ),
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                color:Color(0xFFF5F5FA),
                height: ScreenHeight,
                width: ScreenWidth,
              ),
            ),
           Padding(
          padding: const EdgeInsets.symmetric(vertical: 10 , horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Take photos',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              Text(
                'for the Accident:',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Buttons to take photos or select from gallery
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF7DA0CA),
                            foregroundColor: Color(0xFFF5F5FA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: ScreenWidth*0.06),
                          ) ,
                    onPressed: _pickImageFromCamera,
                    child: Text('Take Photo'),
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF7DA0CA),
                            foregroundColor: Color(0xFFF5F5FA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: ScreenWidth*0.06),
                          ) ,
                    onPressed: _pickImageFromGallery,
                    child: Text('From Gallery'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Display the photos taken by the user
              Expanded(
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(25), // Adjust the radius for the circular effect
                      child: Image.file(
                        _images[index],
                        fit: BoxFit.cover, // Ensure the image is cropped correctly to fit the container
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: ScreenHeight*0.01,),
              Row(
                
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0A061F),
                            foregroundColor: Color(0xFFF5F5FA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 40),
                          ) ,
                    onPressed: () async {
                      try {
                        if (_images.isEmpty) {
                          _showSnackBar("Please upload the photos of the accident");
                        }
                        else {
                          dynamic data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                          print (data);
                          dynamic userID = await supabase.from('User').select('IdNumber').eq('AuthID', AuthService.authID!).single();
                          List plates = data['Plates'];
                          final response = await supabase.from('Accident').insert({
                            "Injuries" : data['Inj'] == 'Yes' ? true : false,
                            "NumberOfCars" : data['Plates'].length,
                            "latitude" : data['Lat'],
                            "longitude" : data['Long'],
                            "applicantID" : userID['IdNumber'],
                            "Status" : '-'
                          }).select('AccidentID').single();
                          showWaitingDialog(response['AccidentID']);
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
                          await supabase.from('Accident').update({'Status' : 'pending'}).eq('AccidentID', response['AccidentID']);
                          if (isCancelled) {
                            Navigator.of(context).popUntil(ModalRoute.withName('/Homepage'));
                          }
                        }
                      }
                      catch(e){
                        print('Error submitting the report : $e');
                      }
                    },
                    child: Text('Report'),
                  ),
                ],
              ),
            SizedBox(height: ScreenHeight*0.17,)
            ],
          ),
        ),
        ]
      ),
    );
  }
}
