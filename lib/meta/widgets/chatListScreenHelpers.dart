import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/core/ViewModels/ChatListScreenViewModel.dart';
import 'package:thesocial/core/ViewModels/FeedScreenViewModel.dart';
import 'package:thesocial/core/ViewModels/GlobalViewModel.dart';

class ChatListScreenHelpers extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget chatListItems(BuildContext context) {
    return ListView(
      children: [
        StreamBuilder(
            stream: Provider.of<ChatListScreenViewModel>(context, listen: false)
                .getChatList(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                    children: snapshot.data.docs
                        .map<Widget>((DocumentSnapshot documentSnapshot) {
                  return GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          color: constantColors.blueGreyColor,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: ListTile(
                        title: Text(
                          documentSnapshot.get('username'),
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold),
                        ),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(documentSnapshot.get('userimage')),
                          radius: 25,
                          backgroundColor: constantColors.redColor,
                        ),
                        trailing: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.trash,
                              color: constantColors.redColor,
                            ),
                            onPressed: () {
                              Provider.of<ChatListScreenViewModel>(context,
                                      listen: false)
                                  .deleteChatList(context, documentSnapshot.id,
                                      documentSnapshot.get('userid'));
                              // Provider.of<FirebaseOperations>(context,
                              //         listen: false)
                              //     .deleteChatList(
                              //         documentSnapshot.get('chatdocuid'),
                              //         Provider.of<Authentication>(context,
                              //                 listen: false)
                              //             .getUserUid,
                              //         documentSnapshot.get('userid'))
                              //     .whenComplete(() {
                              //   print('chat list deleted');
                              // });
                            }),
                      ),
                    ),
                    onTap: () {
                      Provider.of<GlobalViewModel>(context, listen: false)
                          .redirect(
                        context,
                        '/chatScreen',
                        uid: documentSnapshot.get('userid'),
                        username: documentSnapshot.get('username'),
                        profileImage: documentSnapshot.get('userimage'),
                        myUid: Provider.of<FeedScreenViewModel>(context,
                                listen: false)
                            .getUserUid,
                      );
                    },
                  );
                }).toList());
              }
            })
      ],
    );
  }
}
