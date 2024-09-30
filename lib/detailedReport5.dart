import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krooka/HomePage.dart';

class detailedReport5 extends StatefulWidget {
  @override
  _detailedReport5State createState() => _detailedReport5State();
}

class _detailedReport5State extends State<detailedReport5> {
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

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
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detailed Report 5'),
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
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _pickImageFromGallery,
                  child: Text('Select from Gallery'),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Display the photos taken by the user
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
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
            // Next and Previous buttons
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
                  onPressed:
                    // submittion to database and return to home
                      () {
                        _showSnackBar("Your report has been issued. Get to the side of the road.");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
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
