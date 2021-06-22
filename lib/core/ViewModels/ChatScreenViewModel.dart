import 'package:flutter/cupertino.dart';
import 'package:thesocial/core/services/FirebaseOperations.dart';

class ChatScreenViewModel extends ChangeNotifier {
  FirebaseOperations firebaseOperations = FirebaseOperations();
  Stream getChatMessages(String chatDocUid) {
    return firebaseOperations.getChatMessages(chatDocUid);
  }

  Future addChat(
      BuildContext context,
      String profileImage,
      String username,
      String userUid,
      String myUid,
      TextEditingController _chatController,
      String chatDocUid) async {
    await firebaseOperations.addChat(context, profileImage, username, userUid,
        myUid, _chatController, chatDocUid);
  }

  Future deleteChatMessage(String chatDocUid, String docId) async {
    await firebaseOperations.deleteChatMessage(chatDocUid, docId);
  }
}
