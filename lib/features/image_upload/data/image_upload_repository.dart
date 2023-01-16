import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/firebase/firebase_providers.dart';

class ImageUploadRepository {
  static final provider = Provider<ImageUploadRepository>((ref) {
    return ImageUploadRepository(ref.read(firebaseStorageProvider));
  });

  final FirebaseStorage _storage;

  ImageUploadRepository(this._storage);

  Future<String> uploadImage(String uid, File image, String imageName) async {
    var snapshot = await _storage.ref().child("images/$uid/$imageName").putFile(image);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
