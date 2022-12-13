import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:palaemon_passenger_app/models/user.dart';
import 'package:palaemon_passenger_app/services/auth_service.dart';

import '../../config.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Config config;
  final AuthService authService;

  AuthBloc(this.authService, this.config) : super(AuthInitial()) {
    on<Initialize>((event, emit) async {
      emit(Loading());
      final user = await authService.loginWithExistingCredentials();
      emit(user != null ? LoggedIn(user) : Anonymous());
    });
    on<Register>((event, emit) async {
      emit(Loading());
      final user = await authService.registerToPersonsServer(config, event.mumbleName);
      emit(LoggedIn(user));
    });
  }
}
