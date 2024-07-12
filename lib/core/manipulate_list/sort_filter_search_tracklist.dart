import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:path/path.dart' as aspath;
import '../../domain/entities/track_entity.dart';
import '../../injection.dart';
import '../globals.dart';

final globalLists = GlobalLists();

List<TrackEntity> sortedList(List<TrackEntity> tracks, String sortBy){
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
        tracks.sort((a, b) =>
            removeDiacritics(a.trackName!.toLowerCase())
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
  return tracks;
}

List<TrackEntity> filteredList(List<TrackEntity> tracks, String filterBy, String value){
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

List<TrackEntity> searchedList(String? keyword){
  List<TrackEntity> results = [];

  if (keyword == null) {
    for (TrackEntity track in globalLists.initialTracks) {
      results.add(track);
    }
  } else {
    for (var track in globalLists.initialTracks) {
      if (track.filePath
          .toLowerCase()
          .contains(keyword.toLowerCase()) ||
          (track.trackArtistNames!
              .toLowerCase()
              .contains(keyword.toLowerCase())) ||
          track.trackName!
              .toLowerCase()
              .contains(keyword.toLowerCase()) ||
          (track.albumName != null &&
              track.albumName!
                  .toLowerCase()
                  .contains(keyword.toLowerCase())) ||
          (track.genre != null &&
              track.genre!
                  .toLowerCase()
                  .contains(keyword.toLowerCase())) ||
          (track.year != null &&
              track.year!
                  .toString()
                  .contains(keyword.toLowerCase())) ||
          keyword.isEmpty) {
        results.add(track);
      }
    }
  }
  return results;
}