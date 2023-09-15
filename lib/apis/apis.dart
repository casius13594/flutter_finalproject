import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/apis/add_data.dart';
import 'package:flutter_finalproject/models/message.dart';
import 'package:image_picker/image_picker.dart';
import '../models/chat_user.dart';
import 'dart:typed_data';

class APIs {
  //log in - verfication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //access the firebase
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //ChatUserProfile
  static late ChatUserProfile cur_chatUserProfile;

  static User get user => auth.currentUser!;

  static Future<void> SelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        cur_chatUserProfile = ChatUserProfile.fromJson(user.data()!);
      } else {
        await createUser().then((value) => SelfInfo());
      }
    });
  }

  static Future<bool> checkUserExist() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatUserProfile = ChatUserProfile(
        image: user.photoURL.toString(),
        birthdate: '',
        isActive: false,
        lastSeen: time,
        name: user.displayName.toString(),
        createdAt: time,
        pushToken: '',
        email: user.email.toString(),
        lastMess: "Welcome to Chat Box",
        uid: user.uid.toString());
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUserProfile.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('email', isNotEqualTo: user.email)
        .snapshots();
  }

  //Online status
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUserProfile chatUserProfile) {
    return firestore
        .collection('users')
        .where('uid', isEqualTo: chatUserProfile.uid)
        .snapshots();
  }

  static Future<void> updateStatusActive(bool isActive) async {
    firestore.collection('users').doc(user.uid).update({
      'is_active': isActive,
      'last_seen': DateTime.now().microsecondsSinceEpoch.toString()
    });
  }

  //ChatMess

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMess(
      ChatUserProfile user) {
    return firestore
        .collection('chats/${getConversationID(user.uid)}/messages/')
        .orderBy('sent_time', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      ChatUserProfile chatUserProfile, String content, Type type) async {
    try {
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final Message message = Message(
        sentTime: time,
        ToID: chatUserProfile.uid,
        type: type,
        SenderId: user.uid,
        content: content,
        readTime: '',
      );

      final ref = firestore.collection(
          'chats/${getConversationID(chatUserProfile.uid)}/messages/');

      await ref.doc(time).set(message.toJson());

      print('Message sent successfully: $content');
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  //update status of message
  static Future<void> updateMessStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.SenderId)}/messages')
        .doc(message.sentTime)
        .update(
            {'read_time': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMess(
      ChatUserProfile chatUserProfile) {
    return firestore
        .collection('chats/${getConversationID(chatUserProfile.uid)}/messages')
        .orderBy('sent_time', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.ToID)}/messages/')
        .doc(message.sentTime)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.content).delete();
    }
  }

  //image
  static Future<Uint8List?> getImage() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    // Specify the path (name) of the image in Firebase Storage
    final String imagePath =
        'images/${FirebaseAuth.instance.currentUser?.email}'; // Replace with your image path
    // Get the reference to the image
    final Reference imageRef = storage.ref().child(imagePath);
    // Load the downloaded image into a MemoryImage
    final Uint8List? imageBytes = await imageRef.getData();
    return imageBytes;
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Images Selected');
  }

  static Future<void> sendChatImage(
      ChatUserProfile chatUserProfile, File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child(
        'imagesChat/${getConversationID(chatUserProfile.uid)}/${DateTime.now().microsecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUserProfile, imageUrl, Type.image);
  }
}
