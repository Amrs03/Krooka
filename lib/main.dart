import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Supabase_config.dart';
void main() async{
  try {
    await Supabase.initialize(
      url:url,
      anonKey:anonKey 
    );
    runApp(homePage());
    print ('Supabase connected Successfully');
  }
  catch(e) {
    print ("Error : ${e.toString()}");
  }
  
}

