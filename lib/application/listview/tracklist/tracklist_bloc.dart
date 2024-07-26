import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:orange_player/domain/usecases/tracklist_usecases.dart';

import '../../../domain/entities/track_entity.dart';
import '../../../domain/failures/tracklist_failures.dart';

part 'tracklist_event.dart';
part 'tracklist_state.dart';

class TracklistBloc extends Bloc<TracklistEvent, TracklistState> {
  final TracklistUsecases tracklistUsecase;

  TracklistBloc({required this.tracklistUsecase}) : super(TracklistInitial()) {
    on<TrackListLoadingEvent>((event, emit) async {
      Either<TracklistFailure, List<TrackEntity>> failureOrTracklist =
          await tracklistUsecase.getTracklistUsecases();

      failureOrTracklist.fold(
          (failure) =>
              emit(TracklistStateError(message: _mapFailureToMessage(failure))),
          (tracklist) {
        emit(TracklistStateLoading(tracks: tracklist));
      });
    });

    on<TrackListRefreschingEvent>((event, emit) async {
      emit(TracklistInitial());
    });

    on<TrackListLoadedEvent>((event, emit) async {
      emit(TracklistStateLoaded());
    });
  }

  String _mapFailureToMessage(TracklistFailure failure) {
    switch (failure.runtimeType) {
      case const (TracklistIoFailure):
        return "Oops, an error occurred while reading your files.\nPlease restart the app!";
      case const (TracklistGeneralFailure):
        return "Oops, something went wrong.\nPlease restart the app!";
      default:
        return "Oops, something went wrong.\nPlease restart the app!";
    }
  }
}
