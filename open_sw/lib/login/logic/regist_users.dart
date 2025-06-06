import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> registUsers(
  String nickName,
  UserCredential? user,
  String? email,
  int age,
  String gender,
  bool isManualAdd,
) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> userData = {
    "activities": [],
    "age": age,
    "createdAt": FieldValue.serverTimestamp(),
    "email": email,
    "friends": [],
    "gender": gender,
    "groups": [],
    "likes": [],
    "nickName": nickName,
    "uid": uid,
  };
  if (isManualAdd) {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('users')
        .add(userData);
    String uid = docRef.id;
    return uid;
  }

  try {
    if (user == null) {
      throw Exception('User is not authenticated');
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.user!.uid)
        .set(userData);
  } catch (e) {
    //print(e);
  }
}
