import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palaemon_passenger_app/screens/chat_screen/widgets/chat_bubble_container.dart';
import 'package:palaemon_passenger_app/services/chat_service/chat_service.dart';

class ChatLog extends StatefulWidget {
  const ChatLog({Key? key}) : super(key: key);


  @override
  State<ChatLog> createState() => _ChatLogState();
}

class _ChatLogState extends State<ChatLog> {
  late StreamSubscription<ChatMessage> chatStream;
  List<ChatMessage> messages = [];
  final ScrollController _messageListScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final ms = context.read<ChatService>();

    messages = ms.messages.reversed.toList();

    chatStream = ms.stream.listen((event) {
      setState(() {
        messages = ms.messages.reversed.toList();
      });
      _messageListScrollController.jumpTo(0);
    });
  }


  @override
  void dispose() async {
    super.dispose();
    await chatStream.cancel();
  }



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      controller: _messageListScrollController,
      itemBuilder: (context, index) =>
      InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(30.0),
          panEnabled: false,
          minScale: 1,
          maxScale: 1.6,
          child: ChatBubbleContainer(messages[index])),
      itemCount: messages.length,);
  }
}