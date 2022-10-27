import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palaemon_passenger_app/services/chat_service/chat_service.dart';
import 'package:palaemon_passenger_app/services/mumble_service.dart';

class MessageSendButton extends StatelessWidget {
  final TextEditingController messageController;
  final List<ChatMessage> messages;
  const MessageSendButton(this.messageController, this.messages, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MumbleService mumbleService = context.read<MumbleService>();
    final chatService = context.read<ChatService>();

    return IconButton(
      onPressed:() {
        if(messages.isNotEmpty){
          final message = ChatService.createSelfSentMessage(messageController.text);
          mumbleService.sendMessage(message);
          chatService.addMessageToStream(message);
          messageController.clear();
        }
        else{
          null;
        }
      },
      icon: const Icon(Icons.send),
      color: messages.isNotEmpty ? const  Color(0xff1F9AD6):Colors.grey,
      iconSize: 35,);
  }
}


