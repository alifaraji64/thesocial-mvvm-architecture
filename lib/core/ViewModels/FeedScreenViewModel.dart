import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/core/services/FirebaseOperations.dart';
import 'package:thesocial/core/services/UploadImage.dart';

class FeedScreenViewModel extends ChangeNotifier {
  File postImage;
  File get getPostImage => postImage;
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

  Future pickPostImage(BuildContext context, ImageSource source) async {
    Provider.of<UploadImage>(context, listen: false).postImage = null;
    await Provider.of<UploadImage>(context, listen: false)
        .pickPostImage(context, source);
  }

  Future uploadImageToFirebase(BuildContext context) async {
    print('2');
    if (getPostImage != null) {
      print('from in vm');
      await Provider.of<FirebaseOperations>(context, listen: false)
          .uploadPostImageToFirebase(context);
      print('4');
    }
  }

  String captionValidator(value) {
    if (value.isEmpty) {
      return 'please fill the caption';
    } else if (value.toString().length < 3) {
      return 'make sure your caption is long enough';
    }
    return null;
  }

  Future addPostData(BuildContext context, caption, username, useruid, time,
      userimage, postimage) {}
}
