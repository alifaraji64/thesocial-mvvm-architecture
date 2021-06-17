import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sailor/sailor.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/app/routes.dart';
import 'package:thesocial/core/ViewModels/FeedScreenViewModel.dart';
import 'package:thesocial/core/models/Comment.dart';
import 'package:thesocial/core/models/Like.dart';
import 'package:thesocial/core/models/Post.dart';
import 'package:thesocial/core/models/User.dart';

class FirebaseOperations extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  String errorMsg;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  Stream getUsers() {
    return instance.collection('users').snapshots();
  }

  Stream getFollowers(BuildContext context) {
    return instance
        .collection('users')
        .doc(
            Provider.of<FeedScreenViewModel>(context, listen: false).getUserUid)
        .collection('followers')
        .snapshots();
  }

  Stream getFollowings(BuildContext context) {
    return instance
        .collection('users')
        .doc(
            Provider.of<FeedScreenViewModel>(context, listen: false).getUserUid)
        .collection('followings')
        .snapshots();
  }

  Stream getLikesForPost(BuildContext context, String caption) {
    print(caption);
    return instance
        .collection('posts')
        .doc(caption)
        .collection('likes')
        .snapshots();
  }

  Stream followingStatus(BuildContext context, String userUid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('followers')
        .doc(
            Provider.of<FeedScreenViewModel>(context, listen: false).getUserUid)
        .snapshots();
  }

  Stream getRewardLengthForPost(String caption) {
    return instance
        .collection('posts')
        .doc(caption)
        .collection('rewards')
        .snapshots();
  }

  Future logIntoAccount(
      BuildContext context, String email, String password) async {
    errorMsg = null;
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User user = userCredential.user;

      Provider.of<FeedScreenViewModel>(context, listen: false).useruid =
          user.uid;
      notifyListeners();
      await fetchUserProfileInfo(context);
      Routes.sailor.navigate(
        "/HomePage",
        transitions: [SailorTransition.slide_from_left],
        transitionDuration: Duration(milliseconds: 600),
        transitionCurve: Curves.easeOut,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case 'user-not-found':
          errorMsg = 'this email is not registered';
          break;
        case 'invalid-email':
          errorMsg = 'this email is invalid';
          break;
        case 'wrong-password':
          errorMsg = 'password is wrong';
          break;
        default:
          errorMsg = 'some unknown error occured';
      }

      Get.snackbar(
        'error while logging in',
        '$errorMsg',
        titleText: Text(
          'error while logging in',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        messageText: Text(
          '$errorMsg',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        barBlur: 0,
        duration: Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
        overlayBlur: 0,
        backgroundColor: constantColors.yellowColor,
      );
      return false;
    } catch (e) {
      errorMsg = 'some unknown error occured';
      return false;
    }
  }

  Future uploadPostImageToFirebase(BuildContext context) async {
    final provider = Provider.of<FeedScreenViewModel>(context, listen: false);
    print('form service');
    UploadTask imageUploadTask;
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('userPostImage/${TimeOfDay.now()}');

    imageUploadTask = imageReference.putFile(provider.getPostImage);

    await imageUploadTask.whenComplete(() {
      print('Image uploaded');
    });

    String url = await imageReference.getDownloadURL();
    //print('urloo' + url);
    Provider.of<FeedScreenViewModel>(context, listen: false).postImageUrl = url;
    Navigator.pop(context);
  }

  Future addPostData(BuildContext context, dynamic postData) async {
    Post newPost = Post(
      caption: postData['caption'],
      username: postData['username'],
      useruid: postData['useruid'],
      userimage: postData['userimage'],
      postimage: postData['postimage'],
    );
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postData['caption'])
        .set(newPost.toMap());
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future fetchUserProfileInfo(BuildContext context) async {
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<FeedScreenViewModel>(context, listen: false).useruid)
        .get();
    Provider.of<FeedScreenViewModel>(context, listen: false).username =
        doc.get('username');
    Provider.of<FeedScreenViewModel>(context, listen: false).useremail =
        doc.get('useremail');
    Provider.of<FeedScreenViewModel>(context, listen: false).userimage =
        doc.get('userimage');
    notifyListeners();
  }

  Future logoutViaEmail(BuildContext context) async {
    await firebaseAuth.signOut();
    Routes.sailor.navigate(
      "/LandingPage",
      transitions: [SailorTransition.slide_from_left],
      transitionDuration: Duration(milliseconds: 600),
      transitionCurve: Curves.easeOut,
    );
  }

  Future addLike(BuildContext context, String caption) async {
    var uid =
        Provider.of<FeedScreenViewModel>(context, listen: false).getUserUid;
    Like newLike = Like(
      likes: FieldValue.increment(1),
      username:
          Provider.of<FeedScreenViewModel>(context, listen: false).getUserName,
      useruid:
          Provider.of<FeedScreenViewModel>(context, listen: false).getUserUid,
      userimage:
          Provider.of<FeedScreenViewModel>(context, listen: false).getUserImage,
      useremail:
          Provider.of<FeedScreenViewModel>(context, listen: false).getUserEmail,
    );
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(caption)
        .collection('likes')
        .doc(uid)
        .set(newLike.toMap());
  }

  Future addComment(
      BuildContext context,
      String caption,
      String comment,
      String useruid,
      String username,
      String userimage,
      String useremail,
      TextEditingController _commentController) async {
    Comment newComment = Comment(
      comment: comment,
      username: username,
      useruid: useruid,
      userimage: userimage,
      useremail: useremail,
    );
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(caption)
        .collection('comments')
        .doc(comment)
        .set(newComment.toMap());

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    _commentController.clear();
  }

  Future addReward(BuildContext context, String rewardUrl, String caption,
      String useruid) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(caption)
        .collection('rewards')
        .doc(useruid)
        .set({'image': rewardUrl});
  }

  Future followUser(
    BuildContext context,
    dynamic snapshot,
    String followingUid,
  ) async {
    var getDataMethod;
    FeedScreenViewModel provider =
        Provider.of<FeedScreenViewModel>(context, listen: false);
    snapshot.runtimeType.toString() != 'QueryDocumentSnapshot'
        ? getDataMethod = snapshot.data
        : getDataMethod = snapshot;
    Userm followerData = Userm(
      username: provider.getUserName,
      useremail: provider.getUserEmail,
      userimage: provider.getUserImage,
      useruid: provider.getUserUid,
    );
    Userm followingData = Userm(
      username: getDataMethod.get('username'),
      useremail: getDataMethod.get('useremail'),
      userimage: getDataMethod.get('userimage'),
      useruid: getDataMethod.get('useruid'),
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(provider.getUserUid)
        .set(followerData.toMap());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(provider.getUserUid)
        .collection('followings')
        .doc(followingUid)
        .set(followingData.toMap());

    print('followed!!!');
  }
}
