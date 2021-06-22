import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMsg {
  String message;
  Timestamp time = Timestamp.now();
  String from;
  String to;

  ChatMsg({
    @required this.message,
    @required this.from,
    @required this.to,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': this.message,
      'time': this.time,
      'from': this.from,
      'to': this.to
    };
  }
}
