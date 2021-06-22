import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thesocial/core/ViewModels/AltProfileScreenViewModel.dart';
import 'package:thesocial/core/ViewModels/ChatListScreenViewModel.dart';
import 'package:thesocial/core/ViewModels/FeedScreenViewModel.dart';
import 'package:thesocial/core/ViewModels/LandingPageViewModel.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/core/ViewModels/ProfileScreenViewModel.dart';
import 'package:thesocial/core/ViewModels/GlobalViewModel.dart';
import 'package:thesocial/core/services/UploadImage.dart';
import 'package:thesocial/meta/widgets/AltProfileScreenHelpers.dart';
import 'package:thesocial/meta/widgets/ChatScreenHelpers.dart';
import 'package:thesocial/meta/widgets/FeedPostSheets.dart';
import 'package:thesocial/meta/widgets/Globalwidgets.dart';
import 'package:thesocial/meta/widgets/LandingPageHelpers.dart';
import 'package:get/get.dart';
import 'package:thesocial/meta/widgets/chatListScreenHelpers.dart';
import 'app/routes.dart';
import 'core/ViewModels/ChatScreenViewModel.dart';
import 'core/services/FirebaseOperations.dart';
import 'meta/widgets/FeedScreenHelpers.dart';
import 'meta/widgets/ProfileScreenHelpers.dart';

void main() async {
  Routes.createRoutes();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatScreenViewModel()),
        ChangeNotifierProvider(create: (_) => ChatScreenHelpers()),
        ChangeNotifierProvider(create: (_) => ChatListScreenViewModel()),
        ChangeNotifierProvider(create: (_) => ChatListScreenHelpers()),
        ChangeNotifierProvider(create: (_) => AltProfileScreenViewModel()),
        ChangeNotifierProvider(create: (_) => AltProfileScreenHelpers()),
        ChangeNotifierProvider(create: (_) => GlobalViewModel()),
        ChangeNotifierProvider(create: (_) => FeedPostSheets()),
        ChangeNotifierProvider(create: (_) => GlobalWidgets()),
        ChangeNotifierProvider(create: (_) => ProfileScreenViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileScreenHelpers()),
        ChangeNotifierProvider(create: (_) => UploadImage()),
        ChangeNotifierProvider(create: (_) => FeedScreenViewModel()),
        ChangeNotifierProvider(create: (_) => FeedScreenHelpers()),
        ChangeNotifierProvider(create: (_) => LandingPageViewModel()),
        ChangeNotifierProvider(create: (_) => FirebaseOperations()),
        ChangeNotifierProvider(create: (_) => LandingPageHelpers()),
      ],
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          canvasColor: Colors.transparent,
        ),
        navigatorKey: Routes.sailor.navigatorKey, // important
        onGenerateRoute: Routes.sailor.generator(),
      ),
    );
  }
}
