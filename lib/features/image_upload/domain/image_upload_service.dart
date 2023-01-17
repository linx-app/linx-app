import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/data/session_repository.dart';
import 'package:linx/features/image_upload/data/image_upload_repository.dart';

class ImageUploadService {
  static final provider = Provider<ImageUploadService>((ref) {
    return ImageUploadService(
        ref.read(ImageUploadRepository.provider),
        ref.read(SessionRepository.provider)
    );
  });

  final ImageUploadRepository _imageUploadRepository;
  final SessionRepository _sessionRepository;

  ImageUploadService(this._imageUploadRepository, this._sessionRepository);

  Future<String?> uploadImage(File image, String imageName) async {
    var uid = await _sessionRepository.getUserId();
    return await _imageUploadRepository.uploadImage(uid, image, imageName);
  }
}
