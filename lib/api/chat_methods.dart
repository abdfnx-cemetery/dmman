import 'package:flutter/material.dart';
import 'package:dmman/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:dmman/models/contact.dart';
import 'package:dmman/models/message.dart';
import 'package:dmman/constants/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMethods {
  static final Firestore _firestore = Firestore.instance;

  final CollectionReference _msgCollection =
      _firestore.collection(MESSAGES_COLLECTION);

  final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  Future<void> addMsgToDB(Message message, User sen, User rec) async {
    var map = message.toMap();

    await _msgCollection
        .document(message.senId)
        .collection(message.recId)
        .add(map);

    addToContacts(senId: message.senId, recId: message.recId);

    return await _msgCollection
        .document(message.recId)
        .collection(message.senId)
        .add(map);
  }

  DocumentReference getContactsDoc({String of, String forContact}) =>
      _userCollection
          .document(of)
          .collection(CONTACTS_COLLECTION)
          .document(forContact);

  addToContacts({String senId, String recId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenContacts(senId, recId, currentTime);
    await addToRecContacts(senId, recId, currentTime);
  }

  Future<void> addToSenContacts(
    String senId,
    String recId,
    currentTime,
  ) async {
    DocumentSnapshot senSnapshot =
        await getContactsDoc(of: senId, forContact: recId).get();

    if (!senSnapshot.exists) {
      // does not exists
      Contact recContact = Contact(
        uid: recId,
        addedOn: currentTime,
      );

      var recMap = recContact.toMap(recContact);

      await getContactsDoc(of: senId, forContact: recId).setData(recMap);
    }
  }

  Future<void> addToRecContacts(
    String senId,
    String recId,
    currentTime,
  ) async {
    DocumentSnapshot recSnapshot =
        await getContactsDoc(of: recId, forContact: senId).get();

    if (!recSnapshot.exists) {
      // does not exists
      Contact senContact = Contact(
        uid: senId,
        addedOn: currentTime,
      );

      var senMap = senContact.toMap(senContact);

      await getContactsDoc(of: recId, forContact: senId).setData(senMap);
    }
  }

  void setImageMsg(String url, String recId, String senId) async {
    Message message;

    message = Message.imageMsg(
        message: "Photo",
        recId: recId,
        senId: senId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image');

    // create imagemap
    var map = message.toImageMap();

    // var map = Map<String, dynamic>();
    await _msgCollection
        .document(message.senId)
        .collection(message.recId)
        .add(map);

    _msgCollection.document(message.recId).collection(message.senId).add(map);
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) => _userCollection
      .document(userId)
      .collection(CONTACTS_COLLECTION)
      .snapshots();

  Stream<QuerySnapshot> fetchLastMsgBetween({
    @required String senId,
    @required String recId,
  }) =>
      _msgCollection
          .document(senId)
          .collection(recId)
          .orderBy("timestamp")
          .snapshots();
}
