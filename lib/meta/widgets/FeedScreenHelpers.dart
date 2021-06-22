import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/core/ViewModels/FeedScreenViewModel.dart';
import 'package:thesocial/core/ViewModels/GlobalViewModel.dart';
import 'package:thesocial/meta/widgets/FeedPostSheets.dart';

class FeedScreenHelpers extends ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();

  Future selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 140),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Camera',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        await Provider.of<FeedScreenViewModel>(context,
                                listen: false)
                            .pickPostImage(context, ImageSource.camera);
                      },
                    ),
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        await Provider.of<FeedScreenViewModel>(context,
                                listen: false)
                            .pickPostImage(context, ImageSource.gallery);
                        showPostImage(context);
                      },
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 100),
        child: Container(
          padding: const EdgeInsets.only(
            top: 8.0,
            left: 8.0,
            right: 8.0,
            bottom: 60,
          ),
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              )),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: SizedBox(
                  height: 500,
                  width: 400,
                  child: Lottie.asset('assets/animations/loading.json'),
                ));
              } else {
                return ListView(
                  children: snapshot.data.docs
                      .map<Widget>((DocumentSnapshot documentSnapshot) {
                    Provider.of<FeedScreenViewModel>(context, listen: false)
                        .showTimeGo(documentSnapshot.get('time'));
                    return Container(
                      margin: EdgeInsets.only(bottom: 40),
                      //  height: MediaQuery.of(context).size.height * 0.69,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    documentSnapshot.get('userimage'),
                                  ),
                                  radius: 20.0,
                                ),
                                onTap: () {
                                  Provider.of<GlobalViewModel>(
                                    context,
                                    listen: false,
                                  ).redirect(context, '/altProfile',
                                      uid: documentSnapshot.get('useruid'));
                                },
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          3 /
                                          4,
                                      child: Text(
                                        documentSnapshot.get('caption'),
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          documentSnapshot.get('username') +
                                              ' , ',
                                          style: TextStyle(
                                              color: constantColors.blueColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${Provider.of<FeedScreenViewModel>(context, listen: false).getImageTimePosted.toString()}',
                                          style: TextStyle(
                                            color: constantColors.lightColor
                                                .withOpacity(0.99),
                                            fontSize: 12,
                                          ),
                                        ),
                                        //Spacer(),
                                        SizedBox(width: 80),
                                        Container(
                                            height: 30,
                                            width: 60,
                                            //displaying the rewards
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('posts')
                                                  .doc(documentSnapshot
                                                      .get('caption'))
                                                  .collection('rewards')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else {
                                                  return ListView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      children: snapshot
                                                          .data.docs
                                                          .map<Widget>(
                                                              (DocumentSnapshot
                                                                  documentSnapshot) {
                                                        return Container(
                                                          height: 30,
                                                          width: 40,
                                                          child: Image.network(
                                                            documentSnapshot
                                                                .get('image'),
                                                          ),
                                                        );
                                                      }).toList());
                                                }
                                              },
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          //displaying the post image
                          Container(
                            height: MediaQuery.of(context).size.height * 0.46,
                            width: MediaQuery.of(context).size.width,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Image.network(
                                documentSnapshot.get('postimage'),
                                scale: 2,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          //row of button for like,comment,reward
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    child: Icon(
                                      FontAwesomeIcons.heart,
                                      color: constantColors.redColor,
                                    ),
                                    onTap: () async {
                                      await Provider.of<FeedScreenViewModel>(
                                              context,
                                              listen: false)
                                          .addLike(context, documentSnapshot);
                                    },
                                  ),
                                  SizedBox(width: 7),
                                  //number of likes
                                  StreamBuilder<QuerySnapshot>(
                                      stream: Provider.of<FeedScreenViewModel>(
                                              context,
                                              listen: true)
                                          .getLikesForPost(context,
                                              documentSnapshot.get('caption')),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return Text(
                                            snapshot.data.docs.length
                                                .toString(),
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                            ),
                                          );
                                        }
                                      }),
                                ],
                              ),
                              SizedBox(width: 15),
                              Row(
                                children: [
                                  GestureDetector(
                                    child: Icon(
                                      FontAwesomeIcons.comment,
                                      color: constantColors.blueColor,
                                    ),
                                    onTap: () {
                                      Provider.of<FeedPostSheets>(context,
                                              listen: false)
                                          .commentSheet(
                                              context,
                                              documentSnapshot,
                                              documentSnapshot.get('caption'));
                                    },
                                  ),
                                  SizedBox(width: 7),
                                  //number of comments
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(documentSnapshot.get('caption'))
                                          .collection('comments')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return Text(
                                            snapshot.data.docs.length
                                                .toString(),
                                            style: TextStyle(
                                                color:
                                                    constantColors.whiteColor),
                                          );
                                        }
                                      }),
                                ],
                              ),
                              SizedBox(width: 15),
                              Row(
                                children: [
                                  GestureDetector(
                                    child: Icon(
                                      FontAwesomeIcons.award,
                                      color: constantColors.yellowColor,
                                    ),
                                    onTap: () {
                                      Provider.of<FeedPostSheets>(context,
                                              listen: false)
                                          .rewardSheet(context,
                                              documentSnapshot.get('caption'));
                                    },
                                  ),
                                  SizedBox(width: 7),
                                  StreamBuilder(
                                      stream: Provider.of<FeedScreenViewModel>(
                                              context,
                                              listen: false)
                                          .getRewardLengthForPost(
                                        documentSnapshot.get('caption'),
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return Text(
                                            snapshot.data.docs.length
                                                .toString(),
                                            style: TextStyle(
                                                color:
                                                    constantColors.whiteColor),
                                          );
                                        }
                                      }),
                                ],
                              ),
                              Spacer(),
                              //conditional tree dots
                              //check if the uid of the post is the same as logged-in uid
                              Provider.of<FeedScreenViewModel>(context,
                                          listen: false)
                                      .postUidAndUserUidEquality(
                                          documentSnapshot.get('useruid'))
                                  ? IconButton(
                                      icon: Icon(
                                        EvaIcons.moreVertical,
                                        color: constantColors.whiteColor,
                                      ),
                                      onPressed: () {
                                        showPostOptions(
                                          context,
                                          documentSnapshot.get('caption'),
                                        );
                                      })
                                  : Container(
                                      height: 0,
                                      width: 0,
                                    )
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future showPostImage(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              color: constantColors.blueGreyColor,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 140),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                      height: 250.0,
                      width: 350.0,
                      child: Provider.of<FeedScreenViewModel>(context,
                                      listen: true)
                                  .getPostImage !=
                              null
                          ? Image.file(
                              Provider.of<FeedScreenViewModel>(
                                context,
                                listen: true,
                              ).getPostImage,
                              fit: BoxFit.contain,
                            )
                          : null),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: [
                        MaterialButton(
                          child: Text(
                            'Reselect',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Provider.of<FeedScreenHelpers>(context,
                                    listen: false)
                                .selectPostImageType(context);
                          },
                        ),
                        MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            'Confirm Image',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            await Provider.of<FeedScreenViewModel>(context,
                                    listen: false)
                                .uploadImageToFirebase(context, 'post');
                            editPostSheet(context);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ));
        });
  }

  Future editPostSheet(BuildContext context) {
    TextEditingController _captionController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                )),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 140),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.image_aspect_ratio,
                              color: constantColors.greenColor,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.fit_screen,
                              color: constantColors.yellowColor,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Container(
                        height: 200,
                        width: 300,
                        child: Image.file(Provider.of<FeedScreenViewModel>(
                                context,
                                listen: false)
                            .getPostImage),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset('assets/icons/sunflower.png'),
                      ),
                      Container(
                        width: 5,
                        height: 110,
                        color: constantColors.blueColor,
                      ),
                      Container(
                        height: 120,
                        width: 330,
                        child: Form(
                          key: formKey,
                          child: TextFormField(
                            validator: Provider.of<FeedScreenViewModel>(context,
                                    listen: false)
                                .captionValidator,
                            maxLines: 5,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            controller: _captionController,
                            decoration: InputDecoration(
                              hintText: 'Add Caption',
                              hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: TextStyle(color: constantColors.whiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                    color: constantColors.blueColor,
                    child: Text(
                      'Share',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () {
                      if (!formKey.currentState.validate()) {
                        return;
                      }
                      Provider.of<FeedScreenViewModel>(context, listen: false)
                          .addPostData(
                        context,
                        {
                          'caption': _captionController.text,
                          'username': Provider.of<FeedScreenViewModel>(context,
                                  listen: false)
                              .getUserName,
                          'useruid': Provider.of<FeedScreenViewModel>(context,
                                  listen: false)
                              .getUserUid,
                          'userimage': Provider.of<FeedScreenViewModel>(context,
                                  listen: false)
                              .getUserImage,
                          'postimage': Provider.of<FeedScreenViewModel>(context,
                                  listen: false)
                              .getPostImageUrl
                        },
                      );
                    })
              ],
            ),
          );
        });
  }

  Future showPostOptions(BuildContext context, String caption) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              'you want to delete this post?',
              style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  MaterialButton(
                      child: Text('No',
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  MaterialButton(
                      color: constantColors.redColor,
                      child: Text('Yes',
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                      onPressed: () {
                        Provider.of<FeedScreenViewModel>(context, listen: false)
                            .deletePost(context, caption);
                      }),
                ],
              )
            ],
          );
        });
  }
}
