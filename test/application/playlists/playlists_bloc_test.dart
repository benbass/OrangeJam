import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:orangejam/application/playlists/playlists_bloc.dart';
import 'package:orangejam/domain/entities/track_entity.dart';
import 'package:orangejam/domain/usecases/playlists_usecases.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'playlists_bloc_test.mocks.dart';

@GenerateMocks([PlaylistsUsecases])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PlaylistsBloc bloc;
  late MockPlaylistsUsecases mockPlaylistsUsecases;
  late PlaylistsState playlistsState;

  setUp(() async {
    SharedPreferences.setMockInitialValues({}); // this line is needed because we use sharedPrefs in the bloc
    mockPlaylistsUsecases = MockPlaylistsUsecases();
    bloc = PlaylistsBloc(playlistsUsecases: mockPlaylistsUsecases);
    playlistsState = PlaylistsState.initial();
  });

  tearDown(() {
    bloc.close();
  });

  final List tPlaylists = [
    [
      'Playlist 1',
      ['path/to/song1', 'path/to/song2']
    ],
    [
      'Playlist 2',
      ['path/to/song3']
    ]
  ];
  final List<TrackEntity> tInitialTracks = [
    TrackEntity(
      filePath: 'path/to/song1',
      trackName: 'song1',
      trackArtistNames: "null",
      albumName: null,
      trackNumber: null,
      albumLength: null,
      year: null,
      genre: null,
      trackDuration: null,
      albumArt: null,
      albumArtist: null,
    ),
    TrackEntity(
      filePath: 'path/to/song2',
      trackName: 'song2',
      trackArtistNames: "null",
      albumName: null,
      trackNumber: null,
      albumLength: null,
      year: null,
      genre: null,
      trackDuration: null,
      albumArt: null,
      albumArtist: null,
    ),
    TrackEntity(
      filePath: 'path/to/song3',
      trackName: 'song3',
      trackArtistNames: "null",
      albumName: null,
      trackNumber: null,
      albumLength: null,
      year: null,
      genre: null,
      trackDuration: null,
      albumArt: null,
      albumArtist: null,
    )
  ];

  PlaylistsBloc testBloc() {
    when(mockPlaylistsUsecases.getPlaylistsUsecase())
        .thenAnswer((_) async => tPlaylists);
    return bloc;
  }

  test('initial state should be PlaylistsInitial', () {
    expect(bloc.state, playlistsState);
  });

  group('PlaylistsBloc beyond initial', () {
    blocTest<PlaylistsBloc, PlaylistsState>(
      'emits copy of state with tracks, id == -2 (default) and playlists when PlaylistsLoadingEvent is added',
      build: testBloc,
      act: (bloc) async => {
        bloc.add(PlaylistsLoadingEvent(tracks: tInitialTracks)),
        await untilCalled(mockPlaylistsUsecases.getPlaylistsUsecase()),
        verify(mockPlaylistsUsecases.getPlaylistsUsecase()),
        verifyNoMoreInteractions(mockPlaylistsUsecases),
      },
      expect: () => [
        playlistsState.copyWith(
            tracks: tInitialTracks, playlistId: -2, playlists: tPlaylists),
      ],
    );

    blocTest<PlaylistsBloc, PlaylistsState>(
      'emits copy of state with new list of tracks and new id when PlaylistChanged with id is added',
      build: testBloc,
      act: (bloc) =>
          bloc.add(PlaylistChanged(id: 0)), // assuming first playlist is chosen
      expect: () => [
        playlistsState.copyWith(tracks: tInitialTracks, playlistId: 0),
      ],
    );

    blocTest<PlaylistsBloc, PlaylistsState>(
      'emits nothing when PlaylistDeleted with id is added',
      build: testBloc,
      act: (bloc) =>
          bloc.add(PlaylistDeleted(id: 0)), // assuming first playlist is chosen
      expect: () =>
          [], // we emit new state only if deleted id == current id, otherwise nothing happens
    );

    // Add more blocTest cases for other scenarios and error handling
  });
}
