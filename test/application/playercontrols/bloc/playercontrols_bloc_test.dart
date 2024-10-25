import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:orangejam/application/playercontrols/bloc/playercontrols_bloc.dart';
import 'package:orangejam/core/player/audiohandler.dart';
import 'package:orangejam/domain/entities/track_entity.dart';
import 'package:orangejam/injection.dart';

import 'playercontrols_bloc_test.mocks.dart';

@GenerateMocks([MyAudioHandler])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PlayerControlsBloc playerControlsBloc;
  late MockMyAudioHandler mockMyAudioHandler;

  setUp(() {
    playerControlsBloc = PlayerControlsBloc();
    mockMyAudioHandler = MockMyAudioHandler();
    sl.registerLazySingleton<MyAudioHandler>(() => mockMyAudioHandler);
  });

  tearDown(() {
    playerControlsBloc.close();
    sl.reset();
  });

  final TrackEntity track1 = TrackEntity.empty().copyWith(
    id: 1,
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
  );

  final TrackEntity track2 = TrackEntity.empty().copyWith(
    id: 2,
    filePath: 'path/to/song4',
    trackName: 'song4',
    trackArtistNames: "null",
    albumName: null,
    trackNumber: null,
    albumLength: null,
    year: 2019,
    genre: null,
    trackDuration: null,
    albumArt: null,
    albumArtist: null,
  );

  group("PlayerControlsBloc", () {

    // Initial state
    blocTest<PlayerControlsBloc, PlayerControlsState>(
        "emits [PlayerControlsState] with initial values when InitialPlayerControls is added',",
        build: () {
          return playerControlsBloc;
        },
        act: (bloc) => bloc.add(InitialPlayerControls()),
        expect: () => [
              PlayerControlsState(
                track: TrackEntity.empty().copyWith(id: 0),
                isPausing: false,
                height: 0,
                loopMode: false,
              )
            ]);

    // TrackItemPressed: replace track, update height
    for (var testData in [
      // Testdata for all 3 possible cases:
      {'currentTrack': track1, 'newTrack': track2, 'currentHeight': 200.0, 'newHeight': 200.0}, // play new track -> replaces track
      {'currentTrack': TrackEntity.empty().copyWith(id: 0), 'newTrack': track1, 'currentHeight': 0.0, 'newHeight': 200.0}, // play track from empty
    ]){
      blocTest<PlayerControlsBloc, PlayerControlsState>(
        "emits [PlayerControlsState] with updated values when TrackItemPressed is added',",
        build: () {
          when(mockMyAudioHandler.playTrack(any)).thenAnswer((_) => (){}); // we don't test this method here
          return playerControlsBloc;
        },
        seed: () => PlayerControlsState(
          track: testData['currentTrack'] as TrackEntity,
          isPausing: false,
          height: testData['currentHeight'] as double,
          loopMode: false,
        ),

        act: (bloc) => bloc.add(TrackItemPressed(track: testData['newTrack'] as TrackEntity)),
        expect: () => [
          PlayerControlsState(
            track: testData['newTrack'] as TrackEntity,
            isPausing: false,
            height: testData['newHeight'] as double,
            loopMode: false,
          ),
        ],
      );
    }

    // Stop track: replace track, update height
    blocTest<PlayerControlsBloc, PlayerControlsState>(
        "emits [PlayerControlsState] with updated values when StopButtonPressed is added',",
        build: () {
          return playerControlsBloc;
        },
        act: (bloc) => bloc.add(StopButtonPressed()),
        expect: () => [
          PlayerControlsState(
            track: TrackEntity.empty().copyWith(id: 0),
            isPausing: false,
            height: 0,
            loopMode: false,
          )
        ]);

    // PausePlayButtonPressed: pause or resume
    for (var testData in [
      // Testdata for all 3 possible cases:
      {'track': track1, 'expectedTrack': track1, 'isPausing': false, 'expectedIsPausing': true},
      {'track': track1, 'expectedTrack': track1, 'isPausing': true, 'expectedIsPausing': false},
    ]){
      blocTest<PlayerControlsBloc, PlayerControlsState>(
        "emits [PlayerControlsState] with updated isPausing state when PausePlayButtonPressed is added',",
        build: () {
          when(mockMyAudioHandler.pauseTrack()).thenAnswer((_) => (){}); // we don't test this method here
          when(mockMyAudioHandler.resumeTrack()).thenAnswer((_) => (){}); // we don't test this method here
          return playerControlsBloc;
        },
        seed: () => PlayerControlsState(
          track: testData['track'] as TrackEntity,
          isPausing: testData['isPausing'] as bool,
          height: 200,
          loopMode: false,
        ),

        act: (bloc) => bloc.add(PausePlayButtonPressed()),
        expect: () => [
          PlayerControlsState(
            track: testData['expectedTrack'] as TrackEntity,
            isPausing: testData['expectedIsPausing'] as bool,
            height: 200,
            loopMode: false,
          ),
        ],
      );
    }

    // NextButtonPressed
    blocTest<PlayerControlsBloc, PlayerControlsState>(
      "emits [PlayerControlsState] with next track when NextButtonPressed is added',",
      build: () {
        final nextTrack = TrackEntity.empty().copyWith(id: 2);
        final currentTrack = TrackEntity.empty().copyWith(id: 1);
        when(mockMyAudioHandler.getNextTrack(1, currentTrack))
            .thenAnswer((_) async => nextTrack);
        when(mockMyAudioHandler.playTrack(nextTrack)).thenAnswer((_) => (){}); // we don't test this method here
        return playerControlsBloc;
      },
      act: (bloc) => bloc.add(NextButtonPressed()),
      expect: () => [
        PlayerControlsState(
          track: TrackEntity.empty().copyWith(id: 2),
          isPausing: false,
          height: 200,
          loopMode: false,
        ),
      ],
    );

  });
}
