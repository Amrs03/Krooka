// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
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
  int _counter = 1;
  void _incrementCounter () {
    setState(() {
      _counter++;
    });
  }
  void _decrementCounter () {
    if (_counter-1 >= 1){
      setState(() {
        _counter--;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    bool allOptionsSelected = _option1 != null && _option2 != null && _option3 != null;
    final ScreenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Choose an option for each:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Option 1
          Padding(child: Text("Are there any injuries ?", style: TextStyle(fontSize: ScreenWidth*0.04, fontWeight: FontWeight.bold)), padding: EdgeInsets.only(left: 20)),
          ListTile(
            title: const Text('Yes', style: TextStyle(fontWeight: FontWeight.bold)),
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
            title: const Text('No', style: TextStyle(fontWeight: FontWeight.bold)),
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
          Padding(child: Text("Is everyone involved present ?", style: TextStyle(fontSize:ScreenWidth*0.04, fontWeight: FontWeight.bold)),padding: EdgeInsets.only(left: 20)),
          ListTile(
            title: const Text('Yes', style: TextStyle(fontWeight: FontWeight.bold)),
            leading: Radio<String>(
              value: 'Yes',
              groupValue: _option2,
              onChanged: (String? value) {
                setState(() {
                  _option2 = value;
                  }
                );
              },
            ),
          ),
          ListTile(
            title: const Text('No', style: TextStyle(fontWeight: FontWeight.bold)),
            leading: Radio<String>(
              value: 'No',
              groupValue: _option2,
              onChanged: (String? value) {
                setState(() {
                  _option2 = value;
                  }
                );
              },
            ),
          ),
          // Option 3
          Padding(child: Text("Does everyone have a valid insurance ?", style: TextStyle(fontSize: ScreenWidth*0.04, fontWeight: FontWeight.bold)),padding: EdgeInsets.only(left: 20)),
          ListTile(
            title: const Text('Yes', style: TextStyle(fontWeight: FontWeight.bold)),
            leading: Radio<String>(
              value: 'Yes',
              groupValue: _option3,
              onChanged: (String? value) {
                setState(() {
                  _option3 = value;
                  }
                );
              },
            ),
          ),
          ListTile(
            title: const Text('No', style: TextStyle(fontWeight: FontWeight.bold)),
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
          _option2 == 'Yes' ? Padding(
            padding: EdgeInsets.only(left: 20, top : 20),
            child: Text(
              'Number of involved Cars : ',
              style: TextStyle(fontSize: ScreenWidth*0.04, fontWeight: FontWeight.bold)
            ),
          )
          :
          Container(),
          SizedBox(height: 10),
          _option2 == 'Yes' ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: (){
                  _decrementCounter();
                },  
                icon: Icon(Icons.remove_circle_outlined, size: 38)
              ),
              Text(
                '$_counter',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  _incrementCounter();
                }, 
                icon: Icon(Icons.add_circle_outlined, size : 38)
              )
            ],
          ):
          Container(),
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
                    onPressed: () {
                      if (_option2 == 'No') {
                        showDialog(
                          barrierDismissible: true,
                          context: context, 
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Center(child: Text('Can\'t report an accident')),
                              content: Text('Reason : not all the members are present, call 911 for help', textAlign: TextAlign.center),
                              actions: [
                                TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }, 
                                  child: Text('OK')
                                )
                              ],
                            );
                          }
                        );
                      }
                      else {
                        Navigator.pushNamed(
                          context, 
                          '/DR4',
                          arguments: <String, dynamic> {
                            'Lat' : data['lat'],
                            'Long' : data['long'],
                            'Inj' : _option1,
                            'Insurance' : _option3,
                            'Counter' : _counter
                          }
                        );
                      }
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
