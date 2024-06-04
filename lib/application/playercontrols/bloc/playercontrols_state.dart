part of 'playercontrols_bloc.dart';

class PlayerControlsState {
  final TrackEntity track;
  final bool isPausing;
  final double height;

  const PlayerControlsState({
    required this.track,
    required this.isPausing,
    required this.height,
  });

  factory PlayerControlsState.initial() => PlayerControlsState(
        track: TrackEntity.empty(),
        isPausing: false,
        height: 0,
      );

  PlayerControlsState copyWith({
    TrackEntity? track,
    bool? isPausing,
    double? height,
  }) {
    return PlayerControlsState(
      track: track ?? this.track,
      isPausing: isPausing ?? this.isPausing,
      height: height ?? this.height,
    );
  }
}
