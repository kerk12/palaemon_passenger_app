import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palaemon_passenger_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:palaemon_passenger_app/config.dart';
import 'package:palaemon_passenger_app/screens/register_user/register_user_screen.dart';
import 'package:palaemon_passenger_app/services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<Config>(
      create: (context) => ProductionConfig(),
      child: RepositoryProvider<AuthService>(
        create: (context) {
          final config = context.read<Config>();
          return AuthService(
            baseUrl: config.personManagementServer,
            authHeaders: config.authHeaders,
            authCookies: config.authCookies,
            authServer: config.authenticationServer,
            clientSecret: config.clientSecret
          );
        },
        child: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(context.read<AuthService>())..add(Initialize()),
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: "landing",
            routes: {
              "landing": (context) => const LandingPage()
            },
          ),
        ),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is LoggedIn) {
        return Container();
      }
      return const RegisterUser();
    });
  }
}
