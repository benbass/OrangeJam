import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:orangejam/application/playlists/playlists_bloc.dart';
import 'package:orangejam/domain/entities/track_entity.dart';
import 'package:orangejam/domain/failures/tracks_failures.dart';
import 'package:orangejam/domain/usecases/playlists_usecases.dart';
import 'package:orangejam/domain/usecases/tracks_usecases.dart';
import 'package:orangejam/injection.dart';

import 'playlists_bloc_test.mocks.dart';

@GenerateMocks([PlaylistsUsecases, TracksUsecases])
void main() {
  late MockPlaylistsUsecases mockPlaylistsUsecases;
  late MockTracksUsecases mockTracksUsecases;
  late PlaylistsBloc playlistsBloc;

  setUp(() async {
    mockPlaylistsUsecases = MockPlaylistsUsecases();
    mockTracksUsecases = MockTracksUsecases();
    playlistsBloc = PlaylistsBloc(
      playlistsUsecases: mockPlaylistsUsecases,
      tracksUsecases: mockTracksUsecases,
    );
  });

  tearDown(() {
    playlistsBloc.close();
    sl.reset(); // Reset the service locator after each test
  });

  final List tPlaylists = [
    [
      'Playlist 1',
      ['path/to/song1', 'path/to/song2', 'path/to/song3']
    ],
    [
      'Playlist 2',
      ['path/to/song3']
    ]
  ];

  final List tNewPlaylist = ['New playlist', []];

  final List<TrackEntity> tInitialTracks = [
    TrackEntity(
      filePath: 'path/to/song1',
      trackName: 'song1',
      trackArtistNames: "null",
      albumName: null,
      trackNumber: null,
      albumLength: null,
      year: 2001,
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
      year: 2000,
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
      year: 2009,
      genre: null,
      trackDuration: null,
      albumArt: null,
      albumArtist: null,
    )
  ];

  final List<TrackEntity> tQueueTracks = [
    TrackEntity(
      filePath: 'path/to/song3',
      trackName: 'song3',
      trackArtistNames: "null",
      albumName: null,
      trackNumber: null,
      albumLength: null,
      year: 2009,
      genre: null,
      trackDuration: null,
      albumArt: null,
      albumArtist: null,
    ),
  ];

  group('PlaylistsBloc', () {
    /// Loading tracks, playlists and id from Shared prefs
    blocTest<PlaylistsBloc, PlaylistsState>(
      'emits [PlaylistsState] with initial tracks when PlaylistsTracksLoadingEvent is added, then further states when PlaylistsTracksLoadedEvent and PlaylistsLoadedEvent are added ',
      build: () {
        // first initial state is emitted!!!! Then:
        when(mockTracksUsecases.getTracksUsecases())
            .thenAnswer((_) async => Right(tInitialTracks));
        when(mockPlaylistsUsecases.getPlaylistsUsecase())
            .thenAnswer((_) async => tPlaylists);
        when(mockPlaylistsUsecases.idFromPrefs()).thenReturn(
            (2)); // we emit only one state for this and the following method
        when(mockPlaylistsUsecases.getInitialListAsPerPrefs(
                playlists: tPlaylists,
                savedId: 2,
                initialTracks: tInitialTracks))
            .thenReturn(tInitialTracks);

        return playlistsBloc;
      },
      act: (bloc) => bloc.add(PlaylistsTracksLoadingEvent()),
      expect: () => [
        PlaylistsState.initial(), // We do not forget the expected initial state
        PlaylistsState(
            tracks: tInitialTracks,
            playlistId: -2,
            playlists: [],
            loading: true,
            initialTracks: tInitialTracks,
            queue: []), // getTracksUsecases
        PlaylistsState(
            tracks: tInitialTracks,
            playlistId: -2,
            playlists: tPlaylists,
            loading: true,
            initialTracks: tInitialTracks,
            queue: []), // getPlaylistsUsecase
        PlaylistsState(
            tracks: tInitialTracks,
            playlistId: 2,
            playlists: tPlaylists,
            loading: false,
            initialTracks: tInitialTracks,
            queue: []), // idFromPrefs and getInitialListAsPerPrefs
      ],
    );

    /// Error when loading tracks
    blocTest<PlaylistsBloc, PlaylistsState>(
      'emits [PlaylistsState.error] when PlaylistsTracksLoadingEvent is added and getTracksUsecases returns a failure',
      build: () {
        when(mockTracksUsecases.getTracksUsecases())
            .thenAnswer((_) async => Left(TracksIoFailure()));
        return playlistsBloc;
      },
      act: (bloc) => bloc.add(PlaylistsTracksLoadingEvent()),
      expect: () => [
        PlaylistsState.initial(),
        const PlaylistsState(
          tracks: [],
          playlists: [],
          playlistId: -2,
          loading: false,
          message:
              "Oops, an error occurred while reading your files.\nPlease restart the app!",
          initialTracks: [],
          queue: [],
        ),
      ],
    );

    /// PlaylistCreated
    blocTest<PlaylistsBloc, PlaylistsState>(
        "emits PlaylistState with new playlist when PlaylistCreated event is added",
        build: () {
          return playlistsBloc;
        },
        act: (bloc) =>
            bloc.add(PlaylistCreated(name: "New playlist", playlist: const [])),
        expect: () => [
              PlaylistsState(
                  tracks: [],
                  playlistId: -2,
                  playlists: [tNewPlaylist],
                  loading: true,
                  initialTracks: [],
                  queue: []),
            ]);

    /// PlaylistChanged
    for (var testData in [
      // Testdata for all 3 possible cases:
      {'id': -2, 'expectedTracks': tInitialTracks, 'expectedPlaylistId': -2},
      {'id': -1, 'expectedTracks': tQueueTracks, 'expectedPlaylistId': -1},
      {
        'id': 1,
        'expectedTracks': [tInitialTracks[2]],
        'expectedPlaylistId': 1
      },
    ]) {
      blocTest<PlaylistsBloc, PlaylistsState>(
        'PlaylistChanged: emits [PlaylistsState] with correct tracks and playlistId when id is ${testData['id']}',
        build: () {
          when(mockPlaylistsUsecases.playlistChanged(
                  playlists: tPlaylists,
                  id: testData['id'] as int,
                  initialTracks: tInitialTracks,
                  queue: tQueueTracks))
              .thenReturn(testData['expectedTracks'] as List<TrackEntity>);
          return playlistsBloc;
        },
        seed: () => PlaylistsState(
          tracks: [],
          playlists: tPlaylists,
          playlistId: -2,
          loading: false,
          initialTracks: tInitialTracks,
          queue: tQueueTracks,
        ),
        act: (bloc) => bloc.add(PlaylistChanged(id: testData['id'] as int)),
        expect: () => [
          PlaylistsState(
            tracks: testData['expectedTracks'] as List<TrackEntity>,
            playlists: tPlaylists,
            playlistId: testData['expectedPlaylistId'] as int,
            loading: false,
            initialTracks: tInitialTracks,
            queue: tQueueTracks,
          ),
        ],
      );
    }

    /// playlistDeleted
    blocTest<PlaylistsBloc, PlaylistsState>(
        "emits PlaylistState with all tracks when PlaylistDeleted event is added with id is current playlist",
        build: () {
          return playlistsBloc;
        },
        seed: () => PlaylistsState(
              tracks: [],
              playlists: tPlaylists,
              playlistId: 0,
              loading: false,
              initialTracks: tInitialTracks,
              queue: [],
            ),
        act: (bloc) => bloc.add(PlaylistDeleted(id: 0)),
        expect: () => [
              PlaylistsState(
                  tracks: tInitialTracks,
                  playlistId: -2,
                  playlists: tPlaylists,
                  loading: false,
                  initialTracks: tInitialTracks,
                  queue: []),
            ]);

    /// PlaylistSorted
    blocTest<PlaylistsBloc, PlaylistsState>(
      "emits PlaylistState with sorted tracks when PlaylistSorted event is added",
      build: () {
        when(mockPlaylistsUsecases.sortedList(
                tInitialTracks, 'Track name', true))
            .thenReturn(tInitialTracks);
        return playlistsBloc;
      },
      seed: () => PlaylistsState(
        tracks: tInitialTracks,
        playlists: tPlaylists,
        playlistId: -2,
        loading: false,
        initialTracks: tInitialTracks,
        queue: [],
      ),
      act: (bloc) =>
          bloc.add(PlaylistSorted(sortBy: 'Track name', ascending: true)),
      expect: () => [
        PlaylistsState(
            tracks: [],
            playlistId: -2,
            playlists: tPlaylists,
            loading: false,
            initialTracks: tInitialTracks,
            queue: []),
        PlaylistsState(
            tracks: tInitialTracks,
            playlistId: -2,
            playlists: tPlaylists,
            loading: false,
            initialTracks: tInitialTracks,
            queue: []),
      ],
    );

    /// PlaylistFiltered
    blocTest<PlaylistsBloc, PlaylistsState>(
      "emits PlaylistState with filtered tracks when PlaylistFiltered event is added",
      build: () {
        when(mockPlaylistsUsecases.filteredList(tInitialTracks, "Year", "2001"))
            .thenReturn([tInitialTracks[0]]);
        return playlistsBloc;
      },
      seed: () => PlaylistsState(
        tracks: tInitialTracks,
        playlists: tPlaylists,
        playlistId: -2,
        loading: false,
        initialTracks: tInitialTracks,
        queue: [],
      ),
      act: (bloc) =>
          bloc.add(PlaylistFiltered(filterBy: "Year", value: "2001")),
      expect: () => [
        PlaylistsState(
            tracks: [tInitialTracks[0]],
            playlistId: -2,
            playlists: tPlaylists,
            loading: false,
            initialTracks: tInitialTracks,
            queue: []),
      ],
    );

    /// PlaylistSearchedByKeyword
    blocTest<PlaylistsBloc, PlaylistsState>(
      "emits PlaylistState with tracks searched by keyword when PlaylistSearched event is added",
      build: () {
        when(mockPlaylistsUsecases.searchedList(
                keyword: '2001', initialTracks: tInitialTracks))
            .thenReturn([tInitialTracks[0]]);
        return playlistsBloc;
      },
      seed: () => PlaylistsState(
        tracks: tInitialTracks,
        playlists: tPlaylists,
        playlistId: -2,
        loading: false,
        initialTracks: tInitialTracks,
        queue: [],
      ),
      act: (bloc) => bloc.add(PlaylistSearchedByKeyword(keyword: "2001")),
      expect: () => [
        PlaylistsState(
            tracks: [tInitialTracks[0]],
            playlistId: -2,
            playlists: tPlaylists,
            loading: false,
            initialTracks: tInitialTracks,
            queue: []),
      ],
    );

    /// TrackAddedToQueue
    blocTest<PlaylistsBloc, PlaylistsState>(
      "emits PlaylistState with track added to queue when TrackAddedToQueue event is added",
      build: () {
        return playlistsBloc;
      },
      seed: () => PlaylistsState(
        tracks: [],
        playlists: tPlaylists,
        playlistId:-1, // current playlist is queue!!! so we expect 2 states!
        loading: false,
        initialTracks: tInitialTracks,
        queue: [],
      ),
      act: (bloc) => bloc.add(TrackAddedToQueue(track: tInitialTracks[0])),
      expect: () => [
        PlaylistsState(
            tracks: [],
            playlistId:-1,
            playlists: tPlaylists,
            loading: false,
            initialTracks: tInitialTracks,
            queue: [tInitialTracks[0]]),
        // second state. if current playlist is not queue (id = -1), the following expected state must be removed.
        PlaylistsState(
            tracks: [tInitialTracks[0]],
            playlistId:-1,
            playlists: tPlaylists,
            loading: false,
            initialTracks: tInitialTracks,
            queue: [tInitialTracks[0]]),
      ],
    );

    /// TrackRemoveFromQueue
    blocTest<PlaylistsBloc, PlaylistsState>(
      "emits PlaylistState with track removed from queue when TrackRemoveFromQueue event is added",
      build: () {
        return playlistsBloc;
      },
      seed: () => PlaylistsState(
        tracks: tQueueTracks,
        playlists: tPlaylists,
        playlistId: -1,
        loading: false,
        initialTracks: [],
        queue: tQueueTracks,
      ),
      act: (bloc) => bloc.add(TrackRemoveFromQueue(track: tQueueTracks[0])),
      expect: () => [
        PlaylistsState(
            tracks: [],
            playlistId: -1,
            playlists: tPlaylists,
            loading: false,
            initialTracks: [],
            queue: []),
      ],
    );

    /// ClearQueue
    blocTest<PlaylistsBloc, PlaylistsState>(
      "emits PlaylistState with empty list when ClearQueue event is added",
      build: () {
        return playlistsBloc;
      },
      seed: () => PlaylistsState(
        tracks: tQueueTracks,
        playlists: tPlaylists,
        playlistId: -1,
        loading: false,
        initialTracks: [],
        queue: [],
      ),
      act: (bloc) => bloc.add(ClearQueue()),
      expect: () => [
        PlaylistsState(
            tracks: [],
            playlistId: -1,
            playlists: tPlaylists,
            loading: false,
            initialTracks: [],
            queue: []),
      ],
    );
  });
}
