import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:palaemon_passenger_app/models/user.dart';
import 'package:palaemon_passenger_app/situm/situm.dart';
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

  String _getRandomMacAddressSegment() {
    var random = Random();
    const chars = "ABCDEF1234567890";
    return List.generate(2, (index) => chars[random.nextInt(chars.length) - 1]).toList(growable: false).join("");
  }

  String _getRandomMacAddress() {
    return List.generate(6, (index) => _getRandomMacAddressSegment()).toList().join(":");
  }

  Future<User> registerToPersonsServer(Config config, String mumbleUsername) async {
    authToken = await _authenticate();

    final situmSdk = Situm();
    if (!config.isSitumDisabled) {
      await situmSdk.configure(email: config.situmEmail, apiKey: config.situmPassword);
    }

    final response;
    try {
      response = await client.post("registerDevice", data: {
        "macAddress": _getRandomMacAddress(),
        if (!config.isSitumDisabled)
          "deviceID": await situmSdk.getDeviceID(),
        // "imsi": "470040123456789",
        // "imei": "449244690297679",
        "ticketNumber": mumbleUsername
      });
    } on Exception catch (e, stacktrace) {
      dev.log(stacktrace.toString());
    }

    // if (response.statusCode == 200) {
    final user = User(mumbleName: mumbleUsername);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_userJsonKey, jsonEncode(user.toJson()));
    return user;
    // }
    // throw Error();
  }
}
