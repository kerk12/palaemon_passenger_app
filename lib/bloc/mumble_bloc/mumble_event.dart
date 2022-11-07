part of 'mumble_bloc.dart';

abstract class MumbleEvent extends Equatable {
  const MumbleEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Connect extends MumbleEvent {}

class Disconnect extends MumbleEvent {
  final bool retry;

  Disconnect(this.retry);
}