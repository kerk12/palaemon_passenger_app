import "package:flutter/material.dart";

class MessageSendButton extends StatelessWidget {
  const MessageSendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed:() => {
        debugPrint("send"),
      },
      icon: const Icon(Icons.send),
      color: const  Color(0xff1F9AD6),
      iconSize: 35,);
  }
}


