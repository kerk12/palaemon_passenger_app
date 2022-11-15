import 'package:flutter/material.dart';
import 'package:palaemon_passenger_app/services/chat_service/chat_service.dart';

import '../../../dateformatters.dart';
import 'chat_bubble.dart';

const _borderRadius = 26.0;


class ChatBubbleContainer extends StatelessWidget {
  final ChatMessage message;
  const ChatBubbleContainer(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool otherSideSending = message.origin == MessageOrigin.other;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal:8, vertical: 6),
        child: Column(
          children: [
            Align(
              alignment: otherSideSending
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Row(
                mainAxisAlignment: !otherSideSending ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  otherSideSending ? const Padding(
                      padding: EdgeInsets.only(right:4.0),
                      child: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/palaemon_ship_logo.png'),
                          backgroundColor: Colors.white,
                          radius:18
                      )
                  ): const SizedBox(),
                  Flexible(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: ChatBubble(
                          message,
                          color: message.origin == MessageOrigin.me ?
                            Colors.blue : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:2.0,left: 45),
              child: Align(
                alignment: otherSideSending
                    ? Alignment.topLeft
                    : Alignment.topRight,
                child: Text(
                  hourMinuteFormatter.format(message.creationDate),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                ),),
            ),

          ],
        )
    );
  }
}
