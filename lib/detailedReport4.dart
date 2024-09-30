import 'package:flutter/material.dart';
import 'detailedReport5.dart';

class detailedReport4 extends StatefulWidget {
  final int numberOfFields; // Counter value from DetailedReport3

  detailedReport4({required this.numberOfFields});

  @override
  _detailedReport4State createState() => _detailedReport4State();
}

class _detailedReport4State extends State<detailedReport4> {
  // List to store text controllers for plate numbers
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize text controllers based on the number of fields
    _controllers = List.generate(widget.numberOfFields, (index) => TextEditingController());
  }

  @override
  void dispose() {
    // Dispose all text controllers when the widget is destroyed
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detailed Report 4'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the plate numbers for the cars:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Dynamically create the text fields for each car plate number
            Expanded(
              child: ListView.builder(
                itemCount: widget.numberOfFields,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextField(
                      controller: _controllers[index],
                      decoration: InputDecoration(
                        labelText: 'Car ${index + 1} Plate Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to DetailedReport3
                  },
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: //place pics in DB
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => detailedReport5()),
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
