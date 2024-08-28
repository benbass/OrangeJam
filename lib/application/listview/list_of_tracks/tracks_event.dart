part of 'tracks_bloc.dart';

@immutable
abstract class TracksEvent {}

/// Event at app start
final class TracksLoadingEvent extends TracksEvent{}

/// Event triggering next events on playlist once we are sure we have the tracks
final class TracksLoadedEvent extends TracksEvent{}

/// Event when user scans device
final class TracksRefreshingEvent extends TracksEvent{}

