import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/firebase/firebase_providers.dart';

class ImageUploadRepository {
  final ProviderRef<ImageUploadRepository> _ref;

  ImageUploadRepository(this._ref);

  static final provider =
      Provider<ImageUploadRepository>((ref) => ImageUploadRepository(ref));

  FirebaseStorage storage() => _ref.read(firebaseStorageProvider);

  Future<String> uploadImage(String uid, File image, String imageName) async {
    var snapshot = await storage().ref().child("images/$uid/$imageName").putFile(image);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
