part of 'tracks_bloc.dart';

@immutable
abstract class TracksState {}

final class TracksInitial extends TracksState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class TracksStateLoading extends TracksState with EquatableMixin {
  @override
  List<Object?> get props => [tracks];
  final List<TrackEntity> tracks;
  TracksStateLoading({required this.tracks});

}

final class TracksStateLoaded extends TracksState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class TracksStateError extends TracksState with EquatableMixin {
  @override
  List<Object?> get props => [message];
  final String message;
  TracksStateError({required this.message});
}




