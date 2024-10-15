part of 'playlists_bloc.dart';

@immutable
sealed class PlaylistsEvent {}

final class PlaylistsLoadingEvent extends PlaylistsEvent {
  final List<TrackEntity> tracks;

  PlaylistsLoadingEvent({required this.tracks});
}

final class PlaylistsLoadedEvent extends PlaylistsEvent {}

final class PlaylistCreated extends PlaylistsEvent {
  final String name;
  final List playlist;
  PlaylistCreated({required this.name, required this.playlist});
}

final class PlaylistChanged extends PlaylistsEvent {
  final int id;
  PlaylistChanged({required this.id});
}

final class PlaylistDeleted extends PlaylistsEvent {
  final int id;
  PlaylistDeleted({required this.id});
}

final class PlaylistSorted extends PlaylistsEvent {
  final String? sortBy;
  final bool ascending;

  PlaylistSorted({
    required this.sortBy,
    required this.ascending,
  });
}

final class PlaylistFiltered extends PlaylistsEvent {
  final String filterBy;
  final String value;

  PlaylistFiltered({
    required this.filterBy,
    required this.value,
  });
}

final class PlaylistSearchedByKeyword extends PlaylistsEvent {
  final String? keyword;

  PlaylistSearchedByKeyword({
    required this.keyword,
  });
}

///
final class TrackAddedToQueue extends PlaylistsEvent {
  final TrackEntity track;
  TrackAddedToQueue({required this.track});
}

final class TrackRemoveFromQueue extends PlaylistsEvent {
  final TrackEntity track;
  TrackRemoveFromQueue({required this.track});
}

final class ClearQueue extends PlaylistsEvent {}
