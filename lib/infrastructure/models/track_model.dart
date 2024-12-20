import 'dart:io';
import 'package:path/path.dart' as aspath;

import 'package:metadata_god/metadata_god.dart';
//import 'package:audiotags/audiotags.dart';
import 'package:orangejam/domain/entities/track_entity.dart';

class TrackModel extends TrackEntity {
  TrackModel({
    required super.filePath,
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

  /// creates a track with metadata: used in metaTagsHandler
  // version for metadata_god
  factory TrackModel.metaData(Metadata metadata, File file) {
    // track name: from metadata. If this field is null, we use the file name.
    return TrackModel(
      filePath: file.path,
      trackName: metadata.title ?? aspath.basenameWithoutExtension(file.path),
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

  // Version for audiotags
 /*
  factory TrackModel.metaData(Tag metadata, File file) {
    // track name: from metadata. If this field is null, we use the file name.
    return TrackModel(
      filePath: file.path,
      trackName: metadata.title ?? aspath.basenameWithoutExtension(file.path),
      trackArtistNames: metadata.trackArtist ?? "",
      albumName: metadata.album ?? "",
      trackNumber: metadata.trackNumber,
      albumLength: metadata.trackTotal,
      year: metadata.year,
      genre: metadata.genre ?? "",
      trackDuration: metadata.duration?.toDouble(),
      albumArt: metadata.pictures.first.bytes,
      albumArtist: metadata.albumArtist,
    );
  }*/

  factory TrackModel.ios(Map map) {
    return TrackModel(
      filePath: map['assetUrl'],
      trackName: map['title'] ?? aspath.basenameWithoutExtension(map['assetUrl']),
      trackArtistNames: map['artist'],
      albumName: map['album'],
      trackNumber: map['trackNumber'],
      albumLength: map['albumLength'],
      year: map['year'],
      genre: map['genre'],
      trackDuration: map['duration'] != null ? map['duration']*1000 : null, // we get the duration in seconds but we use milliseconds
      albumArt: map['albumArt'],
      albumArtist: map['albumArtist'],
    );
  }

}
