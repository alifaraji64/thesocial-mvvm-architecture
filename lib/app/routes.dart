// Routes class is created by you.

import 'package:sailor/sailor.dart';
import 'package:thesocial/meta/screens/AltProfileScreen.dart';
import 'package:thesocial/meta/screens/HomeScreen.dart';
import 'package:thesocial/meta/screens/LandingPage.dart';
import 'package:thesocial/meta/screens/SplashScreen.dart';

class Routes {
  static final sailor = Sailor();

  static void createRoutes() {
    sailor.addRoutes([
      SailorRoute(
          name: '/',
          builder: (context, args, params) {
            return SplashScreen();
          }),
      SailorRoute(
          name: '/LandingPage',
          builder: (context, args, params) {
            return LandingPage();
          }),
      SailorRoute(
          name: '/HomePage',
          builder: (context, args, params) {
            return HomeScreen();
          }),
      SailorRoute(
        name: '/altProfile',
        builder: (context, args, params) => AltProfileScreen(),
        params: [
          SailorParam<String>(
            name: 'userUid',
          ),
        ],
      ),
    ]);
  }
}
