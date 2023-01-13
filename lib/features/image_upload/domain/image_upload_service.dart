import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/data/session_repository.dart';
import 'package:linx/features/image_upload/data/image_upload_repository.dart';

class ImageUploadService {
  final ProviderRef<ImageUploadService> _ref;

  ImageUploadService(this._ref);

  static final provider =
      Provider<ImageUploadService>((ref) => ImageUploadService(ref));

  ImageUploadRepository imageUploadRepository() =>
      _ref.read(ImageUploadRepository.provider);

  SessionRepository sessionRepository() =>
      _ref.read(SessionRepository.provider);

  Future<String?> uploadImage(File image, String imageName) async {
    var uid = await sessionRepository().getUserId();
    return await imageUploadRepository().uploadImage(uid, image, imageName);
  }
}
