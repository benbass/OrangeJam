/// gets all m3u files from dir
abstract class PlaylistsRepository{
  Future<List> getPlaylistsFromM3uFiles();
}