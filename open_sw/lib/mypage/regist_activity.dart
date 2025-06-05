import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:open_sw/mypage/recent_activity.dart';

Future<String> registActivity(Activity act) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> activityData = {
    "createdAt": FieldValue.serverTimestamp(),
    "date": act.date,
    "groupId": act.groupId,
    "placeName": act.placeName,
    "score": act.score,
    "type": act.type,
    "userId": uid,
  };
  try {
    DocumentReference activityRef = await FirebaseFirestore.instance
        .collection('activities')
        .add(activityData);
    String activityId = activityRef.id;

    // 3. 내 user 문서의 groups 배열에 groupId 추가
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'groups': FieldValue.arrayUnion([activityId]),
    });
    return activityId;
  } catch (e) {
    //print(e);
    throw Exception('Failed to register group: $e');
  }
}
