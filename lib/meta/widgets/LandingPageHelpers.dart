import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/core/ViewModels/FeedScreenViewModel.dart';
import 'package:thesocial/core/ViewModels/LandingPageViewModel.dart';
import 'package:thesocial/core/services/FirebaseOperations.dart';

class LandingPageHelpers extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login.png'),
        ),
      ),
    );
  }

  Widget taglineText() {
    return Positioned(
      left: 20,
      top: 460,
      child: Container(
        width: 170,
        child: RichText(
          text: TextSpan(
              text: 'Are ',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: constantColors.whiteColor,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'You ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: constantColors.blueColor,
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'Social ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: constantColors.blueColor,
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: constantColors.whiteColor,
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget mainButton(BuildContext context) {
    return Positioned(
      top: 640,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              child: Container(
                width: 80,
                height: 40,
                child: Icon(
                  EvaIcons.emailOutline,
                  color: constantColors.yellowColor,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: constantColors.yellowColor),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              onTap: () {
                emailAuthSheet(context);
              },
            ),
            GestureDetector(
              child: Container(
                width: 80,
                height: 40,
                child: Icon(
                  FontAwesomeIcons.facebookF,
                  color: constantColors.blueColor,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: constantColors.blueColor),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Future showAvatarImage(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              color: constantColors.blueGreyColor,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 140),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                      height: 250.0,
                      width: 350.0,
                      child: Provider.of<FeedScreenViewModel>(context,
                                      listen: true)
                                  .getAvatarImage !=
                              null
                          ? Image.file(
                              Provider.of<FeedScreenViewModel>(
                                context,
                                listen: true,
                              ).getAvatarImage,
                              fit: BoxFit.contain,
                            )
                          : null),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: [
                        MaterialButton(
                          child: Text(
                            'Reselect',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            avatarSelectOptions(context);
                          },
                        ),
                        MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            'Confirm Image',
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            await Provider.of<FeedScreenViewModel>(context,
                                    listen: false)
                                .uploadImageToFirebase(context, 'avatar');
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ));
        });
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
        top: 740,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "By Countinuing you agree theSocials's Terms of",
                style: TextStyle(color: constantColors.greyColor),
              ),
              Text(
                "Services & Privacy Policy",
                style: TextStyle(color: constantColors.greyColor),
              )
            ],
          ),
        ));
  }

  Future emailAuthSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 140),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                passwordLessSignIn(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        loginSheet(context);
                      },
                    ),
                    MaterialButton(
                      color: constantColors.redColor,
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        signInSheet(context);
                        avatarSelectOptions(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget passwordLessSignIn(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.40,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream:
              Provider.of<LandingPageViewModel>(context, listen: false).stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                children: snapshot.data.docs
                    .map<Widget>((DocumentSnapshot documentSnapshot) {
                  return ListTile(
                    trailing: Container(
                      height: 50,
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.check,
                              color: constantColors.blueColor,
                            ),
                            onPressed: () async {
                              var result =
                                  await Provider.of<LandingPageViewModel>(
                                          context,
                                          listen: false)
                                      .logIntoAccount(
                                          context,
                                          documentSnapshot.get('useremail'),
                                          documentSnapshot.get('userpassword'));
                              print('result from ui');
                              print(result);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.trashAlt,
                              color: constantColors.redColor,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: constantColors.darkColor,
                      backgroundImage:
                          NetworkImage(documentSnapshot.get('userimage')),
                    ),
                    title: Text(
                      documentSnapshot.get('username'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.greenColor,
                        fontSize: 15.0,
                      ),
                    ),
                    subtitle: Text(
                      documentSnapshot.get('useremail'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.whiteColor,
                        fontSize: 14.0,
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ));
  }

  Future loginSheet(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
    GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();

    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 140),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Form(
                  key: _emailKey,
                  child: TextFormField(
                    controller: _emailController,
                    validator: Provider.of<LandingPageViewModel>(context,
                            listen: false)
                        .loginSheetEmailValidator,
                    decoration: InputDecoration(
                      hintText: 'Enter Email ...',
                      hintStyle: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Form(
                  key: _passwordKey,
                  child: TextFormField(
                    validator: Provider.of<LandingPageViewModel>(context,
                            listen: false)
                        .loginSheetPasswordValidator,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter Password ...',
                      hintStyle: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                backgroundColor: constantColors.blueColor,
                child: Icon(
                  FontAwesomeIcons.check,
                  color: constantColors.whiteColor,
                ),
                onPressed: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  currentFocus.unfocus();
                  if (_emailKey.currentState.validate() &&
                      _passwordKey.currentState.validate()) {
                    Provider.of<LandingPageViewModel>(context, listen: false)
                        .logIntoAccount(context, _emailController.text,
                            _passwordController.text);
                  }
                },
              )
            ]),
          );
        });
  }

  Future signInSheet(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
    GlobalKey<FormState> _usernameKey = GlobalKey<FormState>();
    GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();

    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 140),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
              CircleAvatar(
                backgroundColor: constantColors.redColor,
                radius: 70.0,
                backgroundImage: Provider.of<FeedScreenViewModel>(context,
                                listen: false)
                            .getAvatarImage !=
                        null
                    ? FileImage(
                        Provider.of<FeedScreenViewModel>(context, listen: true)
                            .getAvatarImage)
                    : null,
                child: Provider.of<FeedScreenViewModel>(context, listen: true)
                            .getAvatarImage !=
                        null
                    ? null
                    : Icon(
                        FontAwesomeIcons.userCircle,
                        size: 80,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Form(
                  key: _emailKey,
                  child: TextFormField(
                    validator: Provider.of<LandingPageViewModel>(context,
                            listen: false)
                        .registerSheetEmailValidator,
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter Email ...',
                      hintStyle: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Form(
                  key: _usernameKey,
                  child: TextFormField(
                    validator: Provider.of<LandingPageViewModel>(context,
                            listen: false)
                        .registerSheetUsernameValidator,
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter Username ...',
                      hintStyle: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Form(
                  key: _passwordKey,
                  child: TextFormField(
                    obscureText: true,
                    validator: Provider.of<LandingPageViewModel>(context,
                            listen: false)
                        .registerSheetPasswordValidator,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter Password ...',
                      hintStyle: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                  backgroundColor: constantColors.redColor,
                  child: Icon(
                    FontAwesomeIcons.check,
                    color: constantColors.whiteColor,
                  ),
                  onPressed: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    currentFocus.unfocus();
                    if (_emailKey.currentState.validate() &&
                        _usernameKey.currentState.validate() &&
                        _passwordKey.currentState.validate()) {
                      await Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .registerAccount(
                              context,
                              _emailController.text,
                              _passwordController.text,
                              _usernameController.text);
                    }
                  })
            ]),
          );
        });
  }

  Future avatarSelectOptions(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 140),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Camera',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        await Provider.of<FeedScreenViewModel>(context,
                                listen: false)
                            .pickUserAvatar(context, ImageSource.camera);
                        showAvatarImage(context);
                      },
                    ),
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        await Provider.of<FeedScreenViewModel>(context,
                                listen: false)
                            .pickUserAvatar(context, ImageSource.gallery);
                        showAvatarImage(context);
                      },
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
