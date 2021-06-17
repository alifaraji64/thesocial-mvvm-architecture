import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Comment {
  String comment;
  String username;
  String useruid;
  Timestamp time = Timestamp.now();
  String userimage;
  String useremail;

  Comment({
    @required this.comment,
    @required this.username,
    @required this.useruid,
    @required this.userimage,
    @required this.useremail,
  });

  Map<String, dynamic> toMap() {
    return {
      'comment': this.comment,
      'username': this.username,
      'useruid': this.useruid,
      'userimage': this.userimage,
      'useremail': this.useremail,
      'time': this.time
    };
  }
}
