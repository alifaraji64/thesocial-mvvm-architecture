import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/core/ViewModels/ChatScreenViewModel.dart';

class ChatScreenHelpers extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget chatBody(BuildContext context, String profileImage, String username,
      String userUid, String myUid) {
    TextEditingController _chatController = TextEditingController();
    String chatDocUid;
    if (userUid.compareTo(myUid) == 1) {
      chatDocUid = userUid + myUid;
    } else if (userUid.compareTo(myUid) == -1) {
      chatDocUid = myUid + userUid;
    }
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 4 / 5,
        width: MediaQuery.of(context).size.width,
        color: constantColors.darkColor,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 75.0, left: 8, right: 8),
                child: StreamBuilder<QuerySnapshot>(
                    stream:
                        Provider.of<ChatScreenViewModel>(context, listen: false)
                            .getChatMessages(chatDocUid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Column(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return Row(
                              mainAxisAlignment:
                                  documentSnapshot.get('from') == userUid
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end,
                              children: [
                                documentSnapshot.get('from') == userUid
                                    ? Container(
                                        width: 0,
                                        height: 0,
                                      )
                                    : IconButton(
                                        icon: Icon(
                                          FontAwesomeIcons.trash,
                                          color: constantColors.redColor,
                                        ),
                                        onPressed: () async {
                                          await Provider.of<
                                                      ChatScreenViewModel>(
                                                  context,
                                                  listen: false)
                                              .deleteChatMessage(chatDocUid,
                                                  documentSnapshot.id);
                                        },
                                      ),
                                Container(
                                    //padding: EdgeInsets.all(15),
                                    width: 200,
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: documentSnapshot.get('from') ==
                                              userUid
                                          ? constantColors.blueGreyColor
                                          : constantColors.blueColor
                                              .withAlpha(100),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10),
                                          child: Text(
                                            documentSnapshot.get('message'),
                                            //documentSnapshot.id,
                                            overflow: TextOverflow.visible,
                                            softWrap: true,
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 3,
                                          child: Text(
                                            DateFormat('kk:mm:a').format(
                                                documentSnapshot
                                                    .get('time')
                                                    .toDate()),
                                            style: TextStyle(
                                              color: constantColors.yellowColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            );
                          }).toList(),
                        );
                      }
                    }),
              ),
            ),
            Positioned(
              bottom: -1,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                color: constantColors.blueGreyColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 45.0,
                      width: 300.0,
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      constantColors.blueColor.withAlpha(100),
                                  width: 1.0),
                            ),
                            hintText: 'type message...',
                            hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        controller: _chatController,
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    FloatingActionButton(
                        backgroundColor:
                            constantColors.blueColor.withAlpha(100),
                        child: Icon(FontAwesomeIcons.comment,
                            color: constantColors.whiteColor),
                        onPressed: () async {
                          print('chat pressed');
                          await Provider.of<ChatScreenViewModel>(context,
                                  listen: false)
                              .addChat(
                            context,
                            profileImage,
                            username,
                            userUid,
                            myUid,
                            _chatController,
                            chatDocUid,
                          );
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
