import 'package:flutter/services.dart';

class SitumError implements Exception {
  final String cause;
  SitumError({required this.cause});
}

/// Provides an abstraction layer to the Situm Android and iOS (not implemented yet) SDK.
/// Provides navigation inside closed spaces (buildings).
class Situm {
  static const _situmChannel = MethodChannel("palaemon.situm");
  static final Situm _instance = Situm._internal();

  Situm._internal();

  factory Situm() {
    return _instance;
  }

  bool _configured = false;

  bool get isConfigured => _configured;

  /// Configures the SDK with the given credentials.
  Future<void> configure({required email, required apiKey}) async {
    await _situmChannel
        .invokeMethod("configure", {"email": email, "api_key": apiKey});
    _configured = true;
  }

  /// Initiates the Situm connection. Make sure to call [configure] before calling [start].
  Future<void> start() async {
    if (!_configured) {
      throw SitumError(
          cause:
              "Situm hasn't been configured yet. Did you forget to call .configure()?");
    }
    await _situmChannel.invokeMethod("start");
  }

  /// Disconnects from the Situm SDK.
  Future<void> disconnect() async {
    await _situmChannel.invokeMethod("disconnect");
  }
}
