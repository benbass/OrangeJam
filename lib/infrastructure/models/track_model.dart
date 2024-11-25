import 'package:path/path.dart' as aspath;

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
      trackDuration: map['duration']*1000, // we get the duration in seconds but we use milliseconds
      albumArt: map['albumArt'],
      albumArtist: map['albumArtist'],
    );
  }

}
