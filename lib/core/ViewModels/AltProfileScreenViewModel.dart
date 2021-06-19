import 'package:flutter/cupertino.dart';
import 'package:thesocial/core/services/FirebaseOperations.dart';

class AltProfileScreenViewModel extends ChangeNotifier {
  final FirebaseOperations firebaseOperations = FirebaseOperations();

  Stream getFollowers(BuildContext context, String uid) {
    return firebaseOperations.getFollowers(context, uid);
  }

  Stream getFollowings(BuildContext context, String uid) {
    return firebaseOperations.getFollowings(context, uid);
  }

  Future fetchUserProfileInfo(BuildContext context) {
    return firebaseOperations.fetchUserProfileInfo(context);
  }
}
