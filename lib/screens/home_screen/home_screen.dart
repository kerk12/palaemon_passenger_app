import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palaemon_passenger_app/bloc/mumble_bloc/mumble_bloc.dart';
import 'package:palaemon_passenger_app/screens/home_screen/widgets/need_help_button.dart';
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
        appBar: AppBar(
          title: const Text("Palaemon Passenger App"),
          actions: [
            IconButton(
                onPressed: () {
                  NestedNavigationService.getNearest(context)
                      .push(route: "chat");
                },
                icon: const Icon(Icons.chat_rounded)),
            IconButton(
                onPressed: () {
                  NestedNavigationService.getNearest(context)
                      .push(route: "info");
                },
                icon: const Icon(Icons.info_outline))
          ],
        ),
        body: BlocBuilder<MumbleBloc, MumbleState>(
          builder: (context, state) {
            if (state is Connected) {
              return Column(children: [
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        const Expanded(flex: 1, child: Text("")),
                        Expanded(
                          flex: 5,
                          child: Center(
                            child: Image.asset(
                                'assets/images/palaemon_ship_logo.png'),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                    flex: 3,
                    child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/wave_transparent.png'),
                              fit: BoxFit.cover),
                        ),
                        child: Center(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.1,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: const [
                                    NeedHelpButton(
                                      buttonColor: "0xffAD2828",
                                      buttonName: "SOS",
                                      buttonOutput: "SOS",
                                    ),
                                    NeedHelpButton(
                                        buttonColor: "0xff7dca5c",
                                        buttonName: "Call Me",
                                        buttonOutput: "CALL_ME"),
                                    NeedHelpButton(
                                        buttonColor: "0xffD9C452",
                                        buttonName: "I feel sick",
                                        buttonOutput: "SICK"),
                                    NeedHelpButton(
                                        buttonColor: "0xffED8721",
                                        buttonName: "My family is at Risk",
                                        buttonOutput: "FAMILY"),
                                    NeedHelpButton(
                                      buttonColor: "0xffF26321",
                                      buttonName: "Report an Incident",
                                      buttonOutput: "ACCIDENT",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )))
              ]);
            }
            return Text("Connecting");
          },
        ));
  }
}
