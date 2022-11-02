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
      return Html(
          data: _message.contents,
        style: {
            "img": Style(
              width: 50,
              height: 50
            ),
          "header": Style(
              // padding: EdgeInsets.symmetric(vertical: 10),
            ),
            "header img": Style(
                width: 50,
                height: 50,
                display: Display.BLOCK,
              alignment: Alignment.center
            ),
          "header h1": Style(
            color: Colors.red,
            textAlign: TextAlign.center
          )
        },
      );
      // return Text(_message.contents, style: TextStyle(
      //   color: _message.origin == MessageOrigin.me
      //       ? Colors.white
      //       : null
      // ),);
    }

    return Image.memory(base64Decode(_message.contents));
  }
}
