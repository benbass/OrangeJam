
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:orangejam/domain/entities/track_entity.dart';
import 'package:orangejam/domain/failures/tracks_failures.dart';
import 'package:orangejam/domain/repositories/tracks_repository.dart';
import 'package:orangejam/domain/usecases/tracks_usecases.dart';

import 'tracks_usecases_test.mocks.dart';

@GenerateMocks([TracksRepository])
void main()  {

  late TracksUsecases tracksUsecases;
  late MockTracksRepository mockTracksRepository;

  setUp(() {
    mockTracksRepository = MockTracksRepository();
    tracksUsecases = TracksUsecases(tracksRepository: mockTracksRepository);
  });

  group("tracksUsecases", () {

    final tTracklist = <TrackEntity>[TrackEntity(filePath: "", trackName: "trackName", trackArtistNames: "null", albumName: null, trackNumber: 0, albumLength: 1, year: 2000, genre: "genre", trackDuration: null, albumArt: null, albumArtist: null).copyWith(id: 1)];

    test("should return the same list of trackEntities as repo", () async {
      // arrange
      when(mockTracksRepository.getTracksFromDevice()).thenAnswer((_) async => Right(tTracklist));

      // act
      final result = await tracksUsecases.getTracksUsecases();

      // assert
      expect(result, Right(tTracklist));
      verify(mockTracksRepository.getTracksFromDevice());
      verifyNoMoreInteractions(mockTracksRepository);
    });

    test("should return the same failure as repo", () async {
      // arrange
      when(mockTracksRepository.getTracksFromDevice()).thenAnswer((_) async => Left(TracksIoFailure()));

      // act
      final result = await tracksUsecases.getTracksUsecases();

      // assert
      expect(result, Left(TracksIoFailure()));
      verify(mockTracksRepository.getTracksFromDevice());
      verifyNoMoreInteractions(mockTracksRepository);
    });

  });

}
