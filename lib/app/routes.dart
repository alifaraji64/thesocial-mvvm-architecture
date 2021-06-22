// Routes class is created by you.

import 'package:sailor/sailor.dart';
import 'package:thesocial/meta/screens/AltProfileScreen.dart';
import 'package:thesocial/meta/screens/ChatListScreen.dart';
import 'package:thesocial/meta/screens/HomeScreen.dart';
import 'package:thesocial/meta/screens/LandingPage.dart';
import 'package:thesocial/meta/screens/ProfileScreen.dart';
import 'package:thesocial/meta/screens/SplashScreen.dart';
import 'package:thesocial/meta/screens/ChatScreen.dart';

class Routes {
  static final sailor = Sailor();

  static void createRoutes() {
    SailorOptions(
      defaultTransitions: [SailorTransition.slide_from_left],
      defaultTransitionDuration: Duration(milliseconds: 500),
    );
    sailor.addRoutes([
      SailorRoute(
        name: '/',
        builder: (context, args, params) => SplashScreen(),
      ),
      SailorRoute(
        name: '/LandingPage',
        builder: (context, args, params) => LandingPage(),
      ),
      SailorRoute(
        name: '/HomePage',
        builder: (context, args, params) => HomeScreen(),
      ),
      SailorRoute(
        name: '/profileScreen',
        builder: (context, args, params) => ProfileScreen(),
      ),
      SailorRoute(
        name: '/altProfile',
        builder: (context, args, params) => AltProfileScreen(),
        params: [
          SailorParam<String>(
            name: 'userUid',
          ),
        ],
      ),
      SailorRoute(
        name: '/chatList',
        builder: (context, args, params) => ChatListScreen(),
      ),
      SailorRoute(
        name: '/chatScreen',
        builder: (context, args, params) => ChatScreen(),
        params: [
          SailorParam<String>(
            name: 'userUid',
          ),
          SailorParam<String>(
            name: 'myUid',
          ),
          SailorParam<String>(
            name: 'profileImage',
          ),
          SailorParam<String>(
            name: 'username',
          ),
        ],
      ),
    ]);
  }
}
