
import 'package:cloud_firestore/cloud_firestore.dart';

fetchUserData(userUid) async {
  DocumentSnapshot<Map<String, dynamic>> userData =
  await FirebaseFirestore.instance.collection('customers').doc(userUid).get();
  if (userData.exists) {
    return userData;
  } else {
    return '-1';
  }
}

updateUserDetails(key, value, uid) async {
  await FirebaseFirestore.instance.collection('customers').doc(uid).update(
    {
      key: value,
    },
  );
}