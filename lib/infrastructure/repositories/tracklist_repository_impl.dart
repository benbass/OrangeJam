
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:orange_player/domain/entities/track_entity.dart';
import 'package:orange_player/domain/repositories/tracklist_repository.dart';
import '../../domain/failures/tracklist_failures.dart';
import '../datasources/tracklist_datasources.dart';
import '../exceptions/exceptions.dart';

class TracklistRepositoryImpl implements TracklistRepository {
  final TrackListDatasource tracklistDataSources; // = TrackListDatasourceImpl();

  TracklistRepositoryImpl({required this.tracklistDataSources});

  @override
  Future<Either<TracklistFailure, List<TrackEntity>>>
      getTracklistFromDevice() async {

    try {
      final List<TrackEntity> tracks =
      await tracklistDataSources.getTracksFromFiles();
      return Right(tracks);
    } catch (e) {
      if (e is IOExceptionReadFiles) { // instead of our IOExceptionReadFiles?
        return (Left(TracklistIoFailure()));
      } else {
        return Left(TracklistGeneralFailure());
      }
    }
  }
}
