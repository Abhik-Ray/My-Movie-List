import 'dart:io';
import 'package:my_movie_list/Screens/homepage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  delay() async{
    sleep(const Duration(seconds: 5));
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Homepage(),
      ),
    );
  }

  @override
  void initState() {
    delay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Image.asset('assets/images/logo.png')
      ),
    );
  }
}
