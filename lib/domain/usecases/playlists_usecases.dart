import 'package:orangejam/domain/repositories/playlists_repository.dart';

class PlaylistsUsecases{
  final PlaylistsRepository playlistsRepository;

  PlaylistsUsecases({required this.playlistsRepository});

  Future<List> getPlaylistsUsecase() async {
    return playlistsRepository.getPlaylistsFromM3uFiles();
  }

}