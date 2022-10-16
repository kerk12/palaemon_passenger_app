// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      contents: json['contents'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      creationDate: DateTime.parse(json['creationDate'] as String),
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'contents': instance.contents,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'creationDate': instance.creationDate.toIso8601String(),
    };

const _$MessageTypeEnumMap = {
  MessageType.image: 'image',
  MessageType.text: 'text',
};
