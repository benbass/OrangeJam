import 'dart:io';
import 'package:path/path.dart' as aspath;

import 'package:metadata_god/metadata_god.dart';
import 'package:orange_player/domain/entities/track_entity.dart';

class TrackModel extends TrackEntity {
  TrackModel({
    required super.id,
    required super.file,
    required super.trackName,
    required super.trackArtistNames,
    required super.albumName,
    required super.trackNumber,
    required super.albumLength,
    required super.year,
    required super.genre,
    required super.trackDuration,
    required super.albumArt,
    required super.albumArtist,
  });

  factory TrackModel.getMetaData(Metadata metadata, File file, int id) {
    // track name: from metadata. If this field is null, we use the file name.
    return TrackModel(
      id: id,
      file: file,
      trackName: metadata.title ?? aspath
          .basenameWithoutExtension(file.path),
      trackArtistNames: metadata.artist ?? "",
      albumName: metadata.album ?? "",
      trackNumber: metadata.trackNumber,
      albumLength: metadata.trackTotal,
      year: metadata.year,
      genre: metadata.genre ?? "",
      trackDuration: metadata.durationMs,
      albumArt: metadata.picture?.data,
      albumArtist: metadata.albumArtist,
    );

  }
}
