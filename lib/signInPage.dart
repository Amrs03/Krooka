import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
       final ScreenHeight = MediaQuery.sizeOf(context).height;
    final ScreenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      resizeToAvoidBottomInset: false, 
      
      // appBar: AppBar(
      //   title: Text('Sign In'),
      // ),
      body: Stack(
        children:[ 
          Container(
            width: ScreenWidth,
            height: ScreenHeight,
            color: Colors.white,
          ),
          ClipPath(
            clipper: CustomClipperPath(),
            child: Container(
              height: ScreenHeight,
              width: ScreenWidth,
              color: Color(0xFF0A061F),
            ),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ScreenHeight*0.05,),
              Text("Sign In",style: TextStyle(fontSize: ScreenWidth*0.08 , color: Color(0xFF0A061F), fontWeight: FontWeight.bold),),
              SizedBox(height: ScreenHeight*0.05,),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("ID Number",style: TextStyle(fontSize: ScreenWidth*0.03 , color: Color(0xFF0A061F)),textAlign: TextAlign.left,),
                    TextFormField(
                      controller: _idController,
                      decoration: InputDecoration(labelText: 'ID Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(color: Color(0xF5F5FA), width: 1)
                      ) ,
                      contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15) ,
                      floatingLabelBehavior: FloatingLabelBehavior.never, 
                      isDense: true
                      ),
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
                    SizedBox(height: 8,),
                    Text("Password",style: TextStyle(fontSize: ScreenWidth*0.03 , color: Color(0xFF0A061F)),textAlign: TextAlign.left,),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(color: Color(0xF5F5FA), width: 1)
                      ) ,
                      contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15) ,
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
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0A061F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40),
                      ),
                      onPressed: () async{
                        if (_formKey.currentState!.validate()) {
                          try {
                            AuthResponse result = await _auth.signIn(_idController.text, _passwordController.text);
                            print ('User signed in successfully : ${result.user}');
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
                      child: Text('Sign In' , style:TextStyle(fontSize: ScreenWidth*0.037),),
                    ),
                    SizedBox(height: ScreenWidth*0.41),
                    Text("Don't have an account", style: TextStyle(color: Colors.white , fontSize: ScreenWidth*0.07 , fontWeight: FontWeight.bold),),
                    Row(
                      children: [
                        SizedBox(width: ScreenWidth*0.4,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF0A061F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 40),
                          ),
                          onPressed: (){
                             Navigator.push(
                               context,
                               MaterialPageRoute(builder: (context) => registerPage()),
                              );
                          },
                           child: Text("Sign Up"),
                          ),
                      ],
                    )
                   

                  ],
                ),
              ),
            ],
          ),
        ),
        ]
      ),
    );
  }
}



class CustomClipperPath extends CustomClipper<Path> {
  @override
 Path getClip(Size size) {
    Path path = Path();

    // Start from the mid-left of the container
    path.lineTo(0, size.height *0.70); // Middle of the left side
    // Draw a line to the top-right corner of the container
    path.lineTo(size.width, size.height*0.62); // Top-right corner
    path.lineTo(size.width, size.height); // Bottom-right corner
    path.lineTo(0, size.height); // Bottom-left corner
    path.close(); // Complete the path

    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}