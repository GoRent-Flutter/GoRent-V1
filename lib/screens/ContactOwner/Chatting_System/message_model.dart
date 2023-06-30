import 'package:cloud_firestore/cloud_firestore.dart';
class MessageModel {
  String? sender;
  String? text;
  bool? seen;
  String? messageId;
  DateTime? createdOn;
  MessageModel({this.messageId,this.sender, this.text, this.seen, this.createdOn});
  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdOn = (map["createdOn"] as Timestamp).toDate();
    messageId = map["messageId"];
  }

  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdOn": createdOn,
      "messageId":messageId,
    };
  }
}
