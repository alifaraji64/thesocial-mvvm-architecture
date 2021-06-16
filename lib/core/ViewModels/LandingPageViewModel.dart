import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:thesocial/core/services/FirebaseOperations.dart';

class LandingPageViewModel extends ChangeNotifier {
  final FirebaseOperations firebaseOperations = FirebaseOperations();
  Stream<QuerySnapshot> get stream => getUsers();

  Future logIntoAccount(
      BuildContext context, String email, String password) async {
    var result =
        await firebaseOperations.logIntoAccount(context, email, password);
    print('result form VM ' + result.toString());
    return result;
  }

  Stream<QuerySnapshot> getUsers() {
    return firebaseOperations.getUsers();
  }

  String loginSheetEmailValidator(value) {
    if (value.isEmpty) {
      return 'please fill the email';
    }
    return null;
  }

  String loginSheetPasswordValidator(value) {
    if (value.isEmpty) {
      return 'please fill the password';
    } else if (value.toString().length < 6) {
      return 'make sure password contains at least 6 char';
    }
    return null;
  }
}
