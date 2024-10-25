import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:orangejam/domain/usecases/tracks_usecases.dart';

import '../../../core/globals.dart';
import '../../../domain/entities/track_entity.dart';
import '../../../domain/usecases/playlists_usecases.dart';
import '../../domain/failures/tracks_failures.dart';
import '../../injection.dart';

part 'playlists_event.dart';
part 'playlists_state.dart';

class PlaylistsBloc extends Bloc<PlaylistsEvent, PlaylistsState> {
  final PlaylistsUsecases playlistsUsecases;
  final TracksUsecases tracksUsecases;

  PlaylistsBloc({
    required this.playlistsUsecases,
    required this.tracksUsecases,
  }) : super(PlaylistsState.initial()) {
    String mapFailureToMessage(TracksFailure failure) {
      switch (failure.runtimeType) {
        case const (TracksIoFailure):
          return "Oops, an error occurred while reading your files.\nPlease restart the app!";
        case const (TracksGeneralFailure):
          return "Oops, something went wrong.\nPlease restart the app!";
        default:
          return "Oops, something went wrong.\nPlease restart the app!";
      }
    }

    on<PlaylistsTracksLoadingEvent>((event, emit) async {
      emit(state.copyWith(loading: true));

      Either<TracksFailure, List<TrackEntity>> failureOrTracklist =
          await tracksUsecases.getTracksUsecases();

      failureOrTracklist.fold(
        (failure) => emit(
          PlaylistsState.error(
            message: mapFailureToMessage(failure),
          ).copyWith(
            loading: false,
          ),
        ),
        (tracklist) {
          emit(
            state.copyWith(
              tracks: tracklist,
            ),
          );
          add(PlaylistsTracksLoadedEvent());
        },
      );
    });

    on<PlaylistsTracksLoadedEvent>((event, emit) async {
      // load all playlists from m3u files, if any
      List playlists = await playlistsUsecases.getPlaylistsUsecase();
      emit(state.copyWith(playlists: playlists));
      add(PlaylistsLoadedEvent());
    });

    on<PlaylistsLoadedEvent>((event, emit) async {
      // get last playlist id from Shared Prefs
      int savedId = playlistsUsecases.idFromPrefs();

      List<TrackEntity> tracks =
          playlistsUsecases.getInitialListAsPerPrefs(state.playlists, savedId);

      emit(
        state.copyWith(tracks: tracks, playlistId: savedId, loading: false),
      );
    });

    // This event is triggered when creating a new empty playlist (+ button in playlist menu with following dialog)
    // AND when saving queue to new playlist
    on<PlaylistCreated>((event, emit) async {
      List playlists = [...state.playlists];
      // add playlist-name and path-list from event to current playlists
      playlists.add([
        event.name,
        event.playlist
      ]);
      emit(state.copyWith(playlists: playlists));
    });

    on<PlaylistChanged>((event, emit) async {
      List playlists = state.playlists;
      List<TrackEntity> tracks =
          playlistsUsecases.playlistChanged(playlists: playlists, id: event.id);

      emit(state.copyWith(tracks: tracks, playlistId: event.id));
    });

    // If current playlist is deleted we change view to all files
    on<PlaylistDeleted>((event, emit) async {
      List<TrackEntity> tracks = [];
      if (event.id == state.playlistId) {
        for (TrackEntity track in sl<GlobalLists>().initialTracks) {
          tracks.add(track);
        }
        emit(state.copyWith(tracks: tracks, playlistId: -2));

        playlistsUsecases.saveIdToPrefs(-2);
      }
    });

    /// Sorting and filtering (only on all files)
    on<PlaylistSorted>((event, emit) async {
      List<TrackEntity> tracks = state.tracks;
      // we replace current state with empty list
      emit(state.copyWith(tracks: []));
      // we sort copy of current list
      List<TrackEntity> sortedTracklist =
          playlistsUsecases.sortedList(tracks, event.sortBy!, event.ascending);

      // we emit new list as new state
      emit(state.copyWith(tracks: sortedTracklist));
    });

    on<PlaylistFiltered>((event, emit) async {
      List<TrackEntity> results = playlistsUsecases.filteredList(
          state.tracks, event.filterBy, event.value);
      emit(state.copyWith(tracks: results));
    });

    on<PlaylistSearchedByKeyword>((event, emit) async {
      List<TrackEntity> results = playlistsUsecases.searchedList(event.keyword);
      emit(state.copyWith(tracks: results));
    });

    /// End sorting and filtering

    /// Queue
    on<TrackAddedToQueue>((event, emit) async {
      List<TrackEntity> tracks = playlistsUsecases.addTrackToQueue(event.track);
      // if current playlist is queue we update UI: following doesn't happen in current app version
      // because it would mean we are trying to add same track again and this is not allowed!
      if (state.playlistId == -1) {
        emit(state.copyWith(tracks: tracks));
      }
    });

    /// the 2 following events occur only when queue is current view
    on<TrackRemoveFromQueue>((event, emit) async {
      List<TrackEntity> tracks = playlistsUsecases.removeTrackFromQueue(event.track);
      emit(state.copyWith(tracks: tracks));
    });

    on<ClearQueue>((event, emit) async {
      List<TrackEntity> tracks = playlistsUsecases.clearQueue();
      emit(state.copyWith(tracks: tracks));
    });

    /// End queue
  }
}
