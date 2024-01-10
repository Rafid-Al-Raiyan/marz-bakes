import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageServices {
  // FirebaseStorage _storage = FirebaseStorage.instance;

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  uploadItemPhoto(File file) async {
    final ref = firebaseStorage.ref("Products/${idGenerator()}/");
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
