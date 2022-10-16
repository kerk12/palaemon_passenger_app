import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palaemon_passenger_app/bloc/mumble_bloc/mumble_bloc.dart';
import 'package:palaemon_passenger_app/services/mumble_service.dart';
import 'package:palaemon_passenger_app/services/nested_navigation_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MumbleService ms;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: () {
          NestedNavigationService.getNearest(context).push(route: "chat");
        }, icon: const Icon(Icons.message_outlined))
      ],),
      body: BlocBuilder<MumbleBloc, MumbleState>(
        builder: (context, state) {
          if (state is Connected) {
            return Text("You are connected");
          }
          return Text("Connecting");
        },
      )
    );
  }
}
