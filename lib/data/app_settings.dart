import 'package:flutter/foundation.dart';

class AppSettings {
  static int get characterLimit {
    if (kIsWeb) {
      return 200;
    }
    return 1000;
  }
}