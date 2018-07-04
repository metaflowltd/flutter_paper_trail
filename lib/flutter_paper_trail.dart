import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPaperTrail {
  static const MethodChannel _channel =
      const MethodChannel('flutter_paper_trail');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
