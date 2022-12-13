import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palaemon_passenger_app/bloc/mumble_bloc/mumble_bloc.dart';
import 'package:palaemon_passenger_app/bloc/mumble_bloc/widgets/mumble_connection_renderer.dart';
import 'package:palaemon_passenger_app/screens/home_screen/widgets/need_help_button.dart';
import 'package:palaemon_passenger_app/services/mumble_service.dart';
import 'package:palaemon_passenger_app/services/nested_navigation_service.dart';
import 'package:palaemon_passenger_app/situm/listeners.dart';
import 'package:palaemon_passenger_app/situm/situm.dart';

import '../../config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MumbleService ms;
  @override
  Widget build(BuildContext context) {
    final config = context.read<Config>();
    return Scaffold(
        // floatingActionButton: !config.isSitumDisabled ? MumbleConnectionRenderer(
        //   onConnected: FloatingActionButton(
        //     onPressed: () {
        //       // TODO Don't push when Situm hasn't been loaded yet.
        //       NestedNavigationService.getNearest(context).push(route: "map");
        //     },
        //     child: const Icon(Icons.map_outlined),
        //
        //   ),
        //   onConnecting: const SizedBox.shrink(),
        //   onDisconnected: const SizedBox.shrink(),
        // ) : null,
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
        body: BlocConsumer<MumbleBloc, MumbleState>(
          listener: (context, state) async {
            final situmSdk = Situm();
            final config = context.read<Config>();
            
            if (state is Connected && !config.isSitumDisabled && !situmSdk.isConfigured) {

              if (!situmSdk.isConfigured) {
                await situmSdk.configure(email: config.situmEmail, apiKey: config.situmPassword);
              }
              await situmSdk.start(LoggingLocationListener());
            }

            if (state is Disconnected && situmSdk.isConfigured) {
              await situmSdk.disconnect();
            }
          },
          builder: (context, state) {
            if (state is Connected) {
              return Column(children: [
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Image.asset(
                                'assets/images/palaemon_ship_logo.png'),
                          ),
                        ),

                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/wave_transparent.png'),
                              fit: BoxFit.cover),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: const Text("In case of emergency, you can press any of the buttons below and a member of the crew will be with you shortly to provide assistance.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15
                                ),
                              )),
                              Center(
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
                              ),
                            ],
                          ),
                        )))
              ]);
            }
            return Text("Connecting");
          },
        ));
  }
}
