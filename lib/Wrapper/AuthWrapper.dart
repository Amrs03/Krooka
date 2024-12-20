import 'package:flutter/material.dart';
import 'package:krooka/HomePage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:krooka/signInPage.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;
  const AuthWrapper({required this.child});

  void dialog (context) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          
        title: Text('Authentication required',style: TextStyle(fontWeight: FontWeight.bold),),
        content: Text('You have to be logged in to access the following feature'),
        actions: [
          Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red[300],
                  ),
                  child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close_outlined)),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final authState = snapshot.data;
          if (authState != null) {
            final AuthChangeEvent event = authState.event;
            switch (event) {
              case AuthChangeEvent.signedIn:
                return child; 
              default:
                Future.delayed(Duration.zero, ()=>dialog(context));
            }
          }
          return SignInPage();
        }
      ),  
    );
  }
}

class InProgressWrapper extends StatelessWidget {
  final Widget child;
  final dynamic accidentID;
  const InProgressWrapper({required this.child, required this.accidentID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Supabase.instance.client.from('Accident').stream(primaryKey: ['AccidentID']).eq('AccidentID', accidentID), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final accidentState = snapshot.data;
          if (accidentState != null) {
            if (accidentState.first['Status'] == 'complete') {
              print ('Completed');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (ModalRoute.of(context)?.isCurrent ?? false) {
                  showDialog(
                    context: context,
                    barrierDismissible: false, 
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        title: Text(
                          "Accident completed",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            Text("We're glad you're safe."),
                            SizedBox(height: 15),
                            Text("Thank you for using Krooka."),
                            SizedBox(height: 15),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF0A061F),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                                Navigator.of(context).popUntil(
                                    ModalRoute.withName('/Homepage'));
                              },
                              child: Text("Done", style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              });
              return Center(child: CircularProgressIndicator());
            }
            else {
              return child;
            }
          }
          return Center(child: CircularProgressIndicator());
        }
      ),  
    );
  }
}