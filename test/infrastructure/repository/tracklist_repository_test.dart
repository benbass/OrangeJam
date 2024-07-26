import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:orange_player/domain/entities/track_entity.dart';
import 'package:orange_player/domain/failures/tracklist_failures.dart';
import 'package:orange_player/domain/repositories/tracklist_repository.dart';
import 'package:orange_player/infrastructure/datasources/tracklist_datasources.dart';
import 'package:orange_player/infrastructure/exceptions/exceptions.dart';
import 'package:orange_player/infrastructure/models/track_model.dart';
import 'package:orange_player/infrastructure/repositories/tracklist_repository_impl.dart';

import 'tracklist_repository_test.mocks.dart';

@GenerateMocks([TrackListDatasource])
void main() {
  late TracklistRepository tracklistRepository;
  late MockTrackListDatasource mockTrackListDatasource;

  setUp(() {
    mockTrackListDatasource = MockTrackListDatasource();
    tracklistRepository =
        TracklistRepositoryImpl(tracklistDataSources: mockTrackListDatasource);
  });

  group("get tracklist from device", () {
    final tTracklistFromModel = <TrackModel>[
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
    final List<TrackEntity> tTracklistFromEntity = tTracklistFromModel;

    test("should return modeled data from device", () async {
      when(mockTrackListDatasource.getTracksFromFiles())
          .thenAnswer((_) async => tTracklistFromModel);

      final result = await tracklistRepository.getTracklistFromDevice();

      verify(mockTrackListDatasource.getTracksFromFiles());
      expect(result, Right(tTracklistFromEntity));
      verifyNoMoreInteractions(mockTrackListDatasource);
    });

    test("should return IOFailure if datasource throws IOException", () async {
      when(mockTrackListDatasource.getTracksFromFiles())
          .thenThrow(IOExceptionReadFiles());

      final result = await tracklistRepository.getTracklistFromDevice();

      verify(mockTrackListDatasource.getTracksFromFiles());
      expect(result, Left(TracklistIoFailure()));
      verifyNoMoreInteractions(mockTrackListDatasource);
    });

    test("should return GeneralFailure if datasource throws other exception",
        () async {
      when(mockTrackListDatasource.getTracksFromFiles()).thenThrow(Exception());

      final result = await tracklistRepository.getTracklistFromDevice();

      verify(mockTrackListDatasource.getTracksFromFiles());
      expect(result, Left(TracklistGeneralFailure()));
      verifyNoMoreInteractions(mockTrackListDatasource);
    });
  });
}
