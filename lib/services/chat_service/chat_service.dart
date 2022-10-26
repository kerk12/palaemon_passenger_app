import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
export 'models/chat_message.dart';
export 'chat_storage_manager.dart';

import 'package:dumble/dumble.dart';
import 'package:opus_dart/opus_dart.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:palaemon_passenger_app/services/chat_service/chat_storage_manager.dart';
import 'package:palaemon_passenger_app/services/mumble_service.dart';
import 'package:palaemon_passenger_app/services/notification_service.dart';
import 'package:path_provider/path_provider.dart';

import 'models/chat_message.dart';
import 'utils.dart';

class ChatService {
  final StreamController<ChatMessage> _chatController = StreamController<ChatMessage>.broadcast();
  FlutterSoundPlayer? player;
  Stream<ChatMessage> get stream => _chatController.stream;
  final NotificationService notificationService;

  Future<String> getLastVoiceMsgFilePath() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return "$dir/last.wav";
  }

  Future<bool> hasLastVoiceMsg() async {
    File f = File(await getLastVoiceMsgFilePath());
    return await f.exists();
  }

  Future<void> playLastVoiceMsg() async {
    if (player != null) {
      player!.closePlayer();
      player = null;
    }
    player = FlutterSoundPlayer();
    await player!.openPlayer();
    await player!.startPlayer(
        fromURI: await getLastVoiceMsgFilePath(),
        codec: Codec.pcm16WAV,
        whenFinished: () {
          player!.closePlayer();
        }
    );
  }

  late List<ChatMessage> messages;
  ChatService({required this.notificationService}) {
    ChatStorageManager.getChat().then((msgs) => messages = msgs);
    _chatController.stream.listen((message) {
      messages.add(message);
      if (message.origin != MessageOrigin.me) {
        notificationService.showNotification(title: "New EC Message",
            msg: "You have received a new message from the Bridge!");
      }
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

  static ChatMessage createSelfSentMessage(String msg) =>
    ChatMessage(contents: msg, type: MessageType.text, creationDate: DateTime.now(), origin: MessageOrigin.me);

  void addMessageToStream(ChatMessage message) =>
    _chatController.add(message);


  void _onTextMessageReceived(String contents, DateTime creationDate) {
    final msg = ChatMessage(contents: contents, type: MessageType.text, creationDate: creationDate, origin: MessageOrigin.other);
    addMessageToStream(msg);
  }

  void _onImageMessageReceived(String contents, DateTime creationDate) {
    final msg = ChatMessage(contents: contents, type: MessageType.image, creationDate: creationDate, origin: MessageOrigin.other);
    addMessageToStream(msg);
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
    String filePath = await getLastVoiceMsgFilePath();
    File recfile = File(filePath);
    IOSink output = recfile.openWrite();
    output.add(Uint8List(wavHeaderSize));
    StreamOpusDecoder decoder = StreamOpusDecoder.bytes(floatOutput: false, sampleRate: sampleRate, channels: channels);
    // await input.map<Uint8List>((frame) => frame.frame).cast<Uint8List?>().transform(decoder).cast<List<int>>().pipe(output);
    await input.map<Uint8List>((frame) => frame.frame).cast<Uint8List?>().transform(decoder).cast<List<int>>().pipe(output);
    await output.close();
    await _writeWavHeader(recfile);

    playLastVoiceMsg();
  }

  final int inputSampleRate = 16000;
  final int frameTimeMs = 40; // use frames of 40ms
  final FrameTime frameTime = FrameTime.ms40;

  Stream<List<int>> simulateAudioRecording(File input) async* {
    // Copy-pasted from the official dumble example.
    int frameByteSize = (inputSampleRate ~/ 1000) *
        frameTimeMs *
        1 *  // channels
        2;  // Bytes per sample
    Uint8List? buffer;
    int bufferIndex = 0;
    await for (Uint8List bytes
    in input.openRead().cast<Uint8List>()) {
      int consumed = 0;
      while (consumed < bytes.length) {
        if (buffer == null && frameByteSize <= (bytes.length - consumed)) {
          yield bytes.buffer.asUint8List(consumed, frameByteSize);
          consumed += frameByteSize;
        } else if (buffer == null) {
          buffer = Uint8List(frameByteSize);
          bufferIndex = 0;
        } else {
          int read = min(frameByteSize - bufferIndex, bytes.length - consumed);
          buffer.setRange(bufferIndex, bufferIndex + read, bytes, consumed);
          consumed += read;
          bufferIndex += read;
          if (bufferIndex == frameByteSize) {
            yield buffer;
            buffer = null;
          }
        }
      }
    }
  }

  Future<void> sendVoiceMessage(File input, MumbleService service) async {
    final StreamOpusEncoder<int> encoder = StreamOpusEncoder.bytes(
      frameTime: frameTime,
      floatInput: false,
      sampleRate: 16000,
      channels: 1,
      application: Application.voip
    );
    AudioFrameSink output = service.client!.audio.sendAudio(codec: AudioCodec.opus);

    await simulateAudioRecording(input).asyncMap((List<int> bytes) async {
      await Future.delayed(
          Duration(milliseconds: frameTimeMs - 17));
      return bytes;
    })
    .transform(encoder)
    .map((Uint8List audioBytes) => AudioFrame.outgoing(frame: audioBytes))
    .pipe(output);
  }
}
