import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notepad/home_screen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
  // TODO: implement initState
  super.initState();
  Timer(const Duration(seconds: 3), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()))  );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text('NotePad App', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}
