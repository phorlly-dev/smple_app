import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Funcs {
  //image path
  static var imagePath = "";
  static final picker = ImagePicker();
  static final formKey = GlobalKey<FormState>();

  static dateTimeFormat(DateTime value) {
    return DateFormat('dd/MM/yyyy, hh:mm a').format(value);
  }

  static bool isSameMinute(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day &&
        a.hour == b.hour &&
        a.minute == b.minute;
  }

  //for choosing the file to upload
  static Future<String> showFile({isGallery = true}) async {
    // Pick an image.
    final image = await picker.pickImage(
      source: isGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 70,
    );

    if (image != null) {
      // print("Image path: ${image.path} --MimeType: ${image.mimeType}");
      imagePath = image.path;
    }

    return imagePath;
  }

  static String numToStr(int key) {
    return key.toString().padLeft(2, '0');
  }
}
