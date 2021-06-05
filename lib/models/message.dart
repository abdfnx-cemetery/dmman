import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senId;
  String recId;
  String type;
  String message;
  Timestamp timestamp;
  String photoUrl;

  Message({this.senId, this.recId, this.type, this.message, this.timestamp});

  Message.imageMsg(
      {this.senId,
      this.recId,
      this.message,
      this.type,
      this.timestamp,
      this.photoUrl});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senId'] = this.senId;
    map['recId'] = this.recId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['message'] = this.message;
    map['senId'] = this.senId;
    map['recOd'] = this.recId;
    map['type'] = this.type;
    map['timestamp'] = this.timestamp;
    map['photoUrl'] = this.photoUrl;
    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    this.senId = map['senId'];
    this.recId = map['recId'];
    this.type = map['type'];
    this.message = map['message'];
    this.timestamp = map['timestamp'];
    this.photoUrl = map['photoUrl'];
  }
}
