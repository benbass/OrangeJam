import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:orange_player/domain/repositories/playlists_repository.dart';
import 'package:orange_player/infrastructure/datasources/playlists_datasource.dart';
import 'package:orange_player/infrastructure/repositories/playlists_repository_impl.dart';

import 'playlists_repository_test.mocks.dart';

@GenerateMocks([Playlistsdatasource])
void main(){

  late PlaylistsRepository playlistsRepository;
  late MockPlaylistsdatasource mockPlaylistsdatasource;

  setUp((){
    mockPlaylistsdatasource = MockPlaylistsdatasource();
    playlistsRepository = PlaylistsRepositoryImpl(playlistsDatasource: mockPlaylistsdatasource);
  });

  group("getPlaylistsFromM3uFiles", (){
    final t_Playlist = [
      ['Playlist 1', ['path/to/song1', 'path/to/song2']],
      ['Playlist 2', ['path/to/song3']]
    ];

    test("should return a list of playlists (from m3u files)", () async {

      when(mockPlaylistsdatasource.getPlaylistsFromM3uFiles()).thenAnswer((_) async => t_Playlist);

      final result = await playlistsRepository.getPlaylistsFromM3uFiles();

      verify(mockPlaylistsdatasource.getPlaylistsFromM3uFiles());
      expect(result, t_Playlist);
      verifyNoMoreInteractions(mockPlaylistsdatasource);

    });

  });

}