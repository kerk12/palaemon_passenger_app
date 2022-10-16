import 'package:flutter/material.dart';
import 'package:palaemon_passenger_app/services/chat_service/models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage _message;
  const ChatBubble(this._message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_message.type == MessageType.text) {
      return Text(_message.contents);
    }
    // TODO Add image bubbles
    return Text(_message.contents);
  }
}
