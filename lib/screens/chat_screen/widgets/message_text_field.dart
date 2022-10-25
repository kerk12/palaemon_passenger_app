import 'package:flutter/material.dart';

class MessageTextField extends StatelessWidget {
  const MessageTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      // controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Complain title',
        labelStyle: const TextStyle(
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
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