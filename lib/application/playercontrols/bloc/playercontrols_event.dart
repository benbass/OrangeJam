part of 'playercontrols_bloc.dart';

@immutable
abstract class PlayerControlsEvent {}

class InitialPlayerControls extends PlayerControlsEvent {}

class TrackItemPressed extends PlayerControlsEvent {
  final TrackEntity track;

  TrackItemPressed({
    required this.track,
  });
}

class StopButtonPressed extends PlayerControlsEvent {}

class PausePlayButtonPressed extends PlayerControlsEvent {}

class PauseFromAudioSession extends PlayerControlsEvent {}

class NextButtonPressed extends PlayerControlsEvent {}

class PreviousButtonPressed extends PlayerControlsEvent {}

class LoopButtonPressed extends PlayerControlsEvent {}

class ContinuousButtonPressed extends PlayerControlsEvent {}

class ShowHideControlsButtonPressed extends PlayerControlsEvent {
  final double height;

  ShowHideControlsButtonPressed({required this.height});
}


