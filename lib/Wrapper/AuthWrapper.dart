import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:krooka/signInPage.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;
  const AuthWrapper({required this.child});

  void dialog (context) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Authentication required'),
        content: Text('You have to be logged in to access the following feature'),
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