import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/core/ViewModels/FeedScreenViewModel.dart';
import 'package:thesocial/core/ViewModels/GlobalViewModel.dart';

class GlobalWidgets extends ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();
  Widget profileDetailBox(String title, String value) {
    return Container(
      height: 70,
      width: 80,
      decoration: BoxDecoration(
          color: constantColors.darkColor,
          borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$title',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget postGrid(BuildContext context, String userUid) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('useruid', isEqualTo: userUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Container(
                    width: 180,
                    height: 200,
                    child: Image.network(
                      snapshot.data.docs[index].get('postimage'),
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
              itemCount: snapshot.data.docs.length,
            );
          }
        },
      ),
      decoration:
          BoxDecoration(color: constantColors.darkColor.withOpacity(0.4)),
    );
  }

  Widget conditionalFollowButtons(
      BuildContext context, dynamic snapshot, String userUid) {
    return StreamBuilder(
        stream: Provider.of<FeedScreenViewModel>(context, listen: false)
            .followingStatus(context, userUid),
        builder: (context, snapshotV2) {
          if (snapshotV2.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            //user is not followd
            //String snapShotType = snapshot.runtimeType.toString();
            if (!snapshotV2.hasData || !snapshotV2.data.exists)
              return MaterialButton(
                color: constantColors.blueColor,
                child: Text(
                  'Follow',
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                onPressed: () async {
                  await Provider.of<FeedScreenViewModel>(context, listen: false)
                      .followUser(context, snapshot, userUid);
                },
              );

            //user is followed
            else
              return MaterialButton(
                child: Text('unfollow',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    )),
                color: constantColors.redColor,
                onPressed: () async {
                  await Provider.of<FeedScreenViewModel>(context, listen: false)
                      .unfollowUser(userUid, context, snapshot);
                },
              );
          }
        });
  }

  Future showFollowingsSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              color: constantColors.blueGreyColor,
              child: SingleChildScrollView(
                child: Column(
                    children: snapshot.data.docs
                        .map<Widget>((DocumentSnapshot documentSnapshot) {
                  return ListTile(
                    leading: GestureDetector(
                      child: CircleAvatar(
                        backgroundColor: constantColors.darkColor,
                        backgroundImage:
                            NetworkImage(documentSnapshot.get('userimage')),
                      ),
                      onTap: () {
                        Provider.of<GlobalViewModel>(
                          context,
                          listen: false,
                        ).redirect(
                          context,
                          '/altProfile',
                          uid: documentSnapshot.get('useruid'),
                        );
                      },
                    ),
                    title: Text(
                      '${documentSnapshot.get("username")}',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${documentSnapshot.get("useremail")}',
                      style: TextStyle(
                        color: constantColors.yellowColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Container(
                        width: 100,
                        //not showing the follow button for the user itself
                        child: documentSnapshot.get('useruid') !=
                                Provider.of<FeedScreenViewModel>(context,
                                        listen: false)
                                    .getUserUid
                            ? Provider.of<GlobalWidgets>(context, listen: false)
                                .conditionalFollowButtons(
                                context,
                                documentSnapshot,
                                documentSnapshot.get('useruid'),
                              )
                            : Container(
                                width: 0,
                                height: 0,
                              )),
                  );
                }).toList()),
              ));
        });
  }
}
