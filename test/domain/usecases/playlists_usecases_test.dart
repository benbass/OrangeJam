import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:orange_player/domain/repositories/playlists_repository.dart';
import 'package:orange_player/domain/usecases/playlists_usecases.dart';

import 'playlists_usecases_test.mocks.dart';

@GenerateMocks([PlaylistsRepository])
void main(){

  late PlaylistsUsecases playlistsUsecases;
  late MockPlaylistsRepository mockPlaylistsRepository;

  setUp((){
    mockPlaylistsRepository = MockPlaylistsRepository();
    playlistsUsecases = PlaylistsUsecases(playlistsRepository: mockPlaylistsRepository);
  });



  group("getPlaylistsUsecase", (){

    final t_Playlist = [
      ['Playlist 1', ['path/to/song1', 'path/to/song2']],
      ['Playlist 2', ['path/to/song3']]
    ];

    test("should return same list of playlists as repo", () async {

      // arrange
      when(mockPlaylistsRepository.getPlaylistsFromM3uFiles()).thenAnswer((_) async => t_Playlist);

      // act
      final result = await playlistsUsecases.getPlaylistsUsecase();

      // assert
      expect(result, t_Playlist);
      verify(mockPlaylistsRepository.getPlaylistsFromM3uFiles());
      verifyNoMoreInteractions(mockPlaylistsRepository);

    });
  });

}