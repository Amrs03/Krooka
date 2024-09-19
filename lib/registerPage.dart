import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'globalVariables.dart';
import 'signInPage.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _fNameControler,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Your First Name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lNameControler,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Your Last Name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _idControler,
                decoration: InputDecoration(labelText: 'ID Number'),
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
              TextFormField(
                controller: _pNumberControler,
                decoration: InputDecoration(labelText: 'Phone Number'),
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
              TextFormField(
                controller: _dateControler,
                decoration: InputDecoration(
                  labelText: "Date of birth",
                  suffixIcon: Icon(Icons.calendar_today),
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
              TextFormField(
                controller: _passWordControler,
                decoration: InputDecoration(labelText: 'Password'),
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
              TextFormField(
                controller: _confirmPassWordControler,
                decoration: InputDecoration(labelText: 'Confirm Password'),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Processing Registration')),
                    );
                    try {
                      AppUser newUser = AppUser(
                        _fNameControler.text,
                        _lNameControler.text,
                        int.parse(_idControler.text),
                        int.parse(_pNumberControler.text),
                        _selectedDate!,
                        _passWordControler.text,
                      );
                      AuthResponse result = await _auth.signUp('${int.parse(_idControler.text)}@example.com', _passWordControler.text);    
                      await _auth.supabase.from('User').insert({
                        'IdNumber' : int.parse(_idControler.text),
                        'Password' : _passWordControler.text,
                        'PhoneNum' : int.parse(_pNumberControler.text),
                        'FirstName' : _fNameControler.text,
                        'LastName' : _lNameControler.text,
                        'DoB': _selectedDate!.toIso8601String().split('T')[0],
                        'AuthID' : result.user!.id
                      });
                      print (result.user);  
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    } catch (e) {
                      print('Failed to register: ${e.toString()}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to register, please try again')),
                      );
                    }
                  }
                },
                child: Text('Register')
              )
            ],
          ),
        ),
      ),
    );
  }
}