import 'package:flutter/services.dart';
import 'package:situm_flutter_wayfinding/situm_flutter_sdk.dart';

class SitumError implements Exception {
  final String cause;
  SitumError({required this.cause});
}

/// Provides an abstraction layer to the Situm Android and iOS (not implemented yet) SDK.
/// Provides navigation inside closed spaces (buildings).
class Situm {
  static const _situmChannel = MethodChannel("palaemon.situm");
  static final Situm _instance = Situm._internal();
  SitumFlutterSDK situmFlutterSdk;

  Situm._internal() : this.situmFlutterSdk = SitumFlutterSDK();

  factory Situm() {
    return _instance;
  }

  bool _configured = false, _running = false;

  bool get isConfigured => _configured;
  bool get isRunning => _running;

  /// Configures the SDK with the given credentials.
  Future<void> configure({required email, required apiKey}) async {
    situmFlutterSdk.init(email, apiKey);
    situmFlutterSdk
        .setConfiguration(ConfigurationOptions(useRemoteConfig: true));
    _configured = true;
  }

  /// Initiates the Situm connection. Make sure to call [configure] before calling [start].
  Future<void> start(LocationListener locationListener,
      {Map<String, dynamic> locationRequest = const {}}) async {
    if (!_configured) {
      throw SitumError(
          cause:
              "Situm hasn't been configured yet. Did you forget to call .configure()?");
    }
    await situmFlutterSdk.requestLocationUpdates(
        locationListener, locationRequest);
  }

  /// Disconnects from the Situm SDK.
  Future<void> disconnect() async {
    if (!isRunning) {
      throw SitumError(cause: "Situm isn't requesting location updates.");
    }
    await situmFlutterSdk.removeUpdates();
    _running = false;
  }

  Future<int> getDeviceID() async {
    return await situmFlutterSdk.getDeviceID();
  }
}
