import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> registGroup() async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> gropuData = {
    "createdAt": FieldValue.serverTimestamp(),
    "groupName": "새 그룹",
    "leader": uid,
    "members": [],
    "activities": [],
  };
  try {
    DocumentReference groupRef = await FirebaseFirestore.instance
        .collection('groups')
        .add(gropuData);
    String groupId = groupRef.id;

    // 3. 내 user 문서의 groups 배열에 groupId 추가
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'groups': FieldValue.arrayUnion([groupId]),
    });
    return groupId;
  } catch (e) {
    //print(e);
    throw Exception('Failed to register group: $e');
  }
}
