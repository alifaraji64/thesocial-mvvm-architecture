import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/core/ViewModels/FeedScreenViewModel.dart';
import 'package:thesocial/meta/widgets/Globalwidgets.dart';
import 'package:thesocial/meta/widgets/ProfileScreenHelpers.dart';

class ProfileScreen extends StatelessWidget {
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
                Provider.of<ProfileScreenHelpers>(context, listen: false)
                    .logoutDialog(context);
              },
            )
          ],
          title: RichText(
              text: TextSpan(
                  text: 'My',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: constantColors.whiteColor,
                  ),
                  children: [
                TextSpan(
                    text: 'Profile',
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
              height: MediaQuery.of(context).size.height * 1.3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: constantColors.blueGreyColor.withOpacity(0.6)),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(
                        Provider.of<FeedScreenViewModel>(context, listen: false)
                            .getUserUid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Column(
                      children: [
                        Provider.of<ProfileScreenHelpers>(context,
                                listen: false)
                            .headerProfile(context, snapshot),
                        Provider.of<ProfileScreenHelpers>(context,
                                listen: false)
                            .divider(context),
                        SizedBox(height: 10),
                        Provider.of<GlobalWidgets>(context, listen: false)
                            .postGrid(
                                context,
                                Provider.of<FeedScreenViewModel>(context,
                                        listen: false)
                                    .getUserUid)
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }
}
