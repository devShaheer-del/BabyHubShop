import 'dart:async';

import 'package:babyshop_hub/screens/login.dart';
// import 'package:babyshop_hub/screens/login.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 4), (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('../../assets/images/splash.png',height: 300,),

            Container(
              width: 300,
              alignment: Alignment.center,
              child: Text("Baby Shop Hub",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
            )

          ],
        ),
      ),
    );
  }
}
