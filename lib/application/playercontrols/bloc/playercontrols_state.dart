part of 'playercontrols_bloc.dart';

class PlayerControlsState {
  final TrackEntity track;
  final bool isPausing;
  final double height;
  final bool loopMode;

  const PlayerControlsState({
    required this.track,
    required this.isPausing,
    required this.height,
    required this.loopMode,
  });

  factory PlayerControlsState.initial() => PlayerControlsState(
        track: TrackEntity.empty(),
        isPausing: false,
        height: 0,
        loopMode: false,
      );

  PlayerControlsState copyWith({
    TrackEntity? track,
    bool? isPausing,
    double? height,
    bool? loopMode,
  }) {
    return PlayerControlsState(
      track: track ?? this.track,
      isPausing: isPausing ?? this.isPausing,
      height: height ?? this.height,
      loopMode: loopMode ?? this.loopMode,
    );
  }
}
