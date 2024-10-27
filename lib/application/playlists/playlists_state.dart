part of 'playlists_bloc.dart';

// with EquatableMixin only needed for unit test
class PlaylistsState with EquatableMixin {
  final List<TrackEntity> tracks;
  final List<TrackEntity> initialTracks;
  final List<TrackEntity> queue;
  final int playlistId;
  final List playlists;
  final bool loading;
  final String? message;

  const PlaylistsState({
    required this.tracks,
    required this.initialTracks,
    required this.queue,
    required this.playlistId,
    required this.playlists,
    required this.loading,
    this.message,
  });

  factory PlaylistsState.initial() => const PlaylistsState(
        tracks: [],
        initialTracks: [],
        queue: [],
        playlistId: -2,
        playlists: [],
        loading: true,
      );

  factory PlaylistsState.error({required String message}) =>
      const PlaylistsState(
        tracks: [],
        initialTracks: [],
        queue: [],
        playlistId: -2,
        playlists: [],
        loading: false,
      );

  PlaylistsState copyWith({
    List<TrackEntity>? tracks,
    List<TrackEntity>? initialTracks,
    List<TrackEntity>? queue,
    int? playlistId,
    List? playlists,
    bool? loading,
  }) {
    return PlaylistsState(
      tracks: tracks ?? this.tracks,
      initialTracks: initialTracks ?? this.initialTracks,
      queue: queue ?? this.queue,
      playlistId: playlistId ?? this.playlistId,
      playlists: playlists ?? this.playlists,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [tracks, initialTracks, queue, playlistId, playlists, loading];
}
