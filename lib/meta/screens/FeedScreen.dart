import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/meta/widgets/FeedScreenHelpers.dart';

class FeedScreen extends StatelessWidget {
  final GetStorage box = GetStorage();
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: constantColors.blueGreyColor,
          leading: IconButton(
            icon: Icon(
              EvaIcons.settings2Outline,
              color: constantColors.lightBlueColor,
              size: 30,
            ),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.camera_enhance_rounded,
                size: 30,
                color: constantColors.greenColor,
              ),
              onPressed: () {
                Provider.of<FeedScreenHelpers>(context, listen: false)
                    .selectPostImageType(context);
              },
            )
          ],
          title: RichText(
              text: TextSpan(
                  text: 'Social',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: constantColors.whiteColor,
                  ),
                  children: [
                TextSpan(
                    text: 'Feed',
                    style: TextStyle(
                        color: constantColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0))
              ])),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Provider.of<FeedScreenHelpers>(context).feedBody(context),
        ));
  }
}
