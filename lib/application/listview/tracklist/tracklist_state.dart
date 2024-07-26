part of 'tracklist_bloc.dart';

/*@immutable
abstract class TracklistState {}

final class TracklistInitial extends TracklistState {}

final class TracklistStateLoading extends TracklistState {
  final List<TrackEntity> tracks;
  TracklistStateLoading({required this.tracks});
}

final class TracklistStateLoaded extends TracklistState {}

final class TracklistStateError extends TracklistState {
  final String message;
  TracklistStateError({required this.message});
}*/

// Testing:
@immutable
abstract class TracklistState {}

final class TracklistInitial extends TracklistState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class TracklistStateLoading extends TracklistState with EquatableMixin {
  @override
  List<Object?> get props => [tracks];
  final List<TrackEntity> tracks;
  TracklistStateLoading({required this.tracks});

}

final class TracklistStateLoaded extends TracklistState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class TracklistStateError extends TracklistState with EquatableMixin {
  @override
  List<Object?> get props => [message];
  final String message;
  TracklistStateError({required this.message});
}




