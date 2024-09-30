import 'package:flutter/material.dart';
import 'detailedReport3.dart';
//if there are injuries and or not all poeple invloved are present call 911

class detailedReport2 extends StatefulWidget {
  @override
  _detailedReport2State createState() => _detailedReport2State();
}

class _detailedReport2State extends State<detailedReport2> {
  // Variables to track the selected yes/no for each option
  String? _option1;
  String? _option2;
  String? _option3;

  @override
  Widget build(BuildContext context) {
    bool allOptionsSelected = _option1 != null && _option2 != null && _option3 != null;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Choose an option for each:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Option 1
          Text("Is there any injuries ?"),
          ListTile(
            title: const Text('Yes'),
            leading: Radio<String>(
              value: 'Yes',
              groupValue: _option1,
              onChanged: (String? value) {
                setState(() {
                  _option1 = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('No'),
            leading: Radio<String>(
              value: 'No',
              groupValue: _option1,
              onChanged: (String? value) {
                setState(() {
                  _option1 = value;
                });
              },
            ),
          ),
          // Option 2
          Text("Is everyone involved present ?"),
          ListTile(
            title: const Text('Yes'),
            leading: Radio<String>(
              value: 'Yes',
              groupValue: _option2,
              onChanged: (String? value) {
                setState(() {
                  _option2 = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('No'),
            leading: Radio<String>(
              value: 'No',
              groupValue: _option2,
              onChanged: (String? value) {
                setState(() {
                  _option2 = value;
                });
              },
            ),
          ),
          // Option 3
          Text("Does everyone have a valid insurance ?"),
          ListTile(
            title: const Text('Yes'),
            leading: Radio<String>(
              value: 'Yes',
              groupValue: _option3,
              onChanged: (String? value) {
                setState(() {
                  _option3 = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('No'),
            leading: Radio<String>(
              value: 'No',
              groupValue: _option3,
              onChanged: (String? value) {
                setState(() {
                  _option3 = value;
                });
              },
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous page
                  },
                  child: Text('Go Back'),
                ),
                if (allOptionsSelected) // Show Next button only when all options are selected
                  ElevatedButton(
                    onPressed:
                      //back end dev
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => detailedReport3()),
                      );
                    },

                    child: Text('Next'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
