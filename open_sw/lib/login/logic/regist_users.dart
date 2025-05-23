import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> registUsers(
  String nickName,
  UserCredential user,
  String email,
  int age,
  String gender,
) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> userData = {
    "createdAt": FieldValue.serverTimestamp(),
    "nickName": nickName,
    "uid": uid,
    "friends": [],
    "groups": [],
    "likes": [],
    "email": email,
    "age": age,
    "gender": gender,
  };
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.user!.uid)
        .set(userData);
  } catch (e) {
    //print(e);
  }
}
