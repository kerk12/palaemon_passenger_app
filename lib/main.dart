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
import 'package:flutter_background/flutter_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initOpus(await opus_flutter.load());
  print(getOpusVersion());
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "flutter_background example app",
    notificationText: "Background notification for keeping the example app running in the background",
    notificationImportance: AndroidNotificationImportance.Default,
    enableWifiLock: true
  );
  bool success = await FlutterBackground.initialize(androidConfig: androidConfig);

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
              clientSecret: config.clientSecret);
        },
        child: BlocProvider<AuthBloc>(
          create: (context) =>
              AuthBloc(context.read<AuthService>())..add(Initialize()),
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
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
