import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/app/ConstantColors.dart';
import 'package:thesocial/core/ViewModels/FeedScreenViewModel.dart';

class FeedScreenHelpers extends ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();

  Future selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
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
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        // Provider.of<FeedUtils>(context, listen: false)
                        //     .pickPostImage(context, ImageSource.camera)
                        //     .whenComplete(() {
                        //   Provider.of<FeedServices>(context, listen: false)
                        //       .showPostImage(context);
                        // });
                        await Provider.of<FeedScreenViewModel>(context,
                                listen: false)
                            .pickPostImage(context, ImageSource.camera);
                        //Provider.of<FeedScreenHelpers>(context, listen: false);
                      },
                    ),
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        await Provider.of<FeedScreenViewModel>(context,
                                listen: false)
                            .pickPostImage(context, ImageSource.gallery);
                        showPostImage(context);
                      },
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget feedBody(BuildContext context) {
    return Text('yooo');
  }

  Future showPostImage(BuildContext context) {
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
                                  .getPostImage !=
                              null
                          ? Image.file(
                              Provider.of<FeedScreenViewModel>(
                                context,
                                listen: true,
                              ).getPostImage,
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
                            Provider.of<FeedScreenHelpers>(context,
                                    listen: false)
                                .selectPostImageType(context);
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
                            print('1');
                            await Provider.of<FeedScreenViewModel>(context,
                                    listen: false)
                                .uploadImageToFirebase(context);
                            print('5');
                            print('URRRL' +
                                Provider.of<FeedScreenViewModel>(context,
                                        listen: false)
                                    .getPostImageUrl
                                    .toString());
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ));
        });
  }

  Future editPostSheet(BuildContext context) {
    TextEditingController _captionController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
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
                Container(
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.image_aspect_ratio,
                              color: constantColors.greenColor,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.fit_screen,
                              color: constantColors.yellowColor,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Container(
                        height: 200,
                        width: 300,
                        child: Image.file(Provider.of<FeedScreenViewModel>(
                                context,
                                listen: false)
                            .getPostImage),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset('assets/icons/sunflower.png'),
                      ),
                      Container(
                        width: 5,
                        height: 110,
                        color: constantColors.blueColor,
                      ),
                      Container(
                        height: 120,
                        width: 330,
                        child: Form(
                          key: formKey,
                          child: TextFormField(
                            validator: Provider.of<FeedScreenViewModel>(context,
                                    listen: false)
                                .captionValidator,
                            maxLines: 5,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            controller: _captionController,
                            decoration: InputDecoration(
                              hintText: 'Add Caption',
                              hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: TextStyle(color: constantColors.whiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                    color: constantColors.blueColor,
                    child: Text(
                      'Share',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () {
                      if (!formKey.currentState.validate()) {
                        return;
                      }
                      // Provider.of<FeedScreenViewModel>(context,listen: false).addPostData(context,_captionController.text, username, useruid, time, userimage, postimage)

                      // Provider.of<FirebaseOperations>(context, listen: false)
                      //     .addPostData(_captionController.text, {
                      //   'caption': _captionController.text,
                      //   'username': Provider.of<FirebaseOperations>(context,
                      //           listen: false)
                      //       .getUserName,
                      //   'useremail': Provider.of<FirebaseOperations>(context,
                      //           listen: false)
                      //       .getUserEmail,
                      //   'useruid':
                      //       Provider.of<Authentication>(context, listen: false)
                      //           .getUserUid,
                      //   'time': Timestamp.now(),
                      //   'userimage': Provider.of<FirebaseOperations>(context,
                      //           listen: false)
                      //       .getUserImage,
                      //   'postimage':
                      //       Provider.of<FeedUtils>(context, listen: false)
                      //           .getPostImageUrl,
                      // }).whenComplete(() {
                      //   print('post data added');
                      //   Navigator.pop(context);
                      //   Navigator.pop(context);
                      //   Navigator.pop(context);
                      // });
                    })
              ],
            ),
          );
        });
  }
}
