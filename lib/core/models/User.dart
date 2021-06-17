import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Userm {
  String username;
  String useremail;
  String userimage;
  Timestamp time = Timestamp.now();
  String useruid;

  Userm({
    @required this.username,
    @required this.useremail,
    @required this.userimage,
    @required this.useruid,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': this.username,
      'useremail': this.useremail,
      'userimage': this.userimage,
      'useruid': this.useruid,
      'time': this.time,
    };
  }
}
