import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
export 'models/chat_message.dart';
export 'chat_storage_manager.dart';

import 'package:dumble/dumble.dart';
import 'package:opus_dart/opus_dart.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:palaemon_passenger_app/services/chat_service/chat_storage_manager.dart';
import 'package:path_provider/path_provider.dart';

import 'models/chat_message.dart';
import 'utils.dart';

class ChatService {
  final StreamController<ChatMessage> _chatController = StreamController<ChatMessage>.broadcast();

  Stream<ChatMessage> get stream => _chatController.stream;

  late List<ChatMessage> messages;
  ChatService() {
    ChatStorageManager.getChat().then((msgs) => messages = msgs);
    _chatController.stream.listen((message) {
      messages.add(message);
      ChatStorageManager.storeChat(messages);
    });
  }

  void onRawMessageReceived(String msgJson) {
    _onTextMessageReceived(msgJson, DateTime.now());
    // TODO Catch image messages...
  }

  void mockMessage() {
    _onTextMessageReceived("Hello", DateTime.now());
  }

  void _onTextMessageReceived(String contents, DateTime creationDate) {
    final msg = ChatMessage(contents: contents, type: MessageType.text, creationDate: creationDate);
    _chatController.add(msg);
  }

  void _onImageMessageReceived(String contents, DateTime creationDate) {
    final msg = ChatMessage(contents: contents, type: MessageType.image, creationDate: creationDate);
    _chatController.add(msg);
  }

  Future<void> _writeWavHeader(File file) async {
    RandomAccessFile r = await file.open(mode: FileMode.append);
    await r.setPosition(0);
    await r.writeFrom(wavHeader(
        channels: 1,
        sampleRate: 16000,
        fileSize: await file.length()));
  }

  Future<void> playAudioMessage(Stream<AudioFrame> input) async {
    const int sampleRate = 16000;
    const int channels = 1;
    // List<Uint8List> output = [];

    String dir = (await getApplicationDocumentsDirectory()).path;
    String filePath = "$dir/last.wav";
    File recfile = File(filePath);
    IOSink output = recfile.openWrite();
    output.add(Uint8List(wavHeaderSize));
    StreamOpusDecoder decoder = StreamOpusDecoder.bytes(floatOutput: false, sampleRate: sampleRate, channels: channels);
    // await input.map<Uint8List>((frame) => frame.frame).cast<Uint8List?>().transform(decoder).cast<List<int>>().pipe(output);
    await input.map<Uint8List>((frame) => frame.frame).cast<Uint8List?>().transform(decoder).cast<List<int>>().pipe(output);
    await output.close();
    await _writeWavHeader(recfile);


    final player = FlutterSoundPlayer();
    await player.openPlayer();
    await player.startPlayer(
      fromURI: filePath,
      codec: Codec.pcm16WAV,
      whenFinished: () {
        player.closePlayer();
      }
    );
    // player.state.addListener(() {
    //   if (player.state.value == PlayerState.ended){
    //     player.dispose();
    //   }
    // });
  }
}
