import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opus_dart/opus_dart.dart';
import 'package:palaemon_passenger_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:palaemon_passenger_app/bloc/mumble_bloc/mumble_bloc.dart';
import 'package:palaemon_passenger_app/config.dart';
import 'package:palaemon_passenger_app/screens/main_page/main_screen.dart';
import 'package:palaemon_passenger_app/screens/register_user/register_user_screen.dart';
import 'package:palaemon_passenger_app/services/auth_service.dart';
import 'package:palaemon_passenger_app/services/chat_service/chat_service.dart';
import 'package:palaemon_passenger_app/services/mumble_service.dart';
import 'package:opus_flutter/opus_flutter.dart' as opus_flutter;

void main() async {
  initOpus(await opus_flutter.load());
  print(getOpusVersion());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This produces colors (HEX codes) in order to use them in primarySwatch attr of ThemeData class
  // The primarySwatch attribute receives only colors that are MaterialColor type and not HEX color type
  MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

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
              clientSecret: config.clientSecret);
        },
        child: BlocProvider<AuthBloc>(
          create: (context) =>
              AuthBloc(context.read<AuthService>())..add(Initialize()),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: buildMaterialColor(const Color(0xff1F9AD6)),
            ),
            initialRoute: "landing",
            routes: {"landing": (context) => const LandingPage()},
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
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<MumbleService>(
              create: (context) => MumbleService(
                  user: state.user, config: context.read<Config>()),
            ),
            RepositoryProvider<ChatService>(
              create: (context) => ChatService(),
            ),
          ],
          child: BlocProvider<MumbleBloc>(
            create: (context) => MumbleBloc(
              mumbleService: context.read<MumbleService>(),
              chatService: context.read<ChatService>(),
            )..add(Connect()),
            child: const MainScreen(),
          ),
        );
      }
      return const RegisterUser();
    });
  }
}
