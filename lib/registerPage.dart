import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'globalVariables.dart';
class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fNameControler = TextEditingController();
  final TextEditingController _lNameControler = TextEditingController();
  final TextEditingController _idControler = TextEditingController();
  final TextEditingController _pNumberControler = TextEditingController();
  final TextEditingController _passWordControler = TextEditingController();
  final TextEditingController _confirmPassWordControler = TextEditingController();
  final TextEditingController _dateControler = TextEditingController();
  final AuthService _auth = AuthService();
  DateTime? _selectedDate; // DateTime variable to store the selected date

  @override
  void dispose() {
    _dateControler.dispose();
    _fNameControler.dispose();
    _lNameControler.dispose();
    _idControler.dispose();
    _pNumberControler.dispose();
    _passWordControler.dispose();
    _confirmPassWordControler.dispose();
    super.dispose();
  }

  _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Current date as the initial date
      firstDate: DateTime(2000),   // Earliest date the user can pick
      lastDate: DateTime(2100),    // Latest date the user can pick
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;  // Store the selected date in the DateTime variable
        _dateControler.text = "${pickedDate.toLocal()}".split(' ')[0]; // Update the TextFormField
      });
    }
  }

  Widget build(BuildContext context) {
      final ScreenHeight = MediaQuery.sizeOf(context).height;
    final ScreenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
        resizeToAvoidBottomInset: false, 
      
      body: Stack(
        children:[
          Container(
              height: ScreenHeight,
              width: ScreenWidth,
              color: Color(0xFFF5F5FA),
            ),
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                color:Color(0xFF0A061F),
                height: ScreenHeight,
                width: ScreenWidth,
              ),
            ),
           Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ScreenHeight*0.03,),
              Text("Sign Up" ,style: TextStyle(color: Colors.white , fontSize: ScreenWidth*0.08),),
              SizedBox(height: 18,),
              Form(
                key: _formKey,
                child: Expanded(
                  child: ListView(
                    children:[
                      Text("First Name",style: TextStyle(fontSize: ScreenWidth*0.03 , color: Colors.white),textAlign: TextAlign.left,),
                      TextFormField(
                        controller: _fNameControler,
                        decoration: InputDecoration(labelText: 'First Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Color(0xF5F5FA), width: 1)
                        ) ,
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15) ,
                        floatingLabelBehavior: FloatingLabelBehavior.never, 
                        isDense: true
                          ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Your First Name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 5,),
                      Text("Last Name",style: TextStyle(fontSize: ScreenWidth*0.03 , color: Colors.white),textAlign: TextAlign.left,),
                      TextFormField(
                        controller: _lNameControler,
                        decoration: InputDecoration(labelText: 'Last Name',
                         border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Color(0xF5F5FA), width: 1)
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15), 
                        floatingLabelBehavior: FloatingLabelBehavior.never, 
                        isDense: true
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Your Last Name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 5,),
                      Text("ID Number",style: TextStyle(fontSize: ScreenWidth*0.03 , color: Colors.white),textAlign: TextAlign.left,),
                      TextFormField(
                        controller: _idControler,
                        decoration: InputDecoration(labelText: 'ID Number',
                         border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Color(0xF5F5FA), width: 1)
                        ) ,
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        floatingLabelBehavior: FloatingLabelBehavior.never, 
                        isDense: true
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your ID';
                          }
                          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            return 'ID must be exactly 10 digits';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 5,),
                      Text("Phone Number",style: TextStyle(fontSize: ScreenWidth*0.03 , color: Colors.white),textAlign: TextAlign.left,),
                      TextFormField(
                        controller: _pNumberControler,
                        decoration: InputDecoration(labelText: 'Phone Number',
                         border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Color(0xF5F5FA), width: 1)
                        ) ,
                        floatingLabelBehavior: FloatingLabelBehavior.never, 
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        isDense: true
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            return 'Please Enter a Valid Phone Number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 5,),
                      Text("Date of Birth",style: TextStyle(fontSize: ScreenWidth*0.03 , color: Colors.white),textAlign: TextAlign.left,),
                      TextFormField(
                        controller: _dateControler,
                        decoration: InputDecoration(
                          labelText: "Date of birth",
                          suffixIcon: Icon(Icons.calendar_today ),
                          suffixIconConstraints: BoxConstraints(
                            minWidth: 30
                          ),
                          border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Color(0xF5F5FA), width: 1)
                        ) ,
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        floatingLabelBehavior: FloatingLabelBehavior.never, 
                        isDense: true
                        ),
                        readOnly: true,  // User cannot manually enter a date
                        onTap: () {
                          _selectDate(context);  // Open date picker on tap
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 5,),
                      Text("Password",style: TextStyle(fontSize: ScreenWidth*0.03 , color: Colors.white),textAlign: TextAlign.left,),
                      TextFormField(
                        controller: _passWordControler,
                        decoration: InputDecoration(labelText: 'Password',
                         border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Color(0xF5F5FA), width: 1)
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15) ,
                        floatingLabelBehavior: FloatingLabelBehavior.never, 
                        isDense: true
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 5,),
                      Text("Confirm Password",style: TextStyle(fontSize: ScreenWidth*0.03 , color: Colors.white),textAlign: TextAlign.left,),
                      TextFormField(
                        controller: _confirmPassWordControler,
                        decoration: InputDecoration(labelText: 'Confirm Password',
                         border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Color(0xF5F5FA), width: 1)
                        ) ,
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        floatingLabelBehavior: FloatingLabelBehavior.never, 
                        isDense: true
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passWordControler.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      Positioned(
                        bottom: 0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF7DA0CA),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 35),
                          ),
                                  
                          
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Processing Registration')),
                              );
                              try {
                                AuthResponse result = await _auth.signUp('${int.parse(_idControler.text)}@example.com', _passWordControler.text);    
                                await _auth.supabase.from('User').insert({
                                  'IdNumber' : int.parse(_idControler.text),
                                  'Password' : _passWordControler.text,
                                  'PhoneNum' : _pNumberControler.text,
                                  'FirstName' : _fNameControler.text,
                                  'LastName' : _lNameControler.text,
                                  'DoB': _selectedDate!.toIso8601String().split('T')[0],
                                  'AuthID' : result.user!.id
                                });
                                await _auth.signOut();
                                print (result.user);  
                                Navigator.pop(context);
                              } catch (e) {
                                print('Failed to register: ${e.toString()}');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to register, please try again')),
                                );
                              }
                            }
                          },
                          child: Text('Submit', style:TextStyle(fontSize: ScreenWidth*0.035),)
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height-size.height*0.175); // Start at bottom-left
    
    // First upward curve
    path.quadraticBezierTo(
      size.width / 4, size.height - size.height*0.25,  // First control point for upward curve
      size.width / 2, size.height - size.height*0.25,   // Peak of the upward curve
    );

    // Second downward curve
    path.quadraticBezierTo(
      size.width*0.9 , size.height - size.height*0.25,    // Control point for downward curve
      size.width, size.height - size.height*0.35,       // Bottom-right of the curve
    );

    // Complete the path by drawing up to the top-right corner and closing the shape
    path.lineTo(size.width, 0); // Move to top-right corner
    path.lineTo(0, 0); // Back to top-left corner
    path.close(); // Complete the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}