import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:orangejam/domain/entities/track_entity.dart';
import 'package:orangejam/domain/failures/tracks_failures.dart';
import 'package:orangejam/domain/repositories/tracks_repository.dart';
import 'package:orangejam/infrastructure/datasources/tracks_datasources.dart';
import 'package:orangejam/infrastructure/exceptions/exceptions.dart';
import 'package:orangejam/infrastructure/models/track_model.dart';
import 'package:orangejam/infrastructure/repositories/tracks_repository_impl.dart';

import 'tracks_repository_test.mocks.dart';

@GenerateMocks([TracksDatasource])
void main() {
  late TracksRepository tracksRepository;
  late MockTracksDatasource mockTracksDatasource;

  setUp(() {
    mockTracksDatasource = MockTracksDatasource();
    tracksRepository =
        TracksRepositoryImpl(tracksDataSources: mockTracksDatasource);
  });

  group("get tracks from device", () {
    final tTrackFromModel = <TrackModel>[
      TrackModel(
        filePath: "",
        trackName: "trackName",
        trackArtistNames: "null",
        albumName: null,
        trackNumber: 0,
        albumLength: 1,
        year: 2000,
        genre: "genre",
        trackDuration: null,
        albumArt: null,
        albumArtist: null,
      )
    ];
    final List<TrackEntity> tTracklistFromEntity = tTrackFromModel;

    test("should return modeled data from device", () async {
      when(mockTracksDatasource.getTracksFromFiles())
          .thenAnswer((_) async => tTrackFromModel);

      final result = await tracksRepository.getTracksFromDevice();

      verify(mockTracksDatasource.getTracksFromFiles());
      expect(result, Right(tTracklistFromEntity));
      verifyNoMoreInteractions(mockTracksDatasource);
    });

    test("should return IOFailure if datasource throws IOException", () async {
      when(mockTracksDatasource.getTracksFromFiles())
          .thenThrow(IOExceptionReadFiles());

      final result = await tracksRepository.getTracksFromDevice();

      verify(mockTracksDatasource.getTracksFromFiles());
      expect(result, Left(TracksIoFailure()));
      verifyNoMoreInteractions(mockTracksDatasource);
    });

    test("should return GeneralFailure if datasource throws other exception",
        () async {
      when(mockTracksDatasource.getTracksFromFiles()).thenThrow(Exception());

      final result = await tracksRepository.getTracksFromDevice();

      verify(mockTracksDatasource.getTracksFromFiles());
      expect(result, Left(TracksGeneralFailure()));
      verifyNoMoreInteractions(mockTracksDatasource);
    });
  });
}
