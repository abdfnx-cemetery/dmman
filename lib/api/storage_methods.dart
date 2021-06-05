import 'dart:io';
import 'chat_methods.dart';
import 'package:flutter/widgets.dart';
import 'package:dmman/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dmman/provider/image_upload_provider.dart';

class StorageMethods {
  static final Firestore firestore = Firestore.instance;

  StorageReference _storageRef;

  //user class
  User user = User();

  Future<String> uploadImageToStorage(File imageFile) async {
    // mention try catch later on

    try {
      _storageRef = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      StorageUploadTask storageUploadTask = _storageRef.putFile(imageFile);
      var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
      // print(url);
      return url;
    } catch (e) {
      return null;
    }
  }

  void uploadImage({
    @required File img,
    @required String recId,
    @required String senId,
    @required ImageUploadProvider imageUploadProvider,
  }) async {
    final ChatMethods chatMethods = ChatMethods();

    // Set some loading value to db and show it to user
    imageUploadProvider.setToLoading();

    // Get url from the image bucket
    String url = await uploadImageToStorage(img);

    // Hide loading
    imageUploadProvider.setToIdle();

    chatMethods.setImageMsg(url, recId, senId);
  }
}
