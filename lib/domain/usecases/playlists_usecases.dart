import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:path/path.dart' as aspath;

import 'package:orangejam/domain/repositories/playlists_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/globals.dart';
import '../entities/track_entity.dart';

class PlaylistsUsecases {
  final PlaylistsRepository playlistsRepository;
  final SharedPreferences sharedPreferences;

  PlaylistsUsecases(
      {required this.playlistsRepository, required this.sharedPreferences});

  Future<List> getPlaylistsUsecase() async {
    return playlistsRepository.getPlaylistsFromM3uFiles();
  }

  int idFromPrefs() {
    // load id of last opened playlist from SharedPrefs so app starts with it
    int savedId = sharedPreferences.getInt("startWith") ?? -2;
    // We don't save queue so we get rid of id -1 at next app start
    if (savedId == -1) {
      savedId = -2;
    }

    return savedId;
  }

  void saveIdToPrefs(int id) {
    sharedPreferences.setInt("startWith", id);
  }

  List<TrackEntity> getInitialListAsPerPrefs(
      {required List<TrackEntity> initialTracks,
      required List playlists,
      required savedId}) {
    List<TrackEntity> tracks = [];

    // start with a playlist (id > -1) or with all files
    if (savedId > -1 && playlists.isNotEmpty) {
      if (playlists.asMap().containsKey(savedId)) {
        List selectedPlaylist = playlists[savedId][1];
        for (var el in selectedPlaylist) {
          for (var track in initialTracks) {
            if (track.filePath == el) {
              tracks.add(track);
            }
          }
        }
      }
    } else {
      for (TrackEntity track in initialTracks) {
        tracks.add(track);
      }
    }

    return tracks;
  }

  List<TrackEntity> playlistChanged({
    required List<TrackEntity> initialTracks,
    required List<TrackEntity> queue,
    required int id,
    required List playlists,
  }) {
    List<TrackEntity> tracks = [];

    saveIdToPrefs(id);

    // User selects a playlist
    if (id > -1 && playlists.isNotEmpty) {
      if (playlists.asMap().containsKey(id)) {
        List selectedPlaylist = playlists[id][1];
        for (var el in selectedPlaylist) {
          for (var track in initialTracks) {
            if (track.filePath == el) {
              tracks.add(track);
            }
          }
        }
      }
      // User selects the queue or queue content was modified while queue is current list
    } else if (id == -1) {
      for (TrackEntity track in queue) {
        tracks.add(track);
      }
      // User selects all files
    } else {
      for (TrackEntity track in initialTracks) {
        tracks.add(track);
      }
    }

    return tracks;
  }

  List<TrackEntity> sortedList(
      List<TrackEntity> tracks, String sortBy, bool ascending) {
    switch (sortBy) {
      case "File name":
        {
          tracks.sort((a, b) => aspath
              .basename(a.filePath.toLowerCase())
              .compareTo(aspath.basename(b.filePath.toLowerCase())));
        }
        break;
      case "Track name":
        {
          tracks.sort((a, b) => removeDiacritics(a.trackName!.toLowerCase())
              .compareTo(removeDiacritics(b.trackName!.toLowerCase())));
        }
        break;
      /*case "Artist":
      {
        tracks.sort((a, b) =>
            removeDiacritics(a.trackArtistNames!.toLowerCase()).compareTo(
                removeDiacritics(b.trackArtistNames!.toLowerCase())));
      }
      break;
    case "Genre":
      {
        tracks.sort((a, b) => removeDiacritics(a.genre!.toLowerCase())
            .compareTo(removeDiacritics(b.genre!.toLowerCase())));
      }
      break;*/
      case "Creation date":
        {
          tracks.sort((a, b) => File(b.filePath)
              .statSync()
              .modified
              .compareTo(File(a.filePath).statSync().modified));
        }
        break;
      case "Shuffle":
        {
          tracks.shuffle();
        }
        break;
      case "Reset":
        {
          tracks.clear();
          tracks = trackBox.getAll();
        }
        break;
      default:
        {}
        break;
    }

    bool wasReset = false;

    if (sortBy == "Reset") {
      wasReset = true;
    }

    if (!ascending && wasReset == false) {
      tracks = tracks.reversed.toList();
    }
    return tracks;
  }

  List<TrackEntity> filteredList(
      List<TrackEntity> tracks, String filterBy, String value) {
    List<TrackEntity> results = [];
    switch (filterBy) {
      case "Artist":
        {
          for (var track in tracks) {
            if (value != "#") {
              if (track.trackArtistNames != "" &&
                      track.trackArtistNames != " " ||
                  track.albumArtist != null) {
                if (track.trackArtistNames!.trim() == value ||
                    track.albumArtist?.trim() == value) {
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
          for (var track in tracks) {
            if (value != "#") {
              if (track.albumName != null &&
                  track.albumName != "" &&
                  track.albumName != " ") {
                if (track.albumName!.trim() == value) {
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
          for (var track in tracks) {
            if (value != "#") {
              if (track.genre != null && track.genre != "") {
                if (track.genre!.trim() == value) {
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
          for (var track in tracks) {
            if (value != "#") {
              if (track.year != null &&
                  track.year != 0 &&
                  track.year.toString() != "null" &&
                  track.year.toString() != "" &&
                  track.year.toString() != " ") {
                if (track.year?.toString() == value) {
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
    return results;
  }

  List<TrackEntity> searchedList({
    required String? keyword,
    required List<TrackEntity> initialTracks,
  }) {
    List<TrackEntity> results = [];

    if (keyword == null) {
      for (TrackEntity track in initialTracks) {
        results.add(track);
      }
    } else {
      for (var track in initialTracks) {
        if (track.filePath.toLowerCase().contains(keyword.toLowerCase()) ||
            (track.trackArtistNames!
                .toLowerCase()
                .contains(keyword.toLowerCase())) ||
            track.trackName!.toLowerCase().contains(keyword.toLowerCase()) ||
            (track.albumName != null &&
                track.albumName!
                    .toLowerCase()
                    .contains(keyword.toLowerCase())) ||
            (track.genre != null &&
                track.genre!.toLowerCase().contains(keyword.toLowerCase())) ||
            (track.year != null &&
                track.year!.toString().contains(keyword.toLowerCase())) ||
            keyword.isEmpty) {
          results.add(track);
        }
      }
    }
    return results;
  }
}
