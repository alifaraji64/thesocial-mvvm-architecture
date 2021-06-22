import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/core/ViewModels/FeedScreenViewModel.dart';
import 'package:thesocial/core/services/FirebaseOperations.dart';

class ChatListScreenViewModel extends ChangeNotifier {
  FirebaseOperations firebaseOperations = FirebaseOperations();
  Stream getChatList(BuildContext context) {
    return firebaseOperations.getChatList(
        Provider.of<FeedScreenViewModel>(context, listen: false).getUserUid);
  }

  Future deleteChatList(
      BuildContext context, String chatDocUid, String userUid) {
    return firebaseOperations.deleteChatList(
        chatDocUid,
        Provider.of<FeedScreenViewModel>(context, listen: false).getUserUid,
        userUid);
  }
}
