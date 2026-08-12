import 'dart:convert';
import 'dart:typed_data';

import 'package:entao_bora/shared/errors/image_exception.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageHelper {
  static const maxFirestoreField = 1048487;

  static Future<String> fileToBase64(XFile file) async {
    var quality = 90;

    while (quality >= 20) {
      final bytes = await FlutterImageCompress.compressWithList(
        await file.readAsBytes(),
        quality: quality,
      );

      final base64 = base64Encode(bytes);

      if (base64.length < maxFirestoreField) {
        return base64;
      }

      quality -= 10;
    }

    throw ImageTooLargeException();
  }

  static Uint8List base64ToBytes(String base64) {
    return base64Decode(base64);
  }
}