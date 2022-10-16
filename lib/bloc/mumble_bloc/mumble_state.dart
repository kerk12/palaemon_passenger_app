part of 'mumble_bloc.dart';

abstract class MumbleState extends Equatable {
  const MumbleState();

  @override
  List<Object> get props => [];
}

class MumbleInitial extends MumbleState {}

class Disconnected extends MumbleState {}

class Connecting extends MumbleState {}

class Connected extends MumbleState {}
