import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:palaemon_passenger_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

class AuthService {
  static const String _userJsonKey = "logged_in_user";
  final Map<String, dynamic> authHeaders;
  final Map<String, String> authCookies;
  Dio client;
  late String authToken;
  final String authServer, baseUrl, clientSecret;

  AuthService(
      {required this.baseUrl,
      required this.authHeaders,
      required this.authCookies,
      required this.authServer,
      required this.clientSecret})
      : client = Dio(BaseOptions(baseUrl: baseUrl));

  Future<User?> loginWithExistingCredentials() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_userJsonKey)) return null;

    final user = User.fromJson(
        jsonDecode(prefs.getString(_userJsonKey)!) as Map<String, dynamic>);
    return user;
  }

  Future<String> _authenticate() async {
    final response = await Dio().post(
      authServer,
      options: Options(
          contentType: "application/x-www-form-urlencoded",
          headers: authHeaders),
      data: {
        "client_id": "palaemonRegistration",
        "client_secret": clientSecret,
        "grant_type": "client_credentials",
        "scope": "openid"
      },
    );

    authToken = response.data["access_token"];
    client = Dio(BaseOptions(
        baseUrl: baseUrl, headers: {"Authorization": "Bearer $authToken"}));

    return authToken;
  }

  Future<User> registerToPersonsServer(String mumbleUsername) async {
    authToken = await _authenticate();

    final response;
    try {
      response = await client.post("registerDevice", data: {
        "macAddress": "58:37:8B:DE:42:B4",
        "imsi": "470040123456789",
        "imei": "449244690297679",
        "mumbleName": mumbleUsername
      });
    } on Exception {}

    // if (response.statusCode == 200) {
    final user = User(mumbleName: mumbleUsername);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_userJsonKey, jsonEncode(user.toJson()));
    return user;
    // }
    // throw Error();
  }
}
