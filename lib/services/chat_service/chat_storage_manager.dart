import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/chat_message.dart';

class ChatStorageManager {
  ChatStorageManager._();

  static const String _chatStorageKey = "chat_messages";
  static Future<void> storeChat(List<ChatMessage> messages) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        _chatStorageKey, jsonEncode(messages.map((m) => m.toJson()).toList()));
  }

  static Future<List<ChatMessage>> getChat() async {
    final prefs = await SharedPreferences.getInstance();

    if (await hasMessages()){
      final json = jsonDecode(prefs.getString(_chatStorageKey)!);
      List<ChatMessage> msgs = [];
      for (Map<String, dynamic> obj in json) {
        msgs.add(ChatMessage.fromJson(obj));
      }
      return msgs;
    }
    return [];
  }

  static Future<bool> hasMessages() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_chatStorageKey);
  }
}
