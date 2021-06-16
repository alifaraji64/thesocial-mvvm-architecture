import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/meta/widgets/LandingPageHelpers.dart';

class LandingPage extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteColor,
      body: Stack(
        children: [
          bodyColor(),
          Provider.of<LandingPageHelpers>(context, listen: false)
              .bodyImage(context),
          Provider.of<LandingPageHelpers>(context, listen: false).taglineText(),
          Provider.of<LandingPageHelpers>(context, listen: false)
              .mainButton(context),
          Provider.of<LandingPageHelpers>(context, listen: false)
              .privacyText(context)
        ],
      ),
    );
  }

  Widget bodyColor() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [
            0.5,
            0.9
          ],
              colors: [
            constantColors.darkColor,
            constantColors.blueGreyColor
          ])),
    );
  }
}
