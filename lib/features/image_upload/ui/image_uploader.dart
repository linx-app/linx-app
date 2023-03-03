import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/text.dart';
import 'package:permission_handler/permission_handler.dart';

final imagePickerProvider = Provider((ref) => ImagePicker());

class ImageUploader extends ConsumerWidget {
  final Function(File) onFilePicked;

  const ImageUploader(this.onFilePicked);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DottedBorder(
      borderPadding: const EdgeInsets.symmetric(horizontal: 7.5),
      color: LinxColors.black_30,
      strokeWidth: 2,
      dashPattern: [4, 4],
      strokeCap: StrokeCap.round,
      borderType: BorderType.RRect,
      radius: const Radius.circular(10),
      child: InkWell(
        onTap: () { onUploadFileClicked(ref); },
        child: Card(
          color: LinxColors.transparent,
          shadowColor: LinxColors.transparent,
          child: Container(
              alignment: Alignment.center,
              child: const Text(
                "Add media",
                style: LinxTextStyles.regular,
              )),
        ),
      ),
    );
  }

  void onUploadFileClicked(WidgetRef ref) async {
    var imagePicker = ref.read(imagePickerProvider);
    PermissionStatus permissionStatus;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      if (androidInfo.version.sdkInt <= 32) {
        await Permission.storage.request();
        permissionStatus = await Permission.photos.status;
      } else {
        await Permission.photos.request();
        permissionStatus = await Permission.photos.status;
      }
    } else {
      await Permission.photos.request();
      permissionStatus = await Permission.photos.status;
    }

    if (permissionStatus.isGranted || permissionStatus.isLimited) {
      var image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var file = File(image.path);
        print("$file");
        onFilePicked(file);
      }
    }
  }
}
