import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file, String path) async {
    final ref = storage.ref(path);
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}


