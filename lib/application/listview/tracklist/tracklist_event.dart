part of 'tracklist_bloc.dart';

@immutable
abstract class TracklistEvent {}

/// Event at app start
final class TrackListLoadingEvent extends TracklistEvent{}

/// Event triggering next events on playlist once we are sure we have the tracks
final class TrackListLoadedEvent extends TracklistEvent{}

/// Event when user scans device
final class TrackListRefreschingEvent extends TracklistEvent{}

