import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'Homepage.dart';
import 'Homepage_.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var email;
  bool here = false;

  @override

  void initState() {
    super.initState();
    startTimer();}

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      navigateUser(); //It will redirect  after 3 seconds
    });
  }
  void navigateUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn');
    print(status);
    if (status == true) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Homepage()));
    } else {
    Navigator.pushReplacement(context,  MaterialPageRoute(builder: (BuildContext context) => Auth()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
          duration: 2000,
          splash: Image.asset("asset/logo.png",width: 1000,height: 1000,),
          nextScreen: Auth(),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.topToBottom,
          backgroundColor: Colors.lightGreenAccent)
    );
  }
  Future<bool> authentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('store');
    here = email == null ? true : false;
    return here;
  }
}
