import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sailor/sailor.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/app/routes.dart';
import 'package:thesocial/meta/screens/LandingPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Routes.sailor.navigate(
        "/LandingPage",
        transitions: [SailorTransition.slide_from_left],
        transitionDuration: Duration(milliseconds: 600),
        transitionCurve: Curves.easeOut,
      );
    });
    // () => Navigator.pushReplacement(
    //   context,
    //   PageTransition(
    //     child: LandingPage(),
    //     type: PageTransitionType.leftToRight,
    //     duration: Duration(milliseconds: 500),
    //   ),
    // ),
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: Center(
        child: RichText(
          text: TextSpan(
              text: 'the',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: constantColors.whiteColor,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                    text: 'Social',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: constantColors.blueColor,
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                    ))
              ]),
        ),
      ),
    );
  }
}
