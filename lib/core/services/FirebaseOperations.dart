import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/app/routes.dart';
import 'package:thesocial/core/ViewModels/FeedScreenViewModel.dart';
import 'package:thesocial/core/models/ChatList.dart';
import 'package:thesocial/core/models/ChatMsg.dart';
import 'package:thesocial/core/models/Comment.dart';
import 'package:thesocial/core/models/Like.dart';
import 'package:thesocial/core/models/Post.dart';
import 'package:thesocial/core/models/User.dart';
import 'package:thesocial/core/models/UserRegister.dart';

class FirebaseOperations extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  String loginErrorMsg;
  String registerErrorMsg;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  Stream getUsers() {
    return instance.collection('users').snapshots();
  }

  Stream getFollowers(BuildContext context, [String altProfileUid]) {
    //print('this is alt UID: ' + altProfileUid);
    return instance
        .collection('users')
        .doc(
          altProfileUid == null
              ? Provider.of<FeedScreenViewModel>(context, listen: false)
                  .getUserUid
              : altProfileUid,
        )
        .collection('followers')
        .snapshots();
  }

  Stream getFollowings(BuildContext context, [String altProfileUid]) {
    return instance
        .collection('users')
        .doc(
          altProfileUid == null
              ? Provider.of<FeedScreenViewModel>(context, listen: false)
                  .getUserUid
              : altProfileUid,
        )
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

  Stream getComments(caption) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(caption)
        .collection('comments')
        .orderBy('time')
        .snapshots();
  }

  Stream getChatList(String userUid) {
    return instance
        .collection('users')
        .doc(userUid)
        .collection('chats')
        .snapshots();
  }

  Stream getChatMessages(String chatDocUid) {
    return instance
        .collection('chats')
        .doc(chatDocUid)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  Future addUserToCollection(BuildContext context, dynamic data) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Provider.of<FeedScreenViewModel>(context, listen: false)
              .getUserUid)
          .set(data);
    } catch (e) {
      print(e.code);
    }
  }

  Future logIntoAccount(
      BuildContext context, String email, String password) async {
    loginErrorMsg = null;
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User user = userCredential.user;

      Provider.of<FeedScreenViewModel>(context, listen: false).useruid =
          user.uid;
      await fetchUserProfileInfo(context);
      Routes.sailor.navigate("/HomePage");
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case 'user-not-found':
          loginErrorMsg = 'this email is not registered';
          break;
        case 'invalid-email':
          loginErrorMsg = 'this email is invalid';
          break;
        case 'wrong-password':
          loginErrorMsg = 'password is wrong';
          break;
        default:
          loginErrorMsg = 'some unknown error occured';
      }

      showSnackBar(context, loginErrorMsg, constantColors.whiteColor,
          constantColors.redColor);
      return false;
    } catch (e) {
      print(
          Provider.of<FeedScreenViewModel>(context, listen: false).getUserUid);
      return false;
    }
  }

  Future<bool> registerAccount(BuildContext context, String email,
      String password, String username) async {
    registerErrorMsg = null;
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      Provider.of<FeedScreenViewModel>(context, listen: false).useruid =
          user.uid;
      UserRegister newUserRegister = UserRegister(
        username: username,
        useremail: email,
        userimage: Provider.of<FeedScreenViewModel>(context, listen: false)
            .getAvatarUrl,
        password: password,
        useruid: user.uid,
      );
      await addUserToCollection(context, newUserRegister.toMap());
      await logIntoAccount(context, email, password);
      Provider.of<FeedScreenViewModel>(context, listen: false).avatarUrl = null;
      Provider.of<FeedScreenViewModel>(context, listen: false).avatarImage =
          null;
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case 'invalid-email':
          registerErrorMsg = 'please enter a valid email';
          break;
        case 'email-already-in-use':
          registerErrorMsg = 'this email is already in use';
          break;
        default:
          registerErrorMsg = 'some unknown error occured';
      }
      showSnackBar(
        context,
        registerErrorMsg,
        constantColors.whiteColor,
        constantColors.redColor,
      );
      return false;
    } catch (e) {
      return false;
    }
  }

  Future uploadPostImageToFirebase(BuildContext context, String useCase) async {
    final provider = Provider.of<FeedScreenViewModel>(context, listen: false);
    print('form service');
    UploadTask imageUploadTask;
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('userPostImage/${TimeOfDay.now()}');

    imageUploadTask = imageReference.putFile(
        useCase == 'avatar' ? provider.getAvatarImage : provider.getPostImage);

    await imageUploadTask.whenComplete(() {
      print('Image uploaded');
    });

    String url = await imageReference.getDownloadURL();
    if (useCase == 'avatar') {
      Provider.of<FeedScreenViewModel>(context, listen: false).avatarUrl = url;
    }
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
    Provider.of<FeedScreenViewModel>(context, listen: false).avatarImage = null;
    Provider.of<FeedScreenViewModel>(context, listen: false).avatarUrl = null;
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
    Provider.of<FeedScreenViewModel>(context, listen: false).useruid = null;
    Routes.sailor.navigate("/LandingPage");
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
    String snapShotType = snapshot.runtimeType.toString();
    snapShotType != 'QueryDocumentSnapshot'
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
    showSnackBar(
      context,
      '${snapShotType == "_JsonQueryDocumentSnapshot" || snapShotType == "QueryDocumentSnapshot" ? snapshot.get("username") : snapshot.data.get("username")} has been followed',
      constantColors.darkColor,
      constantColors.yellowColor,
    );
    print('followed!!!');
  }

  Future unfollowUser(BuildContext context, dynamic snapshot,
      String unfollowingUid, String beingUnfollowed) async {
    String snapShotType = snapshot.runtimeType.toString();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(beingUnfollowed)
        .collection('followers')
        .doc(unfollowingUid)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(unfollowingUid)
        .collection('followings')
        .doc(beingUnfollowed)
        .delete();

    showSnackBar(
      context,
      '${snapShotType == "_JsonQueryDocumentSnapshot" || snapShotType == "QueryDocumentSnapshot" ? snapshot.get("username") : snapshot.data.get("username")} has been Unfollowed',
      constantColors.whiteColor,
      constantColors.redColor,
    );
  }

  dynamic showSnackBar(
      BuildContext context, String content, Color textColor, Color bgColor) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: bgColor,
        duration: Duration(seconds: 1),
        content: Text(
          '$content',
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future deletePost(BuildContext context, String caption) async {
    await instance.collection('posts').doc(caption).delete();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future deleteChatList(String chatDocUid, String myUid, String userUid) async {
    await instance
        .collection('chats')
        .doc(chatDocUid)
        .collection('messages')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((QueryDocumentSnapshot documentSnapshot) {
        documentSnapshot.reference.delete();
      });
    });

    await instance
        .collection('users')
        .doc(myUid)
        .collection('chats')
        .doc(userUid)
        .delete();

    await instance
        .collection('users')
        .doc(userUid)
        .collection('chats')
        .doc(myUid)
        .delete();
  }

  Future addChat(
      BuildContext context,
      String profileImage,
      String username,
      String userUid,
      String myUid,
      TextEditingController _chatController,
      String chatDocId) async {
    if (_chatController.text.length == 0) return;
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    var provider = Provider.of<FeedScreenViewModel>(context, listen: false);
    ChatMsg newChatMsg =
        ChatMsg(message: _chatController.text, from: myUid, to: userUid);
    ChatList chatListForMe = ChatList(
      username: username,
      useruid: userUid,
      userimage: profileImage,
      chatDocId: chatDocId,
    );
    ChatList chatListForOther = ChatList(
      username: provider.getUserName,
      useruid: provider.getUserUid,
      userimage: provider.getUserImage,
      chatDocId: chatDocId,
    );
    _chatController.clear();
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatDocId)
        .collection('messages')
        .add(newChatMsg.toMap());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(myUid)
        .collection('chats')
        .doc(userUid)
        .set(chatListForMe.toMap());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('chats')
        .doc(myUid)
        .set(chatListForOther.toMap());
  }

  Future deleteChatMessage(String chatDocUid, String docId) async {
    await instance
        .collection('chats')
        .doc(chatDocUid)
        .collection('messages')
        .doc(docId)
        .delete();
  }
}
