import 'package:flutter/material.dart';
import 'package:palaemon_passenger_app/services/chat_service/chat_service.dart';


class MessageTextField extends StatelessWidget {
  final TextEditingController messageController;
  final List<ChatMessage> messages;
  const MessageTextField(this.messageController, this.messages, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: messageController,
      enabled: messages.isEmpty ? false: true,
      decoration: InputDecoration(
        labelText: 'Type your message here...',
        labelStyle: const TextStyle(
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 2,
            style: BorderStyle.none,
          ),
        ),
        focusColor: Colors.black,
        focusedBorder: const OutlineInputBorder(
          borderSide:
          BorderSide(color: Colors.black, width: 2.0),
        ),
      ),
    );
  }
}