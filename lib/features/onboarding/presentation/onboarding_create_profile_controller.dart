import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/image_upload/domain/image_upload_service.dart';

class OnboardingCreateProfileController {
  final ProviderRef ref;

  static final provider =
      Provider((ref) => OnboardingCreateProfileController(ref: ref));

  ImageUploadService service() => ref.read(ImageUploadService.provider);

  final carouselPagesProvider =
      StateNotifierProvider<_ImageCarouselPagesNotifier, List<String?>>(
    (ref) => _ImageCarouselPagesNotifier(),
  );

  final carouselCurrentPage = StateProvider((ref) => 0);

  final PageController carouselController = PageController(viewportFraction: 0.90);
  final TextEditingController bioController = TextEditingController();


  OnboardingCreateProfileController({required this.ref});

  Future<void> onFileSelected(File file) async {
    var length = ref.read(carouselPagesProvider).length;
    var imageName = "profile_image_${length - 1}";
    ref.read(carouselPagesProvider.notifier).addLoading();
    var url = await service().uploadImage(file, imageName);
    if (url != null) {
      ref.read(carouselPagesProvider.notifier).replaceLoading(url);
    }
  }
}

class _ImageCarouselPagesNotifier extends StateNotifier<List<String?>> {
  _ImageCarouselPagesNotifier()
      : super([
          "https://picsum.photos/200/300",
          "https://picsum.photos/200/300",
          null
        ]);

  void addUrl(String url) {
    state = [...state.sublist(0, state.length - 1), url, null];
  }

  void addLoading() {
    state = [...state.sublist(0, state.length - 1), "Loading", null];
  }

  void replaceLoading(String url) {
    state = [
      for (final String? link in state)
        if (link == "Loading") url else link
    ];
  }

  void removeUrl(String url) {
    state = [
      for (final String? link in state)
        if (link != url) link,
    ];
  }
}
