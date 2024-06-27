import 'dart:async';
import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:orange_player/domain/failures/tracklist_failures.dart';
import 'package:orange_player/infrastructure/models/track_model.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:orange_player/infrastructure/datasources/audiofiles_datasources.dart';
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

  late List _audioFiles;
  List<TrackEntity> _tracks = [];

  @override
  Future<List<TrackEntity>> getTracksFromFiles() async {
    /// if db is not empty, we work with its data: it acceleartes the app start
    if(!trackBox.isEmpty()){
      _tracks = trackBox.getAll();
      return _tracks;
    } else {
      /// if db is empty or if user rescan the device, we gets all files from device: time consuming!
      List<TrackEntity> tracksFromFiles = [];
      try {
        // First we load the file from device storage
        _audioFiles = await audioFilesDataSources.getAudioFiles();
        // Then we create a track entity from track model based on retrieved metadata of each mp3 file
        // and we add it to our list of tracks
        for (File file in _audioFiles) {
          TrackEntity track = await Future.value(_createTrack(file));
          tracksFromFiles.add(track);
        }

        // let initial list be sorted by track names asc
        tracksFromFiles.sort((a, b) => removeDiacritics(a.trackName ?? a.trackName!.toLowerCase())
            .compareTo(removeDiacritics(b.trackName ?? b.trackName!.toLowerCase()))
        );

        // We clear the objectBox store (we rebuild the db)
        trackBox.removeAll();
        // and add all tracks at once
        trackBox.putMany(tracksFromFiles);
        _tracks = trackBox.getAll();
        return _tracks;
      } catch (e) {
        if (e is TracklistIoFailure) {
          throw IOExceptionReadFiles();
        }
      }
      return [];
    }
  }
  
  Future<TrackEntity> _createTrack(File file) => MetadataGod.readMetadata(
        file: file.path,
      )
          .then(
            (value) async =>
                // value throws a parseErrorData from dependency package FlutterRustBridgeBase for some files: some metadata may be corrupt or package is buggy?
                await Future.sync(
                        () => TrackModel.getMetaData(value, file))
                    .then((value) => value),
          );
  
}
