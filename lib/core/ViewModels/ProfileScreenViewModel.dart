import 'package:flutter/cupertino.dart';
import 'package:thesocial/core/services/FirebaseOperations.dart';

class ProfileScreenViewModel extends ChangeNotifier {
  final FirebaseOperations firebaseOperations = FirebaseOperations();

  Stream getFollowers(BuildContext context) {
    return firebaseOperations.getFollowers(context);
  }

  Stream getFollowings(BuildContext context) {
    return firebaseOperations.getFollowings(context);
  }

  Future fetchUserProfileInfo(BuildContext context) {
    return firebaseOperations.fetchUserProfileInfo(context);
  }

  Future logoutViaEmail(BuildContext context) async {
    await firebaseOperations.logoutViaEmail(context);
  }
}
