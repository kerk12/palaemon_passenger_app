// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      contents: json['contents'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      creationDate: DateTime.parse(json['creationDate'] as String),
      origin: $enumDecode(_$MessageOriginEnumMap, json['origin']),
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'contents': instance.contents,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'creationDate': instance.creationDate.toIso8601String(),
      'origin': _$MessageOriginEnumMap[instance.origin]!,
    };

const _$MessageTypeEnumMap = {
  MessageType.image: 'image',
  MessageType.text: 'text',
};

const _$MessageOriginEnumMap = {
  MessageOrigin.me: 'me',
  MessageOrigin.other: 'other',
};
