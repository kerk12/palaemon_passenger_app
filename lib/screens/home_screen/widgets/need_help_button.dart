import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palaemon_passenger_app/logger.dart';
import 'package:palaemon_passenger_app/services/chat_service/chat_service.dart';
import 'package:palaemon_passenger_app/services/mumble_service.dart';
import 'package:palaemon_passenger_app/services/nested_navigation_service.dart';
import 'package:palaemon_passenger_app/services/notification_service.dart';

class NeedHelpButton extends StatelessWidget {
  final String buttonColor;
  final String buttonName;
  final String buttonOutput;

  const NeedHelpButton(
      {Key? key,
      required this.buttonColor,
      required this.buttonName,
      required this.buttonOutput})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mumbleService = context.read<MumbleService>();
    final notificationService = context.read<NotificationService>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 13.0),
      child: ElevatedButton(
          onPressed: () {
            if (mumbleService.evacAssistantUser == null) {
              notificationService.showNotification(
                  title: "Evacuation Assistant Offline",
                  msg:
                      "We've run into a problem. Please find the nearest crew member to assist you.");
              return;
            }
            mumbleService.sendMessage(
                ChatMessage(
                    contents: this.buttonOutput,
                    type: MessageType.text,
                    creationDate: DateTime.now(),
                    origin: MessageOrigin.me),
                users: [(mumbleService.evacAssistantUser)!]);
            Logger.log("SOS_BUTTON_CLICKED");
            NestedNavigationService.getNearest(context).push(route: "chat");
            context.read<NotificationService>().showNotification(
                title: "Help is on the way!",
                msg:
                    "Please stay put and remain calm. You will receive a message shortly...");
          },
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(0, 55),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            backgroundColor: Color(int.parse(buttonColor)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          child: Text((buttonName))),
    );
  }
}
