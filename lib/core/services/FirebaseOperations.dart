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

class FirebaseOperations extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  String errorMsg;
  String useremail;
  String username;
  String userimage;
  String get getUserName => username;
  String get getUserEmail => useremail;
  String get getUserImage => userimage;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  Stream getUsers() {
    return instance.collection('users').snapshots();
  }

  Stream getFollowers(BuildContext context) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(
            Provider.of<FeedScreenViewModel>(context, listen: false).getUserUid)
        .collection('followers')
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
  }

  Future addPostData(BuildContext context) async {}

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
}
