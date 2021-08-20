import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_movie_list/Screens/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_movie_list/Screens/sign_in.dart';

Future main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        focusColor: Colors.lightBlue,
        textTheme: GoogleFonts.nunitoSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
        home: SignIn(),
    );
  }
}
