import 'package:dartz/dartz.dart';
import '../entities/track_entity.dart';
import '../failures/tracklist_failures.dart';

/// gets audio files, their metadata, transform into entity, save them in db and return a list from db in case of success
abstract class TracklistRepository{
 Future<Either<TracklistFailure, List<TrackEntity>>> getTracklistFromDevice();
}