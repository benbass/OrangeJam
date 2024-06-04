import 'package:dartz/dartz.dart';
import '../entities/track_entity.dart';
import '../failures/tracklist_failures.dart';

abstract class TracklistRepository{
 Future<Either<TracklistFailure, List<TrackEntity>>> getTracklistFromDevice();
}