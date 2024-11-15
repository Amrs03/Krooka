// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:krooka/globalVariables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddCar extends StatefulWidget {
  const AddCar({super.key});

  @override
  State<AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  String aId = AuthService.authID!;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _carVIN = TextEditingController();
  TextEditingController _carManufacturer = TextEditingController();
  TextEditingController _carModel = TextEditingController();
  TextEditingController _carYear = TextEditingController();
  TextEditingController _carColor = TextEditingController();
  TextEditingController _carPlateNum = TextEditingController();
  TextEditingController _carOwnerID = TextEditingController();

  final supabase = Supabase.instance.client;
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }
  String? validateVIN(String value) {
  if (value.isEmpty ) {
    return 'Please enter the car manufacturer';
  }
   else if (value.length != 17) {
    return 'Please enter a valid chassis number';
  }
  return null;
}
  // 1. Car Manufacturer - Cannot be empty
String? validateManufacturer(String value) {
  if (value.isEmpty) {
    return 'Please enter the car manufacturer';
  }
 
  return null; 
}

// 2. Car Model - Cannot be empty
String? validateModel(String value) {
  if (value.isEmpty) {
    return 'Please enter the car model';
  }
  return null;
}

// 3. Car Year - Valid 4-digit year
String? validateYear(String value) {
  if (value.isEmpty) {
    return 'Please enter the car year';
  }
  int? year = int.tryParse(value);
  if (year == null || year < 1900 || year > DateTime.now().year) {
    return 'Please enter a valid year between 1900 and ${DateTime.now().year}';
  }
  return null;
}

// 4. Car Color - Cannot be empty
String? validateColor(String value) {
  if (value.isEmpty) {
    return 'Please enter the car color';
  }
  return null;
}

// 5. Car Plate Number - Cannot be empty
String? validatePlateNumber(String value) {
  if (value.isEmpty) {
    return 'Please enter the car plate number';
  }
  return null;
}

