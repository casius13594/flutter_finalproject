import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  //log in - verfication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //access the firebase
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
}
