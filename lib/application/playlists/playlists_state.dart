part of 'playlists_bloc.dart';

// with EquatableMixin only needed for unit test
class PlaylistsState with EquatableMixin {
  final List<TrackEntity> tracks;
  final int playlistId;
  final List playlists;
  final bool loading;
  final String? message;

  const PlaylistsState({
    required this.tracks,
    required this.playlistId,
    required this.playlists,
    required this.loading,
    this.message,
  });

  factory PlaylistsState.initial() => const PlaylistsState(
        tracks: [],
        playlistId: -2,
        playlists: [],
        loading: true,
      );

  factory PlaylistsState.error({required String message}) =>
      const PlaylistsState(
        tracks: [],
        playlistId: -2,
        playlists: [],
        loading: false,
      );

  PlaylistsState copyWith({
    List<TrackEntity>? tracks,
    int? playlistId,
    List? playlists,
    bool? loading,
  }) {
    return PlaylistsState(
      tracks: tracks ?? this.tracks,
      playlistId: playlistId ?? this.playlistId,
      playlists: playlists ?? this.playlists,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [tracks, playlistId, playlists, loading];
}
