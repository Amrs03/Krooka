import 'package:flutter/material.dart';
import 'detailedReport4.dart';

class detailedReport3 extends StatefulWidget {
  @override
  _detailedReport3State createState() => _detailedReport3State();
}

class _detailedReport3State extends State<detailedReport3> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Counter:',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            '$_counter',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _incrementCounter,
            child: Text('Increment Counter'),
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
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed:
                    // back end dev
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => detailedReport4(numberOfFields: _counter)),
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
