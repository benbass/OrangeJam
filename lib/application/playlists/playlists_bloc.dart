import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:orange_player/core/manipulate_list/sort_filter_search_tracklist.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/globals.dart';
import '../../../domain/entities/track_entity.dart';
import '../../../domain/usecases/playlists_usecases.dart';

part 'playlists_event.dart';
part 'playlists_state.dart';



class PlaylistsBloc extends Bloc<PlaylistsEvent, PlaylistsState> {
  final PlaylistsUsecases playlistsUsecases;
  PlaylistsBloc({required this.playlistsUsecases})
      : super(PlaylistsState.initial()) {

    final Future<SharedPreferences> startPrefs =
        SharedPreferences.getInstance();

    final globalLists = GlobalLists();

    on<PlaylistsLoadingEvent>((event, emit) async {
      // create a copy of the list of track entities from data source
      globalLists.initialTracks = event.tracks;

      // load id of last opened playlist from SharedPrefs so app starts with it
      int savedId =
          await startPrefs.then((value) => value.getInt("startWith") ?? -2);
      // We don't save queue so we get rid of id -1 at next app start
      if (savedId == -1) {
        savedId = -2;
      }
      // load all playlists from m3u files, if any
      List playlists = await playlistsUsecases.getPlaylistsUsecase();
      List<TrackEntity> tracks = [];
      // start with a playlist (id > -1) or with all files
      if (savedId > -1 && playlists.isNotEmpty) {
        if (playlists.asMap().containsKey(savedId)) {
          List selectedPlaylist = playlists[savedId][1];
          for (var el in selectedPlaylist) {
            for (var track in globalLists.initialTracks) {
              if (track.filePath == el) {
                tracks.add(track);
              }
            }
          }
        }
      } else {
        for (TrackEntity track in globalLists.initialTracks) {
          tracks.add(track);
        }
      }
      emit(state.copyWith(
          tracks: tracks, playlists: playlists, playlistId: savedId));
    });

    on<PlaylistChanged>((event, emit) async {
      List<TrackEntity> tracks = [];
      // User selects a playlist
      if (event.id > -1 && state.playlists.isNotEmpty) {
        if (state.playlists.asMap().containsKey(event.id)) {
          List selectedPlaylist = state.playlists[event.id][1];
          for (var el in selectedPlaylist) {
            for (var track in globalLists.initialTracks) {
              if (track.filePath == el) {
                tracks.add(track);
              }
            }
          }
        }
        // User selects the queue or queue content was modified while queue is current list
      } else if (event.id == -1) {
        for (TrackEntity track in globalLists.queue) {
          tracks.add(track);
        }
        // User selects all files
      } else {
        for (TrackEntity track in globalLists.initialTracks) {
          tracks.add(track);
        }
      }
      emit(state.copyWith(tracks: tracks, playlistId: event.id));
      SharedPreferences myStart = await startPrefs;
      myStart.setInt("startWith", event.id);
    });

    on<PlaylistDeleted>((event, emit) async {
      // If current playlist is deleted we change view to all files
      List<TrackEntity> tracks = [];
      if (event.id == state.playlistId) {
        for (TrackEntity track in globalLists.initialTracks) {
          tracks.add(track);
        }
        emit(state.copyWith(tracks: tracks, playlistId: -2));
        SharedPreferences myStart = await startPrefs;
        myStart.setInt("startWith", -2);
      }
    });

    /// Sorting and filtering (only on all files)
    on<PlaylistSorted>((event, emit) async {
      List<TrackEntity> tracklist = sortedList(state.tracks, event.sortBy!);
      bool wasReset = false;

      if(event.sortBy == "Reset"){
        wasReset = true;
      }

      if (!event.ascending && wasReset == false) {
        tracklist = tracklist.reversed.toList();
      }

      emit(state.copyWith(tracks: tracklist));
      //wasReset = false;
    });

    on<PlaylistFiltered>((event, emit) async {
      List<TrackEntity> results = filteredList(state.tracks, event.filterBy, event.value);
      emit(state.copyWith(tracks: results));
    });

    on<PlaylistSearchedByKeyword>((event, emit) async {
      List<TrackEntity> results = searchedList(event.keyword);
      emit(state.copyWith(tracks: results));
    });
    /// End sorting and filtering

    /// Queue
    on<TrackAddedToQueue>((event, emit) async {
      globalLists.queue.add(event.track);
      // if current playlist is queue we update UI
      if (state.playlistId == -1) {
        emit(state.copyWith(tracks: globalLists.queue));
      }
    });

    /// the 2 following events occur only when queue is current list: we need to update UI with PlaylistChanged()
    /// so view will show the new state of the queue
    on<TrackRemoveFromQueue>((event, emit) async {
      globalLists.queue.remove(event.track);
      add(PlaylistChanged(id: -1));
    });

  on<ClearQueue>((event, emit) async {
      globalLists.queue.clear();
      add(PlaylistChanged(id: -1));
    });

    /// End queue
  }
}
