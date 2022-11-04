import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dumble/dumble.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:palaemon_passenger_app/services/chat_service/chat_service.dart';

import '../../services/mumble_service.dart';

part 'mumble_event.dart';
part 'mumble_state.dart';

typedef MessageReceivedFn = void Function(IncomingTextMessage msg);
typedef PlayAudioFn = void Function(Stream<AudioFrame> input);
typedef ChannelChangeFn = void Function(Channel newChannel);

class IncomingAudioListener with AudioListener {
  final PlayAudioFn onPlayAudio;


  IncomingAudioListener({required this.onPlayAudio});

  @override
  void onAudioReceived(Stream<AudioFrame> voiceData, AudioCodec codec, User? speaker, TalkMode talkMode) {
    onPlayAudio(voiceData);
  }

}

class ConnectionListener with MumbleClientListener {
  final Function onDisconnect;
  final Function? onConnect;
  final MessageReceivedFn onMessageReceived;

  ConnectionListener({required this.onDisconnect, required this.onMessageReceived, this.onConnect});

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
    onDisconnect();
  }

  @override
  void onDropAllChannelPermissions() {
    // TODO: implement onDropAllChannelPermissions
  }

  @override
  void onError(Object error, [StackTrace? stackTrace]) {
    onDisconnect();
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
  final MumbleService mumbleService;
  final ChatService chatService;
  bool _isInitialized = false;

  MumbleBloc({required this.mumbleService, required this.chatService}) : super(Disconnected()) {
    on<Connect>((event, emit) async {
      emit(Connecting());
      await mumbleService.connect();
      if (!_isInitialized) {
        mumbleService.addCallback(ConnectionListener(onDisconnect: () async {
          await FlutterBackground.disableBackgroundExecution();
          emit(Disconnected());
        }, onMessageReceived: (IncomingTextMessage message) {

          chatService.onRawMessageReceived(message.message);
        }
        ));
        mumbleService.client!.audio.add(IncomingAudioListener(onPlayAudio: (stream) {
          chatService.playAudioMessage(stream);
        }));
        _isInitialized = true;
      }
      await FlutterBackground.enableBackgroundExecution();
      emit(Connected());
    });
  }
}
