
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadImagetoStorage(String fileName, Uint8List file) async {
    Reference ref = storage.ref().child('images').child(fileName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData(
      {required String name,

      required Uint8List file}) async {
    String resp = "Some Error Occurred";
    try{
      String imageUrl = await uploadImagetoStorage(FirebaseAuth.instance.currentUser!.uid.toString(), file);
      DocumentReference documentReference = firestore.collection('users').doc(FirebaseAuth.instance.currentUser?.uid);
      await documentReference.update({
        'name' : name,
        'image': imageUrl,
      });
      FirebaseAuth.instance.currentUser?.updateDisplayName(name);
      FirebaseAuth.instance.currentUser?.updatePhotoURL(imageUrl);

      resp = 'Successfully save profile';
      FirebaseAuth.instance.currentUser?.reload();

    } catch(err){
      resp = err.toString();
    }
    return resp;

  }
}
