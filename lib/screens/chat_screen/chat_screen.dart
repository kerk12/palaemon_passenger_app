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

  StreamSubscription<ChatMessage>? chatStream;
  bool _messagingDisabled = true;

  @override
  void initState() {
    super.initState();
    final ms = context.read<ChatService>();

    _messagingDisabled = ms.messages.isEmpty;

    if (_messagingDisabled) {
      chatStream = ms.stream.listen((event) {
          // If messaging is disabled and the user receives a message, set to enabled.
          setState(() {
            _messagingDisabled = false;
          });
          // Afterwards, cancel the subscription (not needed anymore).
          chatStream!.cancel();
      });
    }

  }


  @override
  void dispose() async {
    super.dispose();
    if (chatStream != null){
      await chatStream!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
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
            !_messagingDisabled ? Expanded(child: Row(
              children: [
                //set below flex = 3 if you use the ElevatedButton.icon widget from VoiceRecordButton, and set a padding with left and right equal to 8
                const Expanded(flex:1, child: VoiceRecordButton()),
                Expanded(flex:5,child: MessageTextField(messageController)),
                Expanded(flex:1, child: MessageSendButton(messageController))
              ],
            )) : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}



