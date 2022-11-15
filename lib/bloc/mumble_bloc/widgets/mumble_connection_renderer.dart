import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palaemon_passenger_app/bloc/mumble_bloc/mumble_bloc.dart';

class MumbleConnectionRenderer extends StatelessWidget {
  final Widget onConnected, onDisconnected;
  Widget? onConnecting;
  MumbleConnectionRenderer({Key? key, required this.onConnected, this.onConnecting = null, required this.onDisconnected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MumbleBloc, MumbleState>(
        builder: (context, state) {
          if (state is Connected) {
            return onConnected;
          } else if (state is Disconnected) {
            return onDisconnected;
          }

          return onConnecting ?? const Center(child: CircularProgressIndicator());
        }
    );
  }
}
