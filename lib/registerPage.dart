import 'package:flutter/material.dart';
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


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please Enter Your Name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lNameControler,
                  decoration: InputDecoration(labelText: 'Last Name'),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please Enter Your Name';
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
                  controller: _passWordControler,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long'; //add password validations
                    }
                    return null;
                  },
                ),
                // Confirm Password Input
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Registration')),
                        );
                        try {
                          User newUser = User(
                            _fNameControler.text,
                            _lNameControler.text,
                            int.parse(_idControler.text),
                            int.parse(_pNumberControler.text),
                            _passWordControler.text,
                          );

                          // Handle the created User object (e.g., save it or print the details)

                          print('User Created: ${newUser.FirstName} ${newUser.LastName}');

                          registeredUsers.add(newUser);

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignInPage()),
                          );

                        } catch (e) {
                          print('Error: ${e.toString()}');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter the ID and Phone Number in a valid format.')),
                          );
                        }
                      }
                    },
                    child: Text('Register')
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}
