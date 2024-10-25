import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'HomePage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async{
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load();
    await Supabase.initialize(
      url: dotenv.env['url']!,
      anonKey:dotenv.env['anonKey']!,
    );
    runApp(homePage());
    print ('Supabase connected Successfully');
  }
  catch(e) {
    print ("Error : ${e.toString()}");
  }
  
}

