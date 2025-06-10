import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_sw/mypage/recent_activity.dart';

Future<String> registActivity(Activity act) async {
  //String uid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> activityData = {
    "createdAt": FieldValue.serverTimestamp(),
    "date": act.date,
    "groupId": act.groupId,
    //"placeName": act.placeName,//받아온 활동
    "place": act.place,
    "score": act.score,
    "type": act.type,
    "userId": act.userId,
  };

  try {
    DocumentReference activityRef = await FirebaseFirestore.instance
        .collection('activities')
        .add(activityData);
    String activityId = activityRef.id;

    for (var userDoc in act.userId) {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userDoc)
              .get();
      if (userSnapshot.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc)
            .update({
              'activities': FieldValue.arrayUnion([activityId]),
            });
      }
    }

    await FirebaseFirestore.instance
        .collection('groups')
        .doc(act.groupId)
        .update({
          'activities': FieldValue.arrayUnion([activityId]),
        });

    return activityId;
  } catch (e) {
    //print(e);
    throw Exception('Failed to register activity: $e');
  }
}
