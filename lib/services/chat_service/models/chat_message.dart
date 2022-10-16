import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

enum MessageType {
  @JsonValue("image")
  image,
  @JsonValue("text")
  text
}

@JsonSerializable()
class ChatMessage {
  final String contents;
  final MessageType type;
  final DateTime creationDate;

  ChatMessage({required this.contents, required this.type, required this.creationDate});

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}