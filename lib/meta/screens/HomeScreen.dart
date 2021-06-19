import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/core/ViewModels/FeedScreenViewModel.dart';
import 'package:thesocial/meta/screens/ChatListScreen.dart';
import 'package:thesocial/meta/screens/FeedScreen.dart';
import 'package:thesocial/meta/screens/ProfileScreen.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  ConstantColors constantColors = ConstantColors();
  final PageController homepageController = PageController();
  int pageIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: constantColors.darkColor,
        body: PageView(
          controller: homepageController,
          children: [FeedScreen(), ChatListScreen(), ProfileScreen()],
          //physics: NeverScrollableScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              pageIndex = page;
            });
          },
        ),
        bottomNavigationBar: CustomNavigationBar(
          backgroundColor: Colors.grey[900],
          currentIndex: pageIndex,
          bubbleCurve: Curves.bounceOut,
          scaleCurve: Curves.ease,
          selectedColor: constantColors.blueColor,
          unSelectedColor: constantColors.whiteColor,
          strokeColor: constantColors.blueColor,
          scaleFactor: 0.2,
          iconSize: 32.0,
          onTap: (val) {
            pageIndex = val;
            homepageController.jumpToPage(val);
          },
          items: [
            CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
            CustomNavigationBarItem(icon: Icon(Icons.message_rounded)),
            CustomNavigationBarItem(
                icon: CircleAvatar(
              backgroundImage: Provider.of<FeedScreenViewModel>(
                        context,
                        listen: false,
                      ).getUserImage !=
                      null
                  ? NetworkImage(
                      Provider.of<FeedScreenViewModel>(
                        context,
                        listen: false,
                      ).getUserImage,
                    )
                  : null,
            )),
          ],
        ));
  }
}