// 6. Car Owner ID - Exactly 10 digits
String? validateOwnerID(String value) {
  if (value.isEmpty) {
    return 'Please enter the car owner ID';
  }
  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
    return 'Owner ID must be exactly 10 digits';
  }
  return null;
}

  @override
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.sizeOf(context).width;
    final ScreenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: Color(0xFF0A061F),foregroundColor: Color(0xFFF5F5FA),),
      body: Stack(
        children:[
          Container(
              height: ScreenHeight,
              width: ScreenWidth,
              color:Color(0xFFF5F5FA) ,
            ),
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                color:Color(0xFF0A061F),
                height: ScreenHeight,
                width: ScreenWidth,
              ),
            ),
         Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _carVIN,
                    style: TextStyle(color: Colors.white), // Text color set to white
                    decoration: InputDecoration(
                      labelText: 'Car Chassis Number',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold), 
                      
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xF5F5FA), width: 1)
                      ) , 
                      floatingLabelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: ScreenWidth*0.035)
                      ,isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15) ,
                  
                    ),
                    
                    
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _carManufacturer,
                    style: TextStyle(color: Colors.white), // Text color set to white
                    decoration: InputDecoration(
                      labelText: 'Car Manufacturer',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold), 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xF5F5FA), width: 1)
                      ) ,
                      floatingLabelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: ScreenWidth*0.035)
                      ,isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15) ,
                    ),
                   
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _carModel,
                    style: TextStyle(color: Colors.white), // Text color set to white
                    decoration: InputDecoration(
                      labelText: 'Car Model',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold), 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xF5F5FA), width: 1)
                      ) , 
                      floatingLabelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: ScreenWidth*0.035)
                      ,isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15) ,
                    ),
                    
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _carYear,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    style: TextStyle(color: Colors.white), // Text color set to white
                    
                    decoration: InputDecoration(
                      labelText: 'Car Year' ,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold ,), 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFF5F5FA), width: 1)
                      ) ,
                      floatingLabelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: ScreenWidth*0.035),
                      counterText: ""
                      ,isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15) ,
                  
                    
                    ),
                    
                    
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _carColor,
                    style: TextStyle(color: Colors.white), // Text color set to white
                    decoration: InputDecoration(
                      labelText: 'Car Color',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold), 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xF5F5FA), width: 1)
                      ) ,
                      floatingLabelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: ScreenWidth*0.035)
                      ,isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15) ,
                    ),
                    
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _carPlateNum,
                    style: TextStyle(color: Colors.white), // Text color set to white
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      labelText: 'Car Plate Number',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold), 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xF5F5FA), width: 1)
                      ) ,
                      floatingLabelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: ScreenWidth*0.035)
                      ,isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15) ,
                    ),
                    
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _carOwnerID,
                    style: TextStyle(color: Colors.white), // Text color set to white
                    decoration: InputDecoration(
                      labelText: 'Car Owner ID',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold), 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xF5F5FA), width: 1)
                      ) , 
                      floatingLabelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: ScreenWidth*0.035)
                      ,isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15) ,
                    ),
                    
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    String? manufacturerError = validateManufacturer(_carManufacturer.text);
                    String? yearError = validateYear(_carYear.text);
                    String? ownerIdError = validateOwnerID(_carOwnerID.text);
                    String? plateNumberError = validatePlateNumber(_carPlateNum.text);
                    String? modelError = validateModel(_carModel.text);
                    String? colorError = validateColor(_carColor.text);
                    String? engineNumberError = validateVIN(_carVIN.text);

                    // Check each field and display the first encountered error in a SnackBar
                    if (manufacturerError != null) {
                      _showSnackBar(manufacturerError);
                      return;
                    }
                    if (yearError != null) {
                      _showSnackBar(yearError);
                      return;
                    }
                    if (ownerIdError != null) {
                      _showSnackBar(ownerIdError);
                      return;
                    }
                    if (plateNumberError != null) {
                      _showSnackBar(plateNumberError);
                      return;
                    }
                  
                    if (modelError != null) {
                      _showSnackBar(modelError);
                      return;
                    }
                    if (colorError != null) {
                      _showSnackBar(colorError);
                      return;
                    }
                    if (engineNumberError != null) {
                      _showSnackBar(engineNumberError);
                      return;
                    }

                    // If all validations pass, proceed with form submission
                    _showSnackBar('Form submitted successfully!');
                    // Continue with the submission process (e.g., database entry)
                    if (_formKey.currentState!.validate()) {
                      try {
                        // Check if the car already exists in the database
                        dynamic UIDNumber = await supabase.from('User').select('IdNumber').eq('AuthID', aId).single();
                        dynamic existingCar = await supabase.from("Car").select().eq("ChassisNumber", int.parse(_carVIN.text)).maybeSingle();
        
                        if (existingCar != null) {
                          print("Car with this ChassisNumber already exists!");
                          bool isSame = existingCar["OwnerID"] == int.parse(_carOwnerID.text) &&
                                existingCar["PlateNumber"] == _carPlateNum.text &&
                                existingCar["Manufacturer"].toString().toLowerCase() == _carManufacturer.text.toLowerCase() &&
                                existingCar["Year"] == _carYear.text &&
                                existingCar["Model"].toString().toLowerCase() == _carModel.text.toLowerCase() &&
                                existingCar["Color"].toString().toLowerCase() == _carColor.text.toLowerCase();
                          if(isSame){
                            await supabase.from("Have").insert({
                              "IdNumber": UIDNumber["IdNumber"].toString(),
                              "ChassisNumber": int.parse(_carVIN.text),
                            });
        
                            print("Relation added to Have table");
                            print("Car Added");
                            Navigator.pop(context); 
                          }
                          else {
                          // Fields do not match, show an error message
                          print("Information is incorrect!");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Information does not match the existing car!')),
                          );
                        }
                          
                        } else {
                          // If car doesn't exist, proceed with the insertion
                          await supabase.from("Car").insert({
                            "ChassisNumber": int.parse(_carVIN.text),
                            "OwnerID": int.parse(_carOwnerID.text),
                            "PlateNumber": _carPlateNum.text,
                            "Manufacturer": _carManufacturer.text,
                            "Year": _carYear.text,
                            "Model": _carModel.text,
                            "Color": _carColor.text,
                          });
        
                          // Now add the UserId and CarVin to the 'Have' table
                          await supabase.from("Have").insert({
                            "IdNumber": UIDNumber["IdNumber"].toString(),
                            "ChassisNumber": int.parse(_carVIN.text),
                          });
        
                          print("Car Added");
                          Navigator.pop(context);  
                        }
        
                      } catch (e) {
                        print('Failed to add the car: ${e.toString()}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add car, please try again')),
                        );
                      }
        
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 30),
                    width: ScreenWidth * 0.7,
                    height: ScreenHeight * 0.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xFF0A061F),
                    ),
                    child: Row(
                      children: [
                        Spacer(),
                        Text('Add Car', style: TextStyle(fontSize: ScreenWidth*0.045, color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(width: ScreenWidth*0.03,),
                        Icon(Icons.directions_car_outlined , color: Colors.white,),
                        Spacer()
                      ],
                    ),
                  ),
                )
              ],
            )
          ),
        ),
        ]
      ),
    );
  }
}


class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip( size) {
    var path = Path();

   path.lineTo(0, size.height * 0.8);

  path.quadraticBezierTo(
    size.width * 0.125, size.height * 0.73,   
    size.width * 0.5, size.height * 0.8      
  );

  path.quadraticBezierTo(
    size.width * 0.875, size.height * 0.87,  
    size.width, size.height * 0.8            
  );

  
  path.lineTo(size.width, 0);
  path.lineTo(0, 0); 
    path.close(); 
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}