import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palaemon_passenger_app/screens/chat_screen/chat_screen.dart';
import 'package:palaemon_passenger_app/screens/info_screen/info_screen.dart';
import 'package:palaemon_passenger_app/screens/wayfinding_screen/wayfinding_screen.dart';
import 'package:palaemon_passenger_app/services/nested_navigation_service.dart';

import '../home_screen/home_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<NestedNavigationService>(
      create: (context) => NestedNavigationService(initialRoute: "home", routes: {
        "home": (context) => const HomeScreen(),
        "chat": (context) => ChatScreen(),
        "info": (context) => const InfoScreen(),
        "map": (context) => const WayfindingScreen()
      }),
      child: Builder(
        builder: (context) {
          return Scaffold(body: WillPopScope(onWillPop: () async {
            final nns = NestedNavigationService.getNearest(context);
            if (nns.canPop) {
              nns.pop();
              return false;
            }
            return true;
          },
          child: NestedNavigationService.getNearest(context).navigator));
        }
      ),
    );
  }
}
