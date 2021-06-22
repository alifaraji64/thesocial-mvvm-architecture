import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/app/routes.dart';
import 'package:thesocial/core/ViewModels/FeedScreenViewModel.dart';

class GlobalViewModel extends ChangeNotifier {
  String altProfileUid;
  String get getAltProfileUid => altProfileUid;
  void redirect(BuildContext context, String route,
      {String uid, String myUid, String profileImage, String username}) {
    altProfileUid = uid;
    switch (route) {
      case '/altProfile':
        Provider.of<FeedScreenViewModel>(context, listen: false).getUserUid !=
                this.getAltProfileUid
            ? Routes.sailor.navigate(
                '/altProfile',
                params: {'userUid': this.getAltProfileUid},
              )
            : Routes.sailor.navigate(
                '/profileScreen',
              );
        break;

      case '/chatScreen':
        Routes.sailor.navigate(
          '/chatScreen',
          params: {
            'userUid': uid,
            'myUid': myUid,
            'profileImage': profileImage,
            'username': username
          },
        );
        break;
      default:
    }
  }
}
