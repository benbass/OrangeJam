import 'dart:async';
import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:orangejam/core/metatags/metatags_handler.dart';
import 'package:orangejam/domain/failures/tracks_failures.dart';
import 'package:orangejam/infrastructure/datasources/audiofiles_datasources.dart';
import '../../injection.dart';

import '../../domain/entities/track_entity.dart';
import '../exceptions/exceptions.dart';

// this transforms the files from AudioFilesDataSources to track entities including metadata and saves them to db then return the tracks from db
// unless it was already done then it just returns tracks from existing db
abstract class TracksDatasource {
  /// Requests a track from files list
  /// May throw exception if file cannot be read
  Future<List<TrackEntity>> getTracksFromFiles();
}

class TracksDatasourceImpl implements TracksDatasource {
  final AudioFilesDataSources audioFilesDataSources;

  TracksDatasourceImpl({required this.audioFilesDataSources});

  @override
  Future<List<TrackEntity>> getTracksFromFiles() async {
    /// if db is not empty, we work with its data: it speeds up the app start
    if (!trackBox.isEmpty()) {
      return trackBox.getAll();
    } else {
      /// if db is empty or if user rescan the device, we gets all files from device: time consuming!
      try {
        // First we load the file from device storage
        List audioFiles = await audioFilesDataSources.getAudioFiles();

        // Then we create a list of track entities from list of audio files
        List<TrackEntity> tracksFromFiles = await _handleFiles(audioFiles);

        // We clear the objectBox store (we want to (re)build the db)
        trackBox.removeAll();
        // and add all tracks at once
        trackBox.putMany(tracksFromFiles);
        return trackBox.getAll();
      } catch (e) {
        if (e is TracksIoFailure) {
          throw IOExceptionReadFiles();
        }
      }
      return [];
    }
  }

  // creates a sorted list of track entities (default is sorted by track name)
  Future<List<TrackEntity>> _handleFiles(List audioFiles) async {
    List<TrackEntity> tracksFromFiles = [];
    for (File file in audioFiles) {
      // creates a track entity with metadata from file
      TrackEntity track = await Future.value(sl<MetaTagsHandler>().readTags(file));
      tracksFromFiles.add(track);
    }
    // let initial list be sorted by track names asc
    tracksFromFiles.sort((a, b) =>
        removeDiacritics(a.trackName ?? a.trackName!.toLowerCase()).compareTo(
            removeDiacritics(b.trackName ?? b.trackName!.toLowerCase())));
    return tracksFromFiles;
  }
}
