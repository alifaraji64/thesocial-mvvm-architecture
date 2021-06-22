import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/core/services/FirebaseOperations.dart';
import 'package:thesocial/core/services/UploadImage.dart';
import 'package:thesocial/meta/widgets/FeedPostSheets.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedScreenViewModel extends ChangeNotifier {
  FirebaseOperations firebaseOperations = FirebaseOperations();
  File postImage;
  File get getPostImage => postImage;
  File avatarImage;
  File get getAvatarImage => avatarImage;
  String avatarUrl;
  String get getAvatarUrl => avatarUrl;
  String postImageUrl;
  String get getPostImageUrl => postImageUrl;
  String useruid;
  String get getUserUid => useruid;
  String username;
  String get getUserName => username;
  String useremail;
  String get getUserEmail => useremail;
  String userimage;
  String get getUserImage => userimage;
  String imageTimePosted;
  String get getImageTimePosted => imageTimePosted;

  Stream getLikesForPost(BuildContext context, String caption) {
    return firebaseOperations.getLikesForPost(context, caption);
  }

  Stream followingStatus(BuildContext context, String useruid) {
    return firebaseOperations.followingStatus(context, useruid);
  }

  Stream getRewardLengthForPost(String caption) {
    return firebaseOperations.getRewardLengthForPost(caption);
  }

  Stream getComments(String caption) {
    return firebaseOperations.getComments(caption);
  }

  Future pickPostImage(BuildContext context, ImageSource source) async {
    Provider.of<UploadImage>(context, listen: false).postImage = null;
    Provider.of<UploadImage>(context, listen: false).avatarImage = null;
    await Provider.of<UploadImage>(context, listen: false)
        .pickPostImage(context, source);
  }

  Future pickUserAvatar(BuildContext context, ImageSource source) async {
    Provider.of<UploadImage>(context, listen: false).avatarImage = null;
    Provider.of<UploadImage>(context, listen: false).postImage = null;
    await Provider.of<UploadImage>(context, listen: false)
        .pickAvatarImage(context, source);
    notifyListeners();
  }

  Future uploadImageToFirebase(BuildContext context, String useCase) async {
    await Provider.of<FirebaseOperations>(context, listen: false)
        .uploadPostImageToFirebase(context, useCase);
  }

  String captionValidator(value) {
    if (value.isEmpty) {
      return 'please fill the caption';
    } else if (value.toString().length < 3) {
      return 'make sure your caption is long enough';
    }
    return null;
  }

  Future addPostData(BuildContext context, dynamic postData) async {
    await Provider.of<FirebaseOperations>(context, listen: false)
        .addPostData(context, postData);
  }

  void showTimeGo(dynamic timedata) {
    Timestamp time = timedata;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);
    print(imageTimePosted);
    //notifyListeners();
  }

  Future addLike(
      BuildContext context, DocumentSnapshot documentSnapshot) async {
    await firebaseOperations.addLike(context, documentSnapshot.get('caption'));
    Provider.of<FeedPostSheets>(context, listen: false)
        .likeSheet(context, documentSnapshot);
  }

  Future addComment(BuildContext context, String caption, String comment,
      TextEditingController _commentController) async {
    await firebaseOperations.addComment(
        context,
        caption,
        comment,
        this.getUserUid,
        this.username,
        this.userimage,
        this.useremail,
        _commentController);
  }

  Future addReward(
      BuildContext context, String rewardUrl, String postId) async {
    await firebaseOperations.addReward(
      context,
      rewardUrl,
      postId,
      this.getUserUid,
    );
  }

  Future followUser(
    BuildContext context,
    dynamic snapshot,
    String followingUid,
  ) async {
    await firebaseOperations.followUser(context, snapshot, followingUid);
  }

  Future unfollowUser(
      String beingUnfollowed, BuildContext context, dynamic snapshot) async {
    await firebaseOperations.unfollowUser(
        context, snapshot, this.getUserUid, beingUnfollowed);
  }

  bool postUidAndUserUidEquality(postUid) {
    if (postUid == this.getUserUid) return true;
    return false;
  }

  Future deletePost(BuildContext context, String caption) async {
    await firebaseOperations.deletePost(context, caption);
  }
}
