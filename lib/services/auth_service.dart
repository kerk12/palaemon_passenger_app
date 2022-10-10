import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:palaemon_passenger_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

class AuthService {
  static const String _userJsonKey = "logged_in_user";
  Dio client = Dio(BaseOptions(
    baseUrl: Config.personManagementServer
  ));

  Future<User?> loginWithExistingCredentials() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final user = User.fromJson(
          jsonDecode(prefs.getString(_userJsonKey)!) as Map<String, dynamic>);
      return user;
    } on Exception {
      return null;
    }
  }

  Future<User> registerToPersonsServer(String mumbleUsername) async {
    final response = await this.client.post("registerDevice", data: {
      "macAddress": "asdf",
      "imsi": "asdf",
      "imei": "asdf",
      "mumbleName": mumbleUsername
    });

    if (response.statusCode == 200 && response.data["status"] == "ok") {
      final user = User(mumbleName: mumbleUsername);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_userJsonKey, jsonEncode(user.toJson()));
      return user;
    }
    throw Error();
  }
}
