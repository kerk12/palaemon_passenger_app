import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palaemon_passenger_app/screens/chat_screen/widgets/chat_bubble.dart';
import 'package:palaemon_passenger_app/services/chat_service/chat_service.dart';

class ChatLog extends StatefulWidget {
  const ChatLog({Key? key}) : super(key: key);


  @override
  State<ChatLog> createState() => _ChatLogState();
}

class _ChatLogState extends State<ChatLog> {
  late StreamSubscription<ChatMessage> chatStream;
  List<ChatMessage> messages = [];

  static const _borderRadius = 26.0;

  // Depending on who is sending the message
  // origin variable (MessageOrigin type) (me,other)
  final bool sender = true;


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
    return ListView.builder(itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal:8, vertical: 6),
        child: sender? Column(
          children: [
            Align(

              alignment: Alignment.centerLeft,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xffDBDCDA),
                  borderRadius:  BorderRadius.only(
                    topLeft: Radius.circular(_borderRadius),
                    topRight: Radius.circular(_borderRadius),
                    bottomRight: Radius.circular(_borderRadius),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
                  child: ChatBubble(messages[index]),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top:2.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '11:44 pm',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                ),),
            ),
          ],
        ): Column(
          children: [
            Align(

              alignment: Alignment.centerRight,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xff1F9AD6),
                  borderRadius:  BorderRadius.only(
                    topRight: Radius.circular(_borderRadius),
                    topLeft: Radius.circular(_borderRadius),
                    bottomLeft: Radius.circular(_borderRadius),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
                  child: ChatBubble(messages[index]),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top:2.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  '11:44 PM',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                ),),
            )
          ],
        ),
      );
    },
      itemCount: messages.length,);
  }
}