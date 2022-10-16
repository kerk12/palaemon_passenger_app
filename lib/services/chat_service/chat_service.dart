import 'dart:async';
export 'models/chat_message.dart';
export 'chat_storage_manager.dart';

import 'package:flutter/material.dart';
import 'package:palaemon_passenger_app/services/chat_service/chat_storage_manager.dart';

import 'models/chat_message.dart';

class ChatService {
  final StreamController<ChatMessage> _chatController = StreamController<ChatMessage>.broadcast();

  Stream<ChatMessage> get stream => _chatController.stream;

  late List<ChatMessage> messages;
  ChatService() {
    ChatStorageManager.getChat().then((msgs) => messages = msgs);
    _chatController.stream.listen((message) {
      messages.add(message);
      ChatStorageManager.storeChat(messages);
    });
  }

  void onRawMessageReceived(String msgJson) {
    _onTextMessageReceived(msgJson, DateTime.now());
    // TODO Catch image messages...
  }

  void mockMessage() {
    _onTextMessageReceived("Hello", DateTime.now());
  }

  void _onTextMessageReceived(String contents, DateTime creationDate) {
    final msg = ChatMessage(contents: contents, type: MessageType.text, creationDate: creationDate);
    _chatController.add(msg);
  }

  void _onImageMessageReceived(String contents, DateTime creationDate) {
    final msg = ChatMessage(contents: contents, type: MessageType.image, creationDate: creationDate);
    _chatController.add(msg);
  }
}
