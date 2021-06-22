import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/meta/widgets/chatListScreenHelpers.dart';

class ChatListScreen extends StatelessWidget {
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
                EvaIcons.logOutOutline,
                size: 30,
                color: constantColors.greenColor,
              ),
              onPressed: () {
                // Provider.of<ProfileHelpers>(context, listen: false)
                //     .logoutDialog(context);
              },
            )
          ],
          title: RichText(
              text: TextSpan(
                  text: 'Chat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: constantColors.whiteColor,
                  ),
                  children: [
                TextSpan(
                    text: 'List',
                    style: TextStyle(
                        color: constantColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0))
              ])),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                padding: EdgeInsets.all(4),
                height: MediaQuery.of(context).size.height * 1.3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: constantColors.blueGreyColor.withOpacity(0.6)),
                child:
                    Provider.of<ChatListScreenHelpers>(context, listen: false)
                        .chatListItems(context)),
          ),
        ));
  }
}
