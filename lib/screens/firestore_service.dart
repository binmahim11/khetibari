import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set(
      data,
      SetOptions(merge: true),
    );
  }

  Future<void> saveCropBatch(String uid, Map<String, dynamic> batch) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('batches')
        .add(batch);
  }
}


