
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:orangejam/application/listview/data/tracks_bloc.dart';
import 'package:orangejam/domain/entities/track_entity.dart';
import 'package:orangejam/domain/failures/tracks_failures.dart';
import 'package:orangejam/domain/usecases/tracks_usecases.dart';

import 'tracks_bloc_test.mocks.dart';

@GenerateMocks([TracksUsecases])
void main() {
  late TracksBloc tracksBloc;
  late MockTracksUsecases mockTracksUsecases;

  setUp(() {
    mockTracksUsecases = MockTracksUsecases();
    tracksBloc = TracksBloc(tracksUsecase: mockTracksUsecases);
  });

  test("initState should be AdvicerInitial", () {
    expect(tracksBloc.state, equals(TracksInitial()));
  });

  group("TracksLoadingEvent", () {

    final tTracklist = <TrackEntity>[
      TrackEntity(
          filePath: "",
          trackName: "trackName",
          trackArtistNames: "null",
          albumName: null,
          trackNumber: null,
          albumLength: null,
          year: null,
          genre: null,
          trackDuration: null,
          albumArt: null,
          albumArtist: null,
      ).copyWith(id: 1)
    ];

    test("should call usecase if event is added", () async {
      // arrange
      when(mockTracksUsecases.getTracksUsecases()).thenAnswer((_) async => Right(tTracklist));
      // act
      tracksBloc.add(TracksLoadingEvent());
      await untilCalled(mockTracksUsecases.getTracksUsecases());
      // assert
      verify(mockTracksUsecases.getTracksUsecases());
      verifyNoMoreInteractions(mockTracksUsecases);
    });

    test("should emit loading then the loading state after event is added", () async {
      // arrange
      when(mockTracksUsecases.getTracksUsecases()).thenAnswer((_) async => Right(tTracklist));
      // act
      tracksBloc.add(TracksLoadingEvent());
      await untilCalled(mockTracksUsecases.getTracksUsecases());
      // assert later
      final expected = [TracksStateLoading(tracks: tTracklist)];
      expectLater(tracksBloc.stream, emitsInOrder(expected));
      // assert
      verify(mockTracksUsecases.getTracksUsecases());
      verifyNoMoreInteractions(mockTracksUsecases);

    });

    test("should emit loaded then the loaded state after event is added", () async {
      // arrange
      when(mockTracksUsecases.getTracksUsecases()).thenAnswer((_) async => Right(tTracklist));
      // assert later
      final expected = [TracksStateLoaded()];
      expectLater(tracksBloc.stream, emitsInOrder(expected));
      //act
      tracksBloc.add(TracksLoadedEvent());

    });

    test("should emit loading then error state after event is added -> usecase fails -> io failure", () async {
      // arrange
      when(mockTracksUsecases.getTracksUsecases()).thenAnswer((_) async => Left(TracksIoFailure()));
      // act
      tracksBloc.add(TracksLoadingEvent());
      await untilCalled(mockTracksUsecases.getTracksUsecases());
      // assert later
      final expected = [TracksStateError(message: "Oops, an error occurred while reading your files.\nPlease restart the app!")];
      expectLater(tracksBloc.stream, emitsInOrder(expected));
      // assert
      verify(mockTracksUsecases.getTracksUsecases());
      verifyNoMoreInteractions(mockTracksUsecases);
    });

    test("should emit loading then error state after event is added -> usecase fails -> general failure", () async {
      // arrange
      when(mockTracksUsecases.getTracksUsecases()).thenAnswer((_) async => Left(TracksGeneralFailure()));
      // act
      tracksBloc.add(TracksLoadingEvent());
      await untilCalled(mockTracksUsecases.getTracksUsecases());
      // assert later
      final expected = [TracksStateError(message: "Oops, something went wrong.\nPlease restart the app!")];
      expectLater(tracksBloc.stream, emitsInOrder(expected));
      // assert
      verify(mockTracksUsecases.getTracksUsecases());
      verifyNoMoreInteractions(mockTracksUsecases);
    });


  });
}
