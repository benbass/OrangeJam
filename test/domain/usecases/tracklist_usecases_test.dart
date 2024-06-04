import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:orange_player/domain/entities/track_entity.dart';
import 'package:orange_player/domain/failures/tracklist_failures.dart';
import 'package:orange_player/domain/repositories/tracklist_repository.dart';
import 'package:orange_player/domain/usecases/tracklist_usecases.dart';

import 'tracklist_usecases_test.mocks.dart';

@GenerateMocks([TracklistRepository])
void main()  {

  late TracklistUsecases tracklistUsecases;
  late MockTracklistRepository mockTracklistRepository;

  setUp(() {
    mockTracklistRepository = MockTracklistRepository();
    tracklistUsecases = TracklistUsecases(tracklistRepository: mockTracklistRepository);
  });

  group("tracklistUsecases", () {

    final tTracklist = <TrackEntity>[TrackEntity(id: 1, file: File("file"), trackName: "trackName", trackArtistNames: "null", albumName: null, trackNumber: 0, albumLength: 1, year: 2000, genre: "genre", trackDuration: null, albumArt: null, albumArtist: null)];

    test("should return the same list of trackEntities as repo", () async {
      // arrange
      when(mockTracklistRepository.getTracklistFromDevice()).thenAnswer((_) async => Right(tTracklist));

      // act
      final result = await tracklistUsecases.getTracklistUsecases();

      // assert
      expect(result, Right(tTracklist));
      verify(mockTracklistRepository.getTracklistFromDevice());
      verifyNoMoreInteractions(mockTracklistRepository);
    });

    test("should return the same failure as repo", () async {
      // arrange
      when(mockTracklistRepository.getTracklistFromDevice()).thenAnswer((_) async => Left(TracklistIoFailure()));

      // act
      final result = await tracklistUsecases.getTracklistUsecases();

      // assert
      expect(result, Left(TracklistIoFailure()));
      verify(mockTracklistRepository.getTracklistFromDevice());
      verifyNoMoreInteractions(mockTracklistRepository);
    });

  });

}
