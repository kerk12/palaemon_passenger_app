import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palaemon_passenger_app/screens/chat_screen/widgets/chat_log.dart';
import 'package:palaemon_passenger_app/screens/chat_screen/widgets/voice_record_button.dart';
import 'package:palaemon_passenger_app/screens/chat_screen/widgets/message_send_button.dart';
import 'package:palaemon_passenger_app/screens/chat_screen/widgets/message_text_field.dart';


import '../../services/mumble_service.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);
  TextEditingController messageController = TextEditingController();

  static const _borderRadius = 26.0;

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
                Expanded(flex:5,child: MessageTextField(messageController)),
                Expanded(flex:1, child: MessageSendButton(messageController))
              ],
            ))
          ],
        ),
      ),
    );
  }
}



