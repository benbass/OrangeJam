import 'package:dartz/dartz.dart';
import 'package:orangejam/domain/entities/track_entity.dart';
import 'package:orangejam/domain/repositories/tracks_repository.dart';
import '../failures/tracks_failures.dart';

class TracksUsecases {
  final TracksRepository tracksRepository;

  TracksUsecases({required this.tracksRepository});

  Future<Either<TracksFailure, List<TrackEntity>>> getTracksUsecases() async {
    return tracksRepository.getTracksFromDevice();
  }
}
