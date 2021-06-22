import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatList {
  String username;
  String useruid;
  String userimage;
  String chatDocId;

  ChatList({
    @required this.username,
    @required this.useruid,
    @required this.userimage,
    @required this.chatDocId,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': this.username,
      'userid': this.useruid,
      'userimage': this.userimage,
      'useremail': this.chatDocId
    };
  }
}
