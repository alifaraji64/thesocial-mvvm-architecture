import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sailor/sailor.dart';
import 'package:thesocial/app/routes.dart';
import 'package:thesocial/core/ViewModels/FeedScreenViewModel.dart';

class GlobalViewModel extends ChangeNotifier {
  String altProfileUid;
  String get getAltProfileUid => altProfileUid;
  void redirect(BuildContext context, String route, {String uid}) {
    altProfileUid = uid;
    if (this.getAltProfileUid ==
            Provider.of<FeedScreenViewModel>(context, listen: false)
                .getUserUid &&
        route == '/altProfile') {
      return;
    }
    Routes.sailor.navigate(
      '$route',
      params: {'userUid': this.getAltProfileUid},
      transitions: [SailorTransition.slide_from_left],
      transitionDuration: Duration(milliseconds: 500),
      transitionCurve: Curves.easeOut,
    );
  }

  goBack() {
    Routes.sailor.pop();
  }
}
