import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:orange_player/application/my_listview/tracklist/tracklist_bloc.dart';
import 'package:orange_player/domain/entities/track_entity.dart';
import 'package:orange_player/domain/failures/tracklist_failures.dart';
import 'package:orange_player/domain/usecases/tracklist_usecases.dart';

import 'tracklist_bloc_test.mocks.dart';

@GenerateMocks([TracklistUsecases])
void main() {
  late TracklistBloc tracklistBloc;
  late MockTracklistUsecases mockTracklistUsecases;

  setUp(() {
    mockTracklistUsecases = MockTracklistUsecases();
    tracklistBloc = TracklistBloc(tracklistUsecase: mockTracklistUsecases);
  });

  test("initState should be AdvicerInitial", () {
    expect(tracklistBloc.state, equals(TracklistInitial()));
  });

  group("TrackListLoadingEvent", () {

    final tTracklist = <TrackEntity>[
      TrackEntity(
          id: 1,
          file: File(""),
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
      )
    ];

    test("should call usecase if event is added", () async {
      // arrange
      when(mockTracklistUsecases.getTracklistUsecases()).thenAnswer((_) async => Right(tTracklist));
      // act
      tracklistBloc.add(TrackListLoadingEvent());
      await untilCalled(mockTracklistUsecases.getTracklistUsecases());
      // assert
      verify(mockTracklistUsecases.getTracklistUsecases());
      verifyNoMoreInteractions(mockTracklistUsecases);
    });

    test("should emit loading then the loaded state after event is added", () async {
      // arrange
      when(mockTracklistUsecases.getTracklistUsecases()).thenAnswer((_) async => Right(tTracklist));
      // act
      tracklistBloc.add(TrackListLoadingEvent());
      await untilCalled(mockTracklistUsecases.getTracklistUsecases());
      // assert later
      final expected = [TracklistStateLoading(tracks: tTracklist)];
      expectLater(tracklistBloc.stream, emitsInOrder(expected));
      // assert
      verify(mockTracklistUsecases.getTracklistUsecases());
      verifyNoMoreInteractions(mockTracklistUsecases);

    });

    test("should emit loaded then the loaded state after event is added", () async {
      // arrange
      when(mockTracklistUsecases.getTracklistUsecases()).thenAnswer((_) async => Right(tTracklist));
      // assert later
      final expected = [TracklistStateLoaded()];
      expectLater(tracklistBloc.stream, emitsInOrder(expected));
      //act
      tracklistBloc.add(TrackListLoadedEvent());

    });

    test("should emit loading then error state after event is added -> usecase fails -> io failure", () async {
      // arrange
      when(mockTracklistUsecases.getTracklistUsecases()).thenAnswer((_) async => Left(TracklistIoFailure()));
      // act
      tracklistBloc.add(TrackListLoadingEvent());
      await untilCalled(mockTracklistUsecases.getTracklistUsecases());
      // assert later
      final expected = [TracklistStateError(message: "Oops, an error occurred while reading your files.\nPlease restart the app!")];
      expectLater(tracklistBloc.stream, emitsInOrder(expected));
      // assert
      verify(mockTracklistUsecases.getTracklistUsecases());
      verifyNoMoreInteractions(mockTracklistUsecases);
    });

    test("should emit loading then error state after event is added -> usecase fails -> general failure", () async {
      // arrange
      when(mockTracklistUsecases.getTracklistUsecases()).thenAnswer((_) async => Left(TracklistGeneralFailure()));
      // act
      tracklistBloc.add(TrackListLoadingEvent());
      await untilCalled(mockTracklistUsecases.getTracklistUsecases());
      // assert later
      final expected = [TracklistStateError(message: "Oops, something went wrong.\nPlease restart the app!")];
      expectLater(tracklistBloc.stream, emitsInOrder(expected));
      // assert
      verify(mockTracklistUsecases.getTracklistUsecases());
      verifyNoMoreInteractions(mockTracklistUsecases);
    });


  });
}
