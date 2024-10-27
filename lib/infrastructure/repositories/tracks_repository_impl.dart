
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:orangejam/domain/entities/track_entity.dart';
import 'package:orangejam/domain/repositories/tracks_repository.dart';
import '../../domain/failures/tracks_failures.dart';
import '../datasources/tracks_datasources.dart';
import '../exceptions/exceptions.dart';

class TracksRepositoryImpl implements TracksRepository {
  final TracksDatasource tracksDataSources; // = TrackListDatasourceImpl();

  TracksRepositoryImpl({required this.tracksDataSources});

  @override
  Future<Either<TracksFailure, List<TrackEntity>>>
      getTracksFromDevice() async {

    try {
      final List<TrackEntity> tracks =
      await tracksDataSources.getTracksFromFiles();
      // create a copy of the list of all track entities from data source
      // this copy is needed for reset after sorting or filtering the list
      //sl<GlobalLists>().initialTracks = tracks;
      return Right(tracks);
    } catch (e) {
      if (e is IOExceptionReadFiles) { // instead of our IOExceptionReadFiles?
        return (Left(TracksIoFailure()));
      } else {
        return Left(TracksGeneralFailure());
      }
    }
  }
}
