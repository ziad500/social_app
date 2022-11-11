import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? senderId;
  String? recieverId;
  Timestamp? dateTime;
  String? text;

  MessageModel({
    this.recieverId,
    this.senderId,
    this.dateTime,
    this.text,
  });

  MessageModel.fromjson(Map<String, dynamic> json) {
    recieverId = json['recieverId'];
    senderId = json['senderId'];

    dateTime = json['dateTime'] ?? '';
    text = json['text'];
  }

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "recieverId": recieverId,
      "dateTime": dateTime,
      "text": text,
    };
  }
}
