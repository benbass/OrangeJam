import 'dart:async';
import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:orange_player/domain/failures/tracklist_failures.dart';
import 'package:orange_player/infrastructure/models/track_model.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:orange_player/infrastructure/datasources/audiofiles_datasources.dart';

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
    List<TrackEntity> tracks = [];
    int id = 0;

    // First we load the file from device storage
    late List audioFiles;

    try {
      audioFiles = await audioFilesDataSources.getAudioFiles();
    } catch (e) {
      if (e is TracklistIoFailure) {
        throw IOExceptionReadFiles();
      }
    }

    // let initial list be sorted by track names asc
    sort() {
      tracks.sort((a, b) => removeDiacritics(a.trackName.toLowerCase())
          .compareTo(removeDiacritics(b.trackName.toLowerCase())));
    }

    // Then we create a track entity from track model based on retrieved metadata of each mp3 file
    // and we add it to our list of tracks
    Future<TrackEntity> createTrack(File file) => MetadataGod.readMetadata(
          file: file.path,
        )
            .then((value) async =>
                  // value throws a parseErrorData from dependency package FlutterRustBridgeBase for some files: some metadata may be corrupt or package is buggy?
                   await Future.sync(() => TrackModel.getMetaData(value, file, id++)).then((value) => value),
                )
            .whenComplete(() => sort());

    for (File file in audioFiles) {
      TrackEntity track = await Future.value(createTrack(file));
      tracks.add(track);
    }

    return tracks;
  }
}
