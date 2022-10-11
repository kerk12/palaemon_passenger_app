part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class Initialize extends AuthEvent {}

class TryLogin extends AuthEvent {
  final String username, password;

  const TryLogin(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class Register extends AuthEvent {
  final String mumbleName;

  Register(this.mumbleName);
}

class Logout extends AuthEvent {}

