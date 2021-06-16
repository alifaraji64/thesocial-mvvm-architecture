import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Post {
  String caption;
  String username;
  String useruid;
  Timestamp time = Timestamp.now();
  String userimage;
  String postimage;

  Post(
      {@required this.caption,
      @required this.username,
      @required this.useruid,
      @required this.time,
      @required this.userimage,
      @required this.postimage});
}
