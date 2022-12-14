import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palaemon_passenger_app/services/chat_service/chat_service.dart';
import 'package:record/record.dart';

import '../../../services/mumble_service.dart';

class VoiceRecordButton extends StatefulWidget {
  const VoiceRecordButton({Key? key}) : super(key: key);

  @override
  State<VoiceRecordButton> createState() => _VoiceRecordButtonState();
}

class _VoiceRecordButtonState extends State<VoiceRecordButton> {
  final _recorder = Record();
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  late ChatService chatService;
  late MumbleService mumbleService;

  @override
  void initState() {
    chatService = context.read<ChatService>();
    mumbleService = context.read<MumbleService>();

    _recordSub = _recorder.onStateChanged().listen((recordState) {
      setState(() {
        _recordState = recordState;
      });
    });
    super.initState();
  }

  Future<void> _startRecording() async {
    if (await _recorder.hasPermission()) {
      // We don't do anything with this but printing
      if (!await _recorder.isEncoderSupported(
        AudioEncoder.pcm16bit,
      )) {
        print("PCM16 not supported...");
        return;
      }

      await _recorder.start(encoder: AudioEncoder.pcm16bit, samplingRate: 16000, numChannels: 1);
    }
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop();
    File input = File(path!);
    chatService.sendVoiceMessage(input, mumbleService);
  }

  @override
  Widget build(BuildContext context) {
    return  IconButton(onPressed: () {
        _recordState == RecordState.stop ? _startRecording() : _stopRecording();
        _recordState == RecordState.record ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Voice Message Sent Successfully!"),
        )):null;
    },
      icon: _recordState == RecordState.stop ? const Icon(Icons.mic) : const Icon(Icons.stop_circle),
      color: _recordState == RecordState.stop ? const Color(0xff1F9AD6):Colors.red,
      iconSize: 35);


    // This below widget is another way of displaying the record button. If you want
    // to use it change the chat_screen file as it is described.

    //   ElevatedButton.icon(
    //   onPressed: () {
    //     _recordState == RecordState.stop ? _startRecording() : _stopRecording();
    //   },
    //   style: ElevatedButton.styleFrom(
    //     backgroundColor: _recordState == RecordState.stop ?
    //         Colors.green : Colors.red,
    //     minimumSize: const Size.fromHeight(40)
    //   ),
    //   icon: const Icon(Icons.record_voice_over),
    //   label: _recordState == RecordState.stop
    //       ? const Text("Record")
    //       : const Text("Stop"),
    // );

  }
}
