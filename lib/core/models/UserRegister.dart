import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserRegister {
  String username;
  String useremail;
  String userimage;
  String password;
  String useruid;

  UserRegister({
    @required this.username,
    @required this.useremail,
    @required this.userimage,
    @required this.password,
    @required this.useruid,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': this.username,
      'useremail': this.useremail,
      'userimage': this.userimage,
      'useruid': this.useruid,
      'userpassword': this.password,
    };
  }
}
