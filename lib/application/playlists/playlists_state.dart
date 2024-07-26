part of 'playlists_bloc.dart';

// with EquatableMixin only needed for unit test
class PlaylistsState with EquatableMixin {
  final List<TrackEntity> tracks;
  final int playlistId;
  final List playlists;

  const PlaylistsState({
    required this.tracks,
    required this.playlistId,
    required this.playlists,
  });

  factory PlaylistsState.initial() => const PlaylistsState(
        tracks: [],
        playlistId: -2,
        playlists: [],
      );

  PlaylistsState copyWith({
    List<TrackEntity>? tracks,
    int? playlistId,
    List? playlists,
  }) {
    return PlaylistsState(
      tracks: tracks ?? this.tracks,
      playlistId: playlistId ?? this.playlistId,
      playlists: playlists ?? this.playlists,
    );
  }

  @override
  List<Object?> get props => [tracks, playlistId, playlists];

}
