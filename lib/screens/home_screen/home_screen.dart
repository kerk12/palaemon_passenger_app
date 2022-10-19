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
                icon: const Icon(Icons.message_outlined))
          ],
        ),
        body: BlocBuilder<MumbleBloc, MumbleState>(
          builder: (context, state) {
            if (state is Connected) {
              return Column(children: [
                Expanded(
                  flex: 1,
                  child: Image.asset(
                      'assets/images/palaemon_logo_transparent.png'),
                ),
                Expanded(
                    flex: 3,
                    child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/wave_transparent.png'),
                            fit: BoxFit.cover
                          ),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: const [
                                    NeedHelpButton(
                                        buttonColor: "0xffAD2828",
                                        buttonName: "SOS"),
                                    NeedHelpButton(
                                        buttonColor: "0xff7dca5c",
                                        buttonName: "Call Me"),
                                    NeedHelpButton(
                                        buttonColor: "0xffD9C452",
                                        buttonName: "I feel sick"),
                                    NeedHelpButton(
                                        buttonColor: "0xffED8721",
                                        buttonName: "My family is at Risk"),
                                    NeedHelpButton(
                                        buttonColor: "0xffF26321",
                                        buttonName: "Report an Incident"),
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
