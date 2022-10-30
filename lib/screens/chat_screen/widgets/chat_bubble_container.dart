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
                      decoration: BoxDecoration(
                        color: Color(otherSideSending ? 0xffDBDCDA : 0xff1F9AD6),
                        borderRadius:  BorderRadius.only(
                            topLeft: const Radius.circular(_borderRadius),
                            topRight: const Radius.circular(_borderRadius),
                            bottomRight: otherSideSending
                                ? const Radius.circular(_borderRadius)
                                : Radius.zero,
                            bottomLeft: !otherSideSending
                                ? const Radius.circular(_borderRadius)
                                : Radius.zero
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                        child: ChatBubble(message),
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
