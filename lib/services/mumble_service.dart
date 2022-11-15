import 'dart:io';

import 'package:dumble/dumble.dart';
import 'package:palaemon_passenger_app/config.dart';
import 'package:palaemon_passenger_app/models/user.dart' as PalaemonUser;
import 'package:palaemon_passenger_app/services/chat_service/chat_service.dart';
import 'package:palaemon_passenger_app/services/mumble_service/listeners.dart';

class MumbleService {
  MumbleClient? client;
  late PalaemonUser.User user;
  late ConnectionOptions _connectionOptions;
  User? evacAssistantUser;

  void addCallback(MumbleClientListener callback) {
    client!.add(callback);
  }

  void reset() {
    client = null;
  }

  void sendMessage(ChatMessage message,
      {List<User>? users, List<Channel>? channels}) {
    if (users != null) {
      client?.sendMessage(
          message:
              OutgoingTextMessage(message: message.contents, clients: users));
    } else if (channels != null) {
      client?.sendMessage(
          message: OutgoingTextMessage(
              channels: channels, message: message.contents));
    } else {
      client?.sendMessage(
          message: OutgoingTextMessage(
              channels: [client!.self.channel], message: message.contents));
    }
  }

  bool get isConnected => client != null;

  MumbleService({required this.user, required Config config})
      : _connectionOptions = ConnectionOptions(
            host: config.mumbleServer, port: config.mumblePort, name: user.mumbleName);

  User? _updateEvacAssistantUser() {
    for (User user in client!.getUsers().values) {
      if (user.name == "pameas_evacuation_assistant") {
        return user;
      }
    }
    return null;
  }

  Future<MumbleClient?> connect() async {
    if (client != null) {
      return null;
    }
    client = await MumbleClient.connect(
      options: _connectionOptions,
      onBadCertificate: (X509Certificate cert) => true,
    );
    // Add the evacuation assistant user listener.
    final evacAssistantListener = EvacAssistantUserListener(
        onEvacAssistantChange: (User? newAssistant) {
          evacAssistantUser = newAssistant;
        },
        client: client!);
    client!.add(evacAssistantListener);
    client!.getUsers().values.forEach((u) => u.add(evacAssistantListener));
    evacAssistantUser = _updateEvacAssistantUser();
    print(client!.getChannels());
    print(client!.getUsers());
    return client;
  }
}
