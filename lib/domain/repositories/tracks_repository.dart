import 'package:dartz/dartz.dart';
import '../entities/track_entity.dart';
import '../failures/tracks_failures.dart';

/// gets audio files, their metadata, transform into entity, save them in db and return a list from db in case of success
abstract class TracksRepository{
 Future<Either<TracksFailure, List<TrackEntity>>> getTracksFromDevice();
}