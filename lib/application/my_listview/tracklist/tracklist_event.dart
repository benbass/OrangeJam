part of 'tracklist_bloc.dart';

@immutable
abstract class TracklistEvent {}

/// Event at app start
final class TrackListLoadingEvent extends TracklistEvent{}

final class TrackListLoadedEvent extends TracklistEvent{}

final class PlayListLoadedEvent extends TracklistEvent{}

