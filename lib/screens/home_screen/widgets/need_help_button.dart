import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palaemon_passenger_app/bloc/mumble_bloc/mumble_bloc.dart';
import 'package:palaemon_passenger_app/services/mumble_service.dart';
import 'package:palaemon_passenger_app/services/nested_navigation_service.dart';

class NeedHelpButton extends StatelessWidget {
  final String buttonColor;
  final String buttonName;

  const NeedHelpButton({Key? key, required this.buttonColor, required this.buttonName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:13.0),
      child: ElevatedButton(
          onPressed: () => {
            debugPrint(buttonName),
          },
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(0, 55),
            textStyle: const TextStyle(
                fontSize: 18,
               ),
            backgroundColor: Color(int.parse(buttonColor)),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(25.0),
            ),
          ),
          child: Text((buttonName))),
    );
  }
}
