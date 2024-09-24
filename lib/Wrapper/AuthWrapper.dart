import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:krooka/signInPage.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;
  const AuthWrapper({required this.child});

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
                return SignInPage();
            }
          }
          return SignInPage();
        }
      ),  
    );
  }
}