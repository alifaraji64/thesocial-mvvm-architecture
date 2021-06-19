import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/core/ViewModels/FeedScreenViewModel.dart';
import 'package:thesocial/core/ViewModels/GlobalViewModel.dart';
import 'package:thesocial/meta/widgets/Globalwidgets.dart';

class FeedPostSheets extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Future commentSheet(
      BuildContext context, DocumentSnapshot snapshoto, String docId) {
    TextEditingController _commentController = TextEditingController();
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 140),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream:
                        Provider.of<FeedScreenViewModel>(context, listen: false)
                            .getComments(docId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return SingleChildScrollView(
                            //shrinkWrap: true,
                            child: Padding(
                          padding: const EdgeInsets.only(bottom: 100.0),
                          child: Column(
                            children: snapshot.data.docs.map<Widget>(
                                (DocumentSnapshot documentSnapshot) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 10),
                                        GestureDetector(
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              documentSnapshot.get('userimage'),
                                            ),
                                            radius: 15,
                                          ),
                                          onTap: () {
                                            Provider.of<GlobalViewModel>(
                                              context,
                                              listen: false,
                                            ).redirect(
                                              context,
                                              '/altProfile',
                                              uid: documentSnapshot
                                                  .get('useruid'),
                                            );
                                          },
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          documentSnapshot.get('username'),
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            FontAwesomeIcons.reply,
                                            color: constantColors.yellowColor,
                                            size: 16,
                                          ),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            FontAwesomeIcons.trash,
                                            color: constantColors.redColor,
                                            size: 16,
                                          ),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                    Row(children: [
                                      Icon(
                                        Icons.keyboard_arrow_right,
                                        color: constantColors.blueColor,
                                      ),
                                      Text(documentSnapshot.get('comment'),
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                          ))
                                    ]),
                                    SizedBox(height: 10)
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ));
                      }
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    color: constantColors.darkColor,
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
                                      color: constantColors.greenColor,
                                      width: 1.0),
                                ),
                                hintText: 'Add Comment...',
                                hintStyle: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                            controller: _commentController,
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        FloatingActionButton(
                            backgroundColor: constantColors.greenColor,
                            child: Icon(FontAwesomeIcons.comment,
                                color: constantColors.whiteColor),
                            onPressed: () async {
                              await Provider.of<FeedScreenViewModel>(context,
                                      listen: false)
                                  .addComment(
                                      context,
                                      snapshoto.get('caption'),
                                      _commentController.text,
                                      _commentController);
                            })
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Future likeSheet(BuildContext context, DocumentSnapshot snapshot) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 140),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream:
                        Provider.of<FeedScreenViewModel>(context, listen: false)
                            .getLikesForPost(context, snapshot.get('caption')),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return SingleChildScrollView(
                            //shrinkWrap: true,
                            child: Column(
                          children: snapshot.data.docs
                              .map<Widget>((DocumentSnapshot documentSnapshot) {
                            return Center(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width * 0.95,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 5),
                                        GestureDetector(
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              documentSnapshot.get('userimage'),
                                            ),
                                            radius: 20,
                                          ),
                                          onTap: () {
                                            //redirect to alt profile
                                            Provider.of<GlobalViewModel>(
                                              context,
                                              listen: false,
                                            ).redirect(
                                              context,
                                              '/altProfile',
                                              uid: documentSnapshot
                                                  .get('useruid'),
                                            );
                                          },
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          children: [
                                            Text(
                                              documentSnapshot.get('username'),
                                              style: TextStyle(
                                                color: constantColors.blueColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              documentSnapshot.get('useremail'),
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        //conditional follow button
                                        documentSnapshot.get('useruid') !=
                                                Provider.of<
                                                    FeedScreenViewModel>(
                                                  context,
                                                  listen: false,
                                                ).getUserUid
                                            ? Provider.of<GlobalWidgets>(
                                                    context,
                                                    listen: false)
                                                .conditionalFollowButtons(
                                                context,
                                                documentSnapshot,
                                                documentSnapshot.get('useruid'),
                                              )
                                            : Container(
                                                width: 0,
                                                height: 0,
                                              )
                                      ],
                                    ),
                                    SizedBox(height: 10)
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ));
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future rewardSheet(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 140),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                //all addable rewards
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('rewards')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.docs
                              .map<Widget>((DocumentSnapshot documentSnapshot) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: GestureDetector(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Image.network(
                                      documentSnapshot.get('image')),
                                ),
                                onTap: () {
                                  print('adding the reward');
                                  Provider.of<FeedScreenViewModel>(context,
                                          listen: false)
                                      .addReward(
                                          context,
                                          documentSnapshot.get('image'),
                                          postId);
                                },
                              ),
                            );
                          }).toList(),
                        );
                      }
                    }),
              ],
            ),
          );
        });
  }
}
