import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber_driver/mainScreens/Login_Screen.dart';
import 'package:uber_driver/mainScreens/Main_Screen.dart';
import 'package:uber_driver/core/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  timer() {
    Timer(const Duration(seconds: 3), () async {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    timer();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/logo.png', width: 200,),
            const SizedBox(height: 40,),
            const CircularProgressIndicator(color: Colors.white,)
          ],
        ),
      ),
    );
  }
}