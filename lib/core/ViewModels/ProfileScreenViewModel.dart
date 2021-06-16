import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:thesocial/core/services/FirebaseOperations.dart';

class ProfileScreenViewModel extends ChangeNotifier {
  final FirebaseOperations firebaseOperations = FirebaseOperations();

  Stream getFollowers(BuildContext context) {
    return firebaseOperations.getFollowers(context);
  }
}
