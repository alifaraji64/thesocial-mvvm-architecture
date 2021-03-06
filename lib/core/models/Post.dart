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

  Post({
    @required this.caption,
    @required this.username,
    @required this.useruid,
    @required this.userimage,
    @required this.postimage,
  });

  Map<String, dynamic> toMap() {
    return {
      'caption': this.caption,
      'username': this.username,
      'useruid': this.useruid,
      'time': this.time,
      'userimage': this.userimage,
      'postimage': this.postimage
    };
  }
}
