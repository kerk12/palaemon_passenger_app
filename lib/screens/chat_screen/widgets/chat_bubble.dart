import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:palaemon_passenger_app/services/chat_service/models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage _message;
  const ChatBubble(this._message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_message.type == MessageType.text) {
      // If the message is of type Text, check if there's HTML in the message.
      final htmlPattern = RegExp(r"<.*?>");

      // If there is, render the HTML.
      if (htmlPattern.hasMatch(_message.contents)) {
        return Html(
          data: _message.contents,
        );
      }
      // Otherwise, just render a simple text widget.
      // We could've just rendered the HTML tag but it gets the full width of the
      // parent and it looks really bad.
      return Text(_message.contents,style: const TextStyle(fontSize:14),);

    }

    return Image.memory(base64Decode(_message.contents));
  }
}
