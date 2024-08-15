import 'package:dartz/dartz.dart';
import 'package:orangejam/domain/entities/track_entity.dart';
import 'package:orangejam/domain/repositories/tracklist_repository.dart';
import '../failures/tracklist_failures.dart';

class TracklistUsecases {
  final TracklistRepository tracklistRepository;

  TracklistUsecases({required this.tracklistRepository});

  Future<Either<TracklistFailure, List<TrackEntity>>> getTracklistUsecases() async {
    return tracklistRepository.getTracklistFromDevice();
  }
}
