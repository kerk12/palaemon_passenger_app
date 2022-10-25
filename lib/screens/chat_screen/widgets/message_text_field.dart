import 'package:flutter/material.dart';

class MessageTextField extends StatelessWidget {
  final TextEditingController messageController;
  const MessageTextField(this.messageController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: messageController,
      decoration: InputDecoration(
        labelText: 'Type your message here...',
        labelStyle: const TextStyle(
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 2,
            style: BorderStyle.none,
          ),
        ),
        focusColor: Colors.black,
        focusedBorder: const OutlineInputBorder(
          borderSide:
          BorderSide(color: Colors.black, width: 2.0),
        ),
      ),
    );
  }
}