import 'package:dio/dio.dart';

class Logger {
  static final Dio _client = Dio();
  static final bool _loggingEnabled = false;
  static Future<void> log(String contents) async {
    if (!_loggingEnabled) {
      return;
    }

    await _client.post("/entry/", data: {
      "contents": contents,
      "category": "PASSENGER_APP"
    });
  }
}