import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sailor/sailor.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/core/ViewModels/GlobalViewModel.dart';
import 'package:thesocial/meta/widgets/ChatScreenHelpers.dart';

class ChatScreen extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    final String profileImage = Sailor.param<String>(context, 'profileImage');
    final String myUid = Sailor.param<String>(context, 'myUid');
    final String userUid = Sailor.param<String>(context, 'userUid');
    final String username = Sailor.param<String>(context, 'username');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: constantColors.blueGreyColor,
          title: Row(
            children: [
              GestureDetector(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(profileImage),
                  radius: 20,
                ),
                onTap: () {
                  Provider.of<GlobalViewModel>(context, listen: false)
                      .redirect(context, '/altProfile', uid: userUid);
                },
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '$username',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        body: Provider.of<ChatScreenHelpers>(context, listen: false)
            .chatBody(context, profileImage, username, userUid, myUid));
  }
}
