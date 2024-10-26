part of 'playercontrols_bloc.dart';

@immutable
abstract class PlayerControlsEvent {}

class InitialPlayerControls extends PlayerControlsEvent {}

class TrackItemPressed extends PlayerControlsEvent {
  final TrackEntity track;
  final BuildContext context;

  TrackItemPressed({
    required this.track, required this.context,
  });
}

class StopButtonPressed extends PlayerControlsEvent {}

class PausePlayButtonPressed extends PlayerControlsEvent {}

class PauseFromAudioSession extends PlayerControlsEvent {}

class NextButtonPressed extends PlayerControlsEvent {
  final BuildContext context;
  NextButtonPressed({required this.context});
}

class PreviousButtonPressed extends PlayerControlsEvent {
  final BuildContext context;
  PreviousButtonPressed({required this.context});
}

class NextButtonInNotificationPressed extends PlayerControlsEvent{
}

class PreviousButtonInNotificationPressed extends PlayerControlsEvent{
}

class LoopButtonPressed extends PlayerControlsEvent {}

class ShowHideControlsButtonPressed extends PlayerControlsEvent {
  final double height;

  ShowHideControlsButtonPressed({required this.height});
}

class TrackMetaTagUpdated extends PlayerControlsEvent {}
