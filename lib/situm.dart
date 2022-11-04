import 'package:flutter/services.dart';


class Situm {
  static const _situmChannel = MethodChannel("palaemon.situm");

  static Future<void> configure({required String email, required String apiKey}) async {
    await _situmChannel.invokeMethod("configure", {
      "email": email,
      "api_key": apiKey
    });
  }

  static Future<void> start() async{
    await _situmChannel.invokeMethod("start");
  }

  static Future<void> disconnect() async {
    await _situmChannel.invokeMethod("disconnect");
  }
}