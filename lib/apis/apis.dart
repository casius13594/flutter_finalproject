import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_user.dart';

class APIs {
  //log in - verfication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //access the firebase
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;
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
        lastMess: "Welcome to Chat Box");
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
}
