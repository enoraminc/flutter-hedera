import 'package:flutter/foundation.dart';

class Log {
  static void setLog(dynamic desc, {String method = "Log"}) {
    if (kDebugMode) {
      debugPrint("$method ==> $desc");
    }
  }
}
