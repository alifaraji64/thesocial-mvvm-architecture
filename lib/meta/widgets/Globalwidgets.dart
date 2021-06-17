import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/core/ViewModels/FeedScreenViewModel.dart';
import 'package:thesocial/core/services/FirebaseOperations.dart';

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
        builder: (context, snapshot_v2) {
          if (snapshot_v2.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            //user is not followd
            //String snapShotType = snapshot.runtimeType.toString();
            if (!snapshot_v2.hasData || !snapshot_v2.data.exists)
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
                  // Provider.of<FirebaseOperations>(context, listen: false)
                  //     .followUser(
                  //   userUid,
                  //   Provider.of<Authentication>(context, listen: false)
                  //       .getUserUid,
                  //   {
                  //     //snapshot we are getting from the bottomsheets have the type of DocumentSnapshot but the one we are getting from the header is AsyncSnapshot so based on the type we are getting the data differently. in DocumentSnapshot we don't have a data property so we have to use snapshot.get('')
                  //     'username':
                  //         snapShotType == '_JsonQueryDocumentSnapshot' ||
                  //                 snapShotType == 'QueryDocumentSnapshot'
                  //             ? snapshot.get('username')
                  //             : snapshot.data.get('username'),
                  //     'useremail':
                  //         snapShotType == '_JsonQueryDocumentSnapshot' ||
                  //                 snapShotType == 'QueryDocumentSnapshot'
                  //             ? snapshot.get('useremail')
                  //             : snapshot.data.get('useremail'),
                  //     'userimage':
                  //         snapShotType == '_JsonQueryDocumentSnapshot' ||
                  //                 snapShotType == 'QueryDocumentSnapshot'
                  //             ? snapshot.get('userimage')
                  //             : snapshot.data.get('userimage'),
                  //     'useruid': snapShotType == '_JsonQueryDocumentSnapshot' ||
                  //             snapShotType == 'QueryDocumentSnapshot'
                  //         ? snapshot.get('useruid')
                  //         : snapshot.data.get('useruid'),
                  //     'time': Timestamp.now()
                  //   },
                  //   Provider.of<Authentication>(context, listen: false)
                  //       .getUserUid,
                  //   userUid,
                  //   {
                  //     'username': Provider.of<FirebaseOperations>(context,
                  //             listen: false)
                  //         .getUserName,
                  //     'useremail': Provider.of<FirebaseOperations>(context,
                  //             listen: false)
                  //         .getUserEmail,
                  //     'userimage': Provider.of<FirebaseOperations>(context,
                  //             listen: false)
                  //         .getUserImage,
                  //     'useruid':
                  //         Provider.of<Authentication>(context, listen: false)
                  //             .getUserUid,
                  //     'time': Timestamp.now()
                  //   },
                  // )

                  //     .whenComplete(() {
                  //   return ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       backgroundColor: constantColors.yellowColor,
                  //       duration: Duration(seconds: 1),
                  //       content: Text(
                  //         '${snapShotType == "_JsonQueryDocumentSnapshot" || snapShotType == "QueryDocumentSnapshot" ? snapshot.get("username") : snapshot.data.get("username")} has been followed',
                  //         style: TextStyle(
                  //           color: constantColors.darkColor,
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   );
                  // });
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
                onPressed: () {
                  // Provider.of<FirebaseOperations>(context, listen: false)
                  //     .unFollowUser(
                  //         Provider.of<Authentication>(context, listen: false)
                  //             .getUserUid,
                  //         userUid)
                  //     .whenComplete(() {
                  //   return ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       backgroundColor: constantColors.redColor,
                  //       duration: Duration(seconds: 1),
                  //       content: Text(
                  //         '${snapShotType == "_JsonQueryDocumentSnapshot" || snapShotType == "QueryDocumentSnapshot" ? snapshot.get("username") : snapshot.data.get("username")} has been Unfollowed',
                  //         style: TextStyle(
                  //           color: constantColors.whiteColor,
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   );
                  // });
                },
              );
          }
        });
  }
}
