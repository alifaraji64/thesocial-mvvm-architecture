import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/core/ViewModels/FeedScreenViewModel.dart';

class UploadImage extends ChangeNotifier {
  final picker = ImagePicker();
  File postImage;
  File get getPostImage => postImage;

  Future pickPostImage(BuildContext context, ImageSource source) async {
    PickedFile pickedPostImage = await picker.getImage(source: source);

    pickedPostImage == null
        // ignore: unnecessary_statements
        ? 'error occured'
        : postImage = File(pickedPostImage.path);

    Provider.of<FeedScreenViewModel>(context, listen: false).postImage =
        getPostImage;
    print('this is newly selected user post' + pickedPostImage.path ?? '');

    notifyListeners();
  }
}
