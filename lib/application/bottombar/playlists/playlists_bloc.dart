import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as aspath;
import 'package:diacritic/diacritic.dart';

import '../../../domain/entities/track_entity.dart';
import '../../../domain/usecases/playlists_usecases.dart';

part 'playlists_event.dart';
part 'playlists_state.dart';

class GlobalLists {
  static final GlobalLists _globalLists = GlobalLists._internal();
  factory GlobalLists() {
    return _globalLists;
  }
  GlobalLists._internal();
  List<TrackEntity> initialTracks = [];
  List<TrackEntity> queue = [];
}

class PlaylistsBloc extends Bloc<PlaylistsEvent, PlaylistsState> {
  final PlaylistsUsecases playlistsUsecases;
  PlaylistsBloc({required this.playlistsUsecases})
      : super(PlaylistsState.initial()) {

    final Future<SharedPreferences> startPrefs =
        SharedPreferences.getInstance();

    final globalLists = GlobalLists();

    on<PlaylistsLoadingEvent>((event, emit) async {
      // create a copy of the list of track entities
      globalLists.initialTracks = event.tracks;

      // load id of last opened playlist from SharedPrefs so app starts with it
      int savedId =
          await startPrefs.then((value) => value.getInt("startWith") ?? -2);
      // We don't save queue so we get rid of id -1 at next app start
      if (savedId == -1) {
        savedId = -2;
      }
      // load all playlists from Hive
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
      // User select a playlist
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
        // User selects the queue
      } else if (event.id == -1) {
        tracks = globalLists.queue;
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
      // If current playlist is deleted we change to all files
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

    /// Sorting and filtering
    on<PlaylistSorted>((event, emit) async {
      List<TrackEntity>? tracklist = state.tracks;
      bool wasReset = false;
      switch (event.sortBy) {
        case "File name":
          {
            tracklist.sort((a, b) => aspath
                .basename(a.filePath.toLowerCase())
                .compareTo(aspath.basename(b.filePath.toLowerCase())));
          }
          break;
        case "Track name":
          {
            tracklist.sort((a, b) =>
                removeDiacritics(a.trackName!.toLowerCase())
                    .compareTo(removeDiacritics(b.trackName!.toLowerCase())));
          }
          break;
        case "Artist":
          {
            tracklist.sort((a, b) =>
                removeDiacritics(a.trackArtistNames!.toLowerCase()).compareTo(
                    removeDiacritics(b.trackArtistNames!.toLowerCase())));
          }
          break;
        case "Genre":
          {
            tracklist.sort((a, b) => removeDiacritics(a.genre!.toLowerCase())
                .compareTo(removeDiacritics(b.genre!.toLowerCase())));
          }
          break;
        case "Creation date":
          {
            tracklist.sort((a, b) => File(b.filePath)
                .statSync()
                .modified
                .compareTo(File(a.filePath).statSync().modified));
          }
          break;
        case "Shuffle":
          {
            tracklist.shuffle();
          }
          break;
        case "Reset":
          {
            tracklist.clear();
            for (TrackEntity el in globalLists.initialTracks) {
              tracklist.add(el);
            }
            wasReset = true;
          }
          break;
        default:
          {}
          break;
      }
      if (!event.ascending && !wasReset) {
        tracklist = tracklist.reversed.toList();
      }
      emit(state.copyWith(tracks: tracklist));
      wasReset = false;
    });

    on<PlaylistFiltered>((event, emit) async {
      List<TrackEntity>? tracklist = state.tracks;
      List<TrackEntity> results = [];
      switch (event.filterdBy) {
        case "Artist":
          {
            for (var track in tracklist) {
              if (event.value != "#") {
                if (track.trackArtistNames != "" &&
                        track.trackArtistNames != " " ||
                    track.albumArtist != null) {
                  if (track.trackArtistNames!.trim() == event.value ||
                      track.albumArtist?.trim() == event.value) {
                    results.add(track);
                  }
                }
              } else if (track.trackArtistNames == "" ||
                  track.trackArtistNames == " " && track.albumArtist == null) {
                results.add(track);
              }
            }
          }
          break;
        case "Album":
          {
            for (var track in tracklist) {
              if (event.value != "#") {
                if (track.albumName != null &&
                    track.albumName != "" &&
                    track.albumName != " ") {
                  if (track.albumName!.trim() == event.value) {
                    results.add(track);
                  }
                }
              } else if (track.albumName == null ||
                  track.albumName == "" ||
                  track.albumName == " ") {
                results.add(track);
              }
            }
          }
          break;
        case "Genre":
          {
            for (var track in tracklist) {
              if (event.value != "#") {
                if (track.genre != null && track.genre != "") {
                  if (track.genre!.trim() == event.value) {
                    results.add(track);
                  }
                }
              } else if (track.genre == null || track.genre == "") {
                results.add(track);
              }
            }
          }
          break;
        case "Year":
          {
            for (var track in tracklist) {
              if (event.value != "#") {
                if (track.year != null &&
                    track.year != 0 &&
                    track.year.toString() != "null" &&
                    track.year.toString() != "" &&
                    track.year.toString() != " ") {
                  if (track.year?.toString() == event.value) {
                    results.add(track);
                  }
                }
              } else if (track.year == null ||
                  track.year == 0 ||
                  track.year.toString() == "null" ||
                  track.year.toString() == "" ||
                  track.year.toString() == " ") {
                results.add(track);
              }
            }
          }
          break;
      }
      emit(state.copyWith(tracks: results));
    });

    on<PlaylistSearchedByKeyword>((event, emit) async {
      List<TrackEntity> results = [];
      List<TrackEntity>? tracklist = state.tracks;

      if (event.keyword == null) {
        for (TrackEntity track in globalLists.initialTracks) {
          results.add(track);
        }
      } else {
        for (var track in tracklist) {
          if (track.filePath
                  .toLowerCase()
                  .contains(event.keyword!.toLowerCase()) ||
              (track.trackArtistNames!
                  .toLowerCase()
                  .contains(event.keyword!.toLowerCase())) ||
              track.trackName!
                  .toLowerCase()
                  .contains(event.keyword!.toLowerCase()) ||
              (track.albumName != null &&
                  track.albumName!
                      .toLowerCase()
                      .contains(event.keyword!.toLowerCase())) ||
              (track.genre != null &&
                  track.genre!
                      .toLowerCase()
                      .contains(event.keyword!.toLowerCase())) ||
              (track.year != null &&
                  track.year!
                      .toString()
                      .contains(event.keyword!.toLowerCase())) ||
              event.keyword!.isEmpty) {
            results.add(track);
          }
        }
      }

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

    on<TrackRemoveFromQueue>((event, emit) async {
      globalLists.queue.remove(event.track);
      emit(state.copyWith(tracks: globalLists.queue));
    });

    on<ClearQueue>((event, emit) async {
      globalLists.queue.clear();
      emit(state.copyWith(tracks: globalLists.queue));
    });

    /// End queue
  }
}
