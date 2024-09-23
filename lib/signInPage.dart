import 'package:flutter/material.dart';
import 'globalVariables.dart';
import 'registerPage.dart';
import 'HomePage.dart';
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'ID Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your ID number';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'ID must be exactly 10 digits';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                    try {
                      await _auth.signIn(_idController.text, _passwordController.text);
                      print ('User signed in successfully');
                      userID = _idController.text;
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => homePage()),
                      );
                    }
                    catch(e) {
                      print('Failed to sign in: ${e.toString()}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to sign in, please try again')),
                      );
                    }
                  }
                },
                child: Text('Sign In'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => registerPage()),
                  );
                },
                child: Text("Don't have an account? Register here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
