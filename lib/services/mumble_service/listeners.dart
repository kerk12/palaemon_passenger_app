import 'package:dumble/dumble.dart';
import 'package:flutter/material.dart';

typedef OnEvacAssistantChangeFn = void Function(User? newAssistant);

/// Used to detect changes to the `pameas_evacuation_assistant` user, so that SOS
/// messages reach the bridge, even if the mumble connection gets interrupted or
/// the evacuation assistant leaves the mumble server for some reason.
class EvacAssistantUserListener with MumbleClientListener, UserListener {
  final OnEvacAssistantChangeFn onEvacAssistantChange;
  final MumbleClient client;

  EvacAssistantUserListener({required this.onEvacAssistantChange, required this.client});

  @override
  void onUserChanged(User user, User? actor, UserChanges changes) {}

  @override
  void onUserRemoved(User user, User? actor, String? reason, bool? ban) {
    if (user.name == "pameas_evacuation_assistant" && actor == null){
      onEvacAssistantChange(null);
      debugPrint("Evacuation assistant left the server...");
    }
  }

  @override
  void onUserStats(User user, UserStats stats) {
    // TODO: implement onUserStats
  }

  @override
  void onBanListReceived(List<BanEntry> bans) {
    // TODO: implement onBanListReceived
  }

  @override
  void onChannelAdded(Channel channel) {
    // TODO: implement onChannelAdded
  }

  @override
  void onCryptStateChanged() {
    // TODO: implement onCryptStateChanged
  }

  @override
  void onDone() {}

  @override
  void onDropAllChannelPermissions() {
    // TODO: implement onDropAllChannelPermissions
  }

  @override
  void onError(Object error, [StackTrace? stackTrace]) {}

  @override
  void onPermissionDenied(PermissionDeniedException e) {
    // TODO: implement onPermissionDenied
  }

  @override
  void onQueryUsersResult(Map<int, String> idToName) {
    // TODO: implement onQueryUsersResult
  }

  @override
  void onTextMessage(IncomingTextMessage message) {
    // TODO: implement onTextMessage
  }

  @override
  void onUserAdded(User user) {
    if (user.name == "pameas_evacuation_assistant") {
      onEvacAssistantChange(user);
      debugPrint("Evacuation assistant joined the server...");
    }
    user.add(this);
  }

  @override
  void onUserListReceived(List<RegisteredUser> users) {
    // TODO: implement onUserListReceived
  }

}