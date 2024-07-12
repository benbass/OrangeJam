import 'package:orange_player/domain/repositories/playlists_repository.dart';
import 'package:orange_player/infrastructure/datasources/playlists_datasource.dart';

class PlaylistsRepositoryImpl implements PlaylistsRepository{
  final Playlistsdatasource playlistsDatasource;
  PlaylistsRepositoryImpl({required this.playlistsDatasource});

  @override
  Future<List> getPlaylistsFromM3uFiles() async {
    final Future<List> playlists = playlistsDatasource.getPlaylistsFromM3uFiles();
    return playlists;
  }


}