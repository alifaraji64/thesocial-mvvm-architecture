import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Like {
  FieldValue likes;
  String username;
  String useruid;
  String userimage;
  String useremail;

  Like({
    @required this.likes,
    @required this.username,
    @required this.useruid,
    @required this.userimage,
    @required this.useremail,
  });

  Map<String, dynamic> toMap() {
    return {
      'likes': this.likes,
      'username': this.username,
      'useruid': this.useruid,
      'userimage': this.userimage,
      'useremail': this.useremail
    };
  }
}
