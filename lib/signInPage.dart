import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krooka/officerSignIn.dart';
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
      return PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false, 
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ScreenHeight*0.05,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:  35.0),
                      child: Text("Sign In",style: TextStyle(fontSize: ScreenWidth*0.08 , color: Color(0xFF0A061F), fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:  35.0),
                      child: GestureDetector(
                        child: Image.asset('assets/copIcon.png'),
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => officerLogIn()),
                          );
                        },
                      ),
                    )
                  ] 
                ),
                SizedBox(height: ScreenHeight*0.05,),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:  35.0 , vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                    await _auth.civSignIn(_idController.text, _passwordController.text);
                                    await Navigator.pushReplacementNamed(context, '/Homepage');
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
                             SizedBox(height: ScreenHeight*0.05,),
                          ],
                        ),
                      ),
                      //SizedBox(height: ScreenWidth*0.41),
                      ClipPath(
                        clipper: CustomClipperPath(),
                        child: Container(
                          height: ScreenHeight*0.5,
                          width: ScreenWidth,
                          color: Color(0xFF0A061F),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Text("Don't have an account", style: TextStyle(color: Colors.white , fontSize: ScreenWidth*0.07 , fontWeight: FontWeight.bold),),
                              SizedBox(height: ScreenHeight*0.05,),
                              Row(
                                children: [
                                  Spacer(),
                                  //SizedBox(width: ScreenWidth*0.4,),
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
                                    SizedBox(width: ScreenWidth*0.1,)
                                ],
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      )
                     
                    
                    ],
                  ),
                ),
                Container(color: Color(0xFF0A061F), height: 100) 
              ],
            ),
          ),
        ),
      );
  }
}



class CustomClipperPath extends CustomClipper<Path> {
  @override
 Path getClip(Size size) {
    Path path = Path();

    // Start from the mid-left of the container
     path.lineTo(0, size.height * 0.2);

    // Create a wave pattern along the top border
    path.quadraticBezierTo(
      size.width * 0.25,  // Control point X
      size.height * 0.1, // Control point Y
      size.width * 0.5,   // End point X
      size.height * 0.2,  // End point Y
    );
    path.quadraticBezierTo(
      size.width * 0.75,  // Control point X
      size.height * 0.30, // Control point Y
      size.width,         // End point X
      size.height * 0.2,  // End point Y
    );

    // Draw straight lines to complete the container
    path.lineTo(size.width, size.height); // Bottom-right corner
    path.lineTo(0, size.height);       
    path.close(); // Complete the path

    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}