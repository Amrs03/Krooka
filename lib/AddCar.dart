// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:krooka/globalVariables.dart';

class AddCar extends StatefulWidget {
  const AddCar({super.key});

  @override
  State<AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  
  final _formKey = GlobalKey<FormState>();
  TextEditingController _carVIN = TextEditingController();
  TextEditingController _carManufacturer = TextEditingController();
  TextEditingController _carModel = TextEditingController();
  TextEditingController _carYear = TextEditingController();
  TextEditingController _carColor = TextEditingController();
  TextEditingController _carPlateNum = TextEditingController();
  TextEditingController _carOwnerID = TextEditingController();

  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.sizeOf(context).width;
    final ScreenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(title: Text('Add your car'),),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TextFormField(
                  controller: _carVIN,
                  decoration: InputDecoration(
                    labelText: 'Car Chassis Number',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold), 
                    border: InputBorder.none, 
                    floatingLabelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: ScreenWidth*0.05)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the chassis number';
                    }
                    else if (value.length != 17) {
                      return 'Please enter a valid chassis number';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TextFormField(
                  controller: _carManufacturer,
                  decoration: InputDecoration(
                    labelText: 'Car Manufacturer',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold), 
                    border: InputBorder.none, 
                    floatingLabelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: ScreenWidth*0.05)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the car manufacturer';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TextFormField(
                  controller: _carModel,
                  decoration: InputDecoration(
                    labelText: 'Car Model',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold), 
                    border: InputBorder.none, 
                    floatingLabelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: ScreenWidth*0.05)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the car model';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TextFormField(
                  controller: _carYear,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: 'Car Year',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold), 
                    border: InputBorder.none, 
                    floatingLabelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: ScreenWidth*0.05),
                    counterText: ""
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the car year';
                    }
                    int year = int.parse(value);
                    if (year < 1900 || year > DateTime.now().year) {
                      return 'Please enter a valid year';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TextFormField(
                  controller: _carColor,
                  decoration: InputDecoration(
                    labelText: 'Car Color',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold), 
                    border: InputBorder.none, 
                    floatingLabelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: ScreenWidth*0.05)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the car color';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TextFormField(
                  controller: _carPlateNum,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    labelText: 'Car Plate Number',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold), 
                    border: InputBorder.none, 
                    floatingLabelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: ScreenWidth*0.05)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the car plate number';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TextFormField(
                  controller: _carOwnerID,
                  decoration: InputDecoration(
                    labelText: 'Car Owner ID',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold), 
                    border: InputBorder.none, 
                    floatingLabelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: ScreenWidth*0.05)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the car owner ID';
                    }
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'ID must be exactly 10 digits';
                    }
                    return null;
                  },
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await _auth.supabase.from("Car").insert({
                        "ChassisNumber" : int.parse(_carVIN.text),
                        "OwnerID": int.parse(_carOwnerID.text),
                        "PlateNumber": _carPlateNum.text,
                        "Manufacturer": _carManufacturer.text,
                        "Year":_carYear.text,
                        "Model": _carModel.text,
                        "Color": _carColor.text,
                      });

                       // Now We need to add the UserId And CarVin to the 'Have' table 
                      
                      print("Car Added");
                      Navigator.pop(context);
                    } 
                    catch (e) {
                      print('Failed to add the car: ${e.toString()}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to register, please try again')),
                      );
                    }
                  }
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 30),
                  width: ScreenWidth * 0.35,
                  height: ScreenHeight * 0.05,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey,
                  ),
                  child: Center(child: Text('Add car', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold))),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}

