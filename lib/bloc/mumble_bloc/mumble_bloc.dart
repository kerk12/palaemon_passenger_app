import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dumble/dumble.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:palaemon_passenger_app/services/chat_service/chat_service.dart';
import 'package:palaemon_passenger_app/services/notification_service.dart';

import '../../services/mumble_service.dart';

part 'mumble_event.dart';
part 'mumble_state.dart';

typedef MessageReceivedFn = void Function(IncomingTextMessage msg);
typedef PlayAudioFn = void Function(Stream<AudioFrame> input);
typedef ChannelChangeFn = void Function(Channel newChannel);
typedef DisconnectFn = void Function({bool retry});

class IncomingAudioListener with AudioListener {
  final PlayAudioFn onPlayAudio;

  IncomingAudioListener({required this.onPlayAudio});

  @override
  void onAudioReceived(Stream<AudioFrame> voiceData, AudioCodec codec,
      User? speaker, TalkMode talkMode) {
    onPlayAudio(voiceData);
  }
}

class ConnectionListener with MumbleClientListener {
  final DisconnectFn onDisconnect;
  final Function? onConnect;
  final MessageReceivedFn onMessageReceived;

  ConnectionListener(
      {required this.onDisconnect,
      required this.onMessageReceived,
      this.onConnect});

  @override
  void onBanListReceived(List<BanEntry> bans) {
    // TODO: implement onBanListReceived
  }

  @override
  void onChannelAdded(Channel channel) {
    // TODO: implement onChannelAdded
  }

  @override
  void onCryptStateChanged() {
    // TODO: implement onCryptStateChanged
  }

  @override
  void onDone() {
    onDisconnect(retry: true);
  }

  @override
  void onDropAllChannelPermissions() {
    // TODO: implement onDropAllChannelPermissions
  }

  @override
  void onError(Object error, [StackTrace? stackTrace]) {
    onDisconnect(retry: true);
  }

  @override
  void onPermissionDenied(PermissionDeniedException e) {
    // TODO: implement onPermissionDenied
  }

  @override
  void onQueryUsersResult(Map<int, String> idToName) {
    // TODO: implement onQueryUsersResult
  }

  @override
  void onTextMessage(IncomingTextMessage message) {
    onMessageReceived(message);
  }

  @override
  void onUserAdded(User user) {
    // TODO: implement onUserAdded
  }

  @override
  void onUserListReceived(List<RegisteredUser> users) {
    // TODO: implement onUserListReceived
  }
}

class MumbleBloc extends Bloc<MumbleEvent, MumbleState> {
  final NotificationService notificationService;
  final MumbleService mumbleService;
  final ChatService chatService;
  bool _isInitialized = false;
  bool _disconnectNotifShown = false;

  void reset() {
    mumbleService.reset();
    _isInitialized = false;
  }

  void onDisconnected({bool retry = false}) {
    add(Disconnect(retry));
  }

  MumbleBloc({required this.mumbleService, required this.chatService, required this.notificationService})
      : super(Disconnected()) {
    on<Disconnect>((event, emit) async {
      if (!_disconnectNotifShown) {
        // Set the bool notification at the end so that the notification doesn't appear again and again.
        notificationService.showNotification(title: "Disconnected from the PALAEMON Network", msg: "You have been disconnected from the PALAEMON network. The device will come back online as soon as service is resumed.").then((_) => _disconnectNotifShown = true);
      }
      emit(Disconnected());
      log("Connection to Mumble Server lost.");
      if (event.retry) {
        log("Reconnecting in 2 seconds...");
        await Future.delayed(const Duration(seconds: 2));
        reset();
        add(Connect());
      }
    });
    on<Connect>((event, emit) async {
      emit(Connecting());
      try {
        await mumbleService.connect();
      } on SocketException {
        onDisconnected(retry: true);
        return;
      }
      if (!_isInitialized) {
        // Add a message and connection listener.
        mumbleService.addCallback(ConnectionListener(
            onDisconnect: onDisconnected,
            onMessageReceived: (IncomingTextMessage message) {
              chatService.onRawMessageReceived(message.message);
            }));
        mumbleService.client!.audio
            .add(IncomingAudioListener(onPlayAudio: (stream) {
          chatService.playAudioMessage(stream);
        }));
        _isInitialized = true;
      }

      // When the connection is restored, show a back online notif.
      if (_disconnectNotifShown) {
        notificationService.showNotification(title: "Back Online", msg: "You have been reconnected to the PALAEMON network.")
            .then((_) => _disconnectNotifShown = false);
      }
      emit(Connected());
    });
  }
}
