import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

enum MessageType {
  @JsonValue("image")
  image,
  @JsonValue("text")
  text
}

enum MessageOrigin {
  @JsonValue("me")
  me,
  @JsonValue("other")
  other
}

@JsonSerializable()
class ChatMessage {
  final String contents;
  final MessageType type;
  final DateTime creationDate;
  final MessageOrigin origin;

  ChatMessage({required this.contents, required this.type, required this.creationDate, required this.origin});

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}