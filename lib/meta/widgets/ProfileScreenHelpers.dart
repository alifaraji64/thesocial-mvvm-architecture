import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/core/ViewModels/ProfileScreenViewModel.dart';
import 'package:thesocial/meta/widgets/Globalwidgets.dart';

class ProfileScreenHelpers extends ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();
  Widget headerProfile(BuildContext context, dynamic snapshot) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.28,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 200,
            width: 180,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: constantColors.transperant,
                    radius: 60,
                    backgroundImage:
                        NetworkImage(snapshot.data.get('userimage')),
                  ),
                  onTap: () {},
                ),
                SizedBox(height: 5),
                Text(
                  snapshot.data.get('username'),
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      EvaIcons.email,
                      color: constantColors.greenColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      snapshot.data.get('useremail'),
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    //getting the number of followers
                    StreamBuilder<QuerySnapshot>(
                        stream: Provider.of<ProfileScreenViewModel>(context,
                                listen: true)
                            .getFollowers(context),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return GestureDetector(
                              child: Provider.of<GlobalWidgets>(context,
                                      listen: false)
                                  .profileDetailBox('Followers',
                                      snapshot.data.docs.length.toString()),
                              onTap: () {
                                // Provider.of<GlobalWidgets>(context,
                                //         listen: false)
                                //     .showFollowingsSheet(context, snapshot);
                              },
                            );
                          }
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    //getting the number of followings
                    // StreamBuilder<QuerySnapshot>(
                    //     stream: FirebaseFirestore.instance
                    //         .collection('users')
                    //         .doc(Provider.of<Authentication>(context,
                    //                 listen: false)
                    //             .getUserUid)
                    //         .collection('followings')
                    //         .snapshots(),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.connectionState ==
                    //           ConnectionState.waiting) {
                    //         return Center(
                    //           child: CircularProgressIndicator(),
                    //         );
                    //       } else {
                    //         return GestureDetector(
                    //           child: profileDetailBox('Followings',
                    //               snapshot.data.docs.length.toString()),
                    //           onTap: () {
                    //             Provider.of<GlobalWidgets>(context,
                    //                     listen: false)
                    //                 .showFollowingsSheet(context, snapshot);
                    //           },
                    //         );
                    //       }
                    //     }),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                      //children: [profileDetailBox('Posts', '0')],
                      ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
