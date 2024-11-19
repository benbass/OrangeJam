import 'dart:async';
import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/services.dart';
import 'package:orangejam/core/metatags/metatags_handler.dart';
import 'package:orangejam/domain/failures/tracks_failures.dart';
import 'package:orangejam/infrastructure/datasources/audiofiles_datasources.dart';
import 'package:orangejam/infrastructure/models/track_model.dart';
import '../../core/globals.dart';
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
        List<TrackEntity> tracksFromFiles = [];

        if (Platform.isAndroid) {
          // Android: First we load the files from device storage: we get file entities
          List audioFiles = await audioFilesDataSources.getAudioFiles();
          // We must read metadata before we can create entities
          tracksFromFiles = await _handleFiles(audioFiles);
        } else {
          tracksFromFiles = await _handleObjectsIos();
        }

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
      TrackEntity track =
          await Future.value(sl<MetaTagsHandler>().readTags(file));
      tracksFromFiles.add(track);
    }
    // let initial list be sorted by track names asc
    tracksFromFiles.sort((a, b) =>
        removeDiacritics(a.trackName ?? a.trackName!.toLowerCase()).compareTo(
            removeDiacritics(b.trackName ?? b.trackName!.toLowerCase())));
    return tracksFromFiles;
  }

  Future<List<TrackEntity>> _handleObjectsIos() async {
    List<TrackEntity> tracksFromFiles = [];
    Future getSongData() async {
      try {
        final List songData = await platform.invokeMethod('getSongData');
        return songData;
      } on PlatformException{
        //print("_________________________________________________________ERROR");
        return [];
      }
    }
    // iOS: First we load the files from music library: we get objects with assetUrls and metadata values
    List songData = await getSongData();
    // These objects already contain the metadata: we only need to create the entities
    for (var data in songData){
      TrackEntity track = TrackModel.ios(data);
      tracksFromFiles.add(track);
    }
    return tracksFromFiles;
  }

}
