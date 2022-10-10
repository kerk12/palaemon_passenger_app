part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class Anonymous extends AuthState {}

class LoggedIn extends AuthState {
  User user;

  LoggedIn(this.user);
}

class Loading extends AuthState {}

class LoginFailed extends AuthState {}