import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/models/message.dart';
import '../models/chat_user.dart';

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
        address: '',
        isActive: false,
        lastSeen: time,
        phone: user.phoneNumber.toString(),
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

  //ChatMess

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMess(
      ChatUserProfile user) {
    return firestore
        .collection('chats/${getConversationID(user.uid)}/messages/')
        .snapshots();
  }

  static Future<void> sendMessage(
      ChatUserProfile chatUserProfile, String content) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
        sentTime: time,
        ToID: chatUserProfile.uid,
        type: Type.text,
        SenderId: user.uid,
        content: content,
        readTime: '');
    final ref = firestore.collection(
        'chats/${getConversationID(chatUserProfile.uid)}/messages/');
    await ref.doc(time).set(message.toJson());
  }
}
