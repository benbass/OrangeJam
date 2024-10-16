import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:orangejam/domain/usecases/tracks_usecases.dart';

import '../../../domain/entities/track_entity.dart';
import '../../../domain/failures/tracks_failures.dart';

part 'tracks_event.dart';
part 'tracks_state.dart';

// first action on app start: we get the list of track entities
class TracksBloc extends Bloc<TracksEvent, TracksState> {
  final TracksUsecases tracksUsecase;

  TracksBloc({required this.tracksUsecase}) : super(TracksInitial()) {
    on<TracksLoadingEvent>((event, emit) async {
      Either<TracksFailure, List<TrackEntity>> failureOrTracklist =
          await tracksUsecase.getTracksUsecases();

      failureOrTracklist.fold(
          (failure) =>
              emit(TracksStateError(message: _mapFailureToMessage(failure))),
          (tracklist) {
        emit(TracksStateLoading(tracks: tracklist));
      });
    });

    on<TracksRefreshingEvent>((event, emit) async {
      emit(TracksInitial());
    });

    on<TracksLoadedEvent>((event, emit) async {
      emit(TracksStateLoaded());
    });
  }

  String _mapFailureToMessage(TracksFailure failure) {
    switch (failure.runtimeType) {
      case const (TracksIoFailure):
        return "Oops, an error occurred while reading your files.\nPlease restart the app!";
      case const (TracksGeneralFailure):
        return "Oops, something went wrong.\nPlease restart the app!";
      default:
        return "Oops, something went wrong.\nPlease restart the app!";
    }
  }
}
