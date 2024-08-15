import 'dart:async';
import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:orangejam/domain/failures/tracklist_failures.dart';
import 'package:orangejam/infrastructure/models/track_model.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:orangejam/infrastructure/datasources/audiofiles_datasources.dart';
import '../../injection.dart';

import '../../domain/entities/track_entity.dart';
import '../exceptions/exceptions.dart';

abstract class TrackListDatasource {
  /// Requests a track from files list
  /// May throw exception if file cannot be read
  Future<List<TrackEntity>> getTracksFromFiles();
}

class TrackListDatasourceImpl implements TrackListDatasource {
  final AudioFilesDataSources audioFilesDataSources;

  TrackListDatasourceImpl({required this.audioFilesDataSources});

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
        if (e is TracklistIoFailure) {
          throw IOExceptionReadFiles();
        }
      }
      return [];
    }
  }

  Future<List<TrackEntity>> _handleFiles(List audioFiles) async {
    List<TrackEntity> tracksFromFiles = [];
    for (File file in audioFiles) {
      TrackEntity track = await Future.value(_createTrack(file));
      tracksFromFiles.add(track);
    }
    // let initial list be sorted by track names asc
    tracksFromFiles.sort((a, b) =>
        removeDiacritics(a.trackName ?? a.trackName!.toLowerCase()).compareTo(
            removeDiacritics(b.trackName ?? b.trackName!.toLowerCase())));
    return tracksFromFiles;
  }

  Future<TrackEntity> _createTrack(File file) => MetadataGod.readMetadata(
        file: file.path,
      ).then(
        (value) async =>
            // value throws a parseErrorData from dependency package FlutterRustBridgeBase for some files: some metadata may be corrupt or package is buggy?
            await Future.sync(() => TrackModel.getMetaData(value, file))
                .then((value) => value),
      );
}
