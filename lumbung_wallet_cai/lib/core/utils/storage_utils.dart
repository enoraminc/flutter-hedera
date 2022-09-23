import 'dart:typed_data';

import 'package:hedera_core/utils/log.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageUtils {
  static Future<String> uploadPhoto(Uint8List photo,
      [String extension = 'png']) async {
    final storage = FirebaseStorage.instance;
    final fileName =
        DateTime.now().millisecondsSinceEpoch.toString() + '.' + extension;
    final ref = storage.ref('content/images/$fileName');
    final task = await ref.putData(photo);
    final output = await task.ref.getDownloadURL();
    return output;
  }

  static Future<String> uploadMediaMessage(Uint8List photo,
      [String extension = 'png']) async {
    try {
      final storage = FirebaseStorage.instance;
      final fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + '.' + extension;
      final ref = storage.ref('content/message_image/$fileName');
      final task = await ref.putData(photo);
      final output = await task.ref.getDownloadURL();
      return output;
    } catch (e, s) {
      Log.setLog(e.toString(), method: "uploadMediaMessage");
      rethrow;
    }
  }
}
