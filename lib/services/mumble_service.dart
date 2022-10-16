import 'dart:io';

import 'package:dumble/dumble.dart';
import 'package:palaemon_passenger_app/config.dart';
import 'package:palaemon_passenger_app/models/user.dart' as PalaemonUser;

class MumbleService {
  MumbleClient? client;
  late PalaemonUser.User user;
  late ConnectionOptions _connectionOptions;

  void addCallback(MumbleClientListener callback) {
    client!.add(callback);
  }

  bool get isConnected => client != null;

  MumbleService({required this.user, required Config config}) :
      _connectionOptions = ConnectionOptions(host: config.mumbleServer, port: 64738, name: user.mumbleName);

  Future<MumbleClient?> connect() async {
    if (client != null) {
      return null;
    }
    client = await MumbleClient.connect(
      options: _connectionOptions,
      onBadCertificate: (X509Certificate cert) => true,
    );
    print(client!.getChannels());
    print(client!.getUsers());
    return client;
    
  }


}