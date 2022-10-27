import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palaemon_passenger_app/screens/chat_screen/widgets/chat_log.dart';
import 'package:palaemon_passenger_app/screens/chat_screen/widgets/voice_record_button.dart';
import 'package:palaemon_passenger_app/screens/chat_screen/widgets/message_send_button.dart';
import 'package:palaemon_passenger_app/screens/chat_screen/widgets/message_text_field.dart';
import 'package:palaemon_passenger_app/services/chat_service/chat_service.dart';



import '../../services/mumble_service.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);
  static const _borderRadius = 26.0;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  late StreamSubscription<ChatMessage> chatStream;
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    final ms = context.read<ChatService>();

    messages = ms.messages;

    chatStream = ms.stream.listen((event) {
      setState(() {
        messages = ms.messages;
      });
    });
  }


  @override
  void dispose() async {
    super.dispose();
    await chatStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final ms = context.read<MumbleService>();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Palaemon Passenger Chat"),
        ),
        body: Column(
          children:  [
           const Expanded(
                flex: 9,
                child: ChatLog()),
            Expanded(child: Row(
              children: [
                //set below flex = 3 if you use the ElevatedButton.icon widget from VoiceRecordButton, and set a padding with left and right equal to 8
                const Expanded(flex:1, child: VoiceRecordButton()),
                Expanded(flex:5,child: MessageTextField(messageController, messages)),
                Expanded(flex:1, child: MessageSendButton(messageController, messages))
              ],
            ))
          ],
        ),
      ),
    );
  }
}



