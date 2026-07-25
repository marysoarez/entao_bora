import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageHelper {
  static Future<String> fileToBase64(XFile file) async {
    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    }

    final bytes = await FlutterImageCompress.compressWithFile(
      file.path,
      minWidth: 800,
      minHeight: 800,
      quality: 65,
      format: CompressFormat.jpeg,
    );

    if (bytes == null) {
      throw Exception('Não foi possível comprimir a imagem.');
    }

    return base64Encode(bytes);
  }

  static Uint8List base64ToBytes(String base64) {
    return base64Decode(base64);
  }
}