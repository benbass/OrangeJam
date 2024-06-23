import 'dart:io';
import 'dart:typed_data';
import 'package:objectbox/objectbox.dart';

@Entity()
class TrackEntity {
  @Id()
  int id = 0;

  String filePath;
  String? trackName;
  String? trackArtistNames;
  String? albumName;
  int? trackNumber;
  int? albumLength;
  int? year;
  String? genre;
  double? trackDuration;

  @Property(type: PropertyType.byteVector)
  Uint8List? albumArt;
  
  String? albumArtist;

  TrackEntity({
    required this.filePath,
    required this.trackName,
    required this.trackArtistNames,
    required this.albumName,
    required this.trackNumber,
    required this.albumLength,
    required this.year,
    required this.genre,
    required this.trackDuration,
    required this.albumArt,
    required this.albumArtist,
  });

  factory TrackEntity.empty() {
    return TrackEntity(
      filePath: "",
      trackName: "",
      trackArtistNames: "",
      albumName: null,
      trackNumber: null,
      albumLength: null,
      year: null,
      genre: null,
      trackDuration: 0,
      albumArt: null,
      albumArtist: "",
    );
  }

  TrackEntity copyWith({
    int? id,
    String? filePath,
    String? trackName,
    String? trackArtistNames,
    String? albumName,
    int? trackNumber,
    int? albumLength,
    int? year,
    String? genre,
    double? trackDuration,
    Uint8List? albumArt,
    String? albumArtist,
  }) {
    return TrackEntity(
      filePath: filePath ?? this.filePath,
      trackName: trackName ?? this.trackName,
      trackArtistNames: trackArtistNames ?? this.trackArtistNames,
      albumName: albumName ?? this.albumName,
      trackNumber: trackNumber ?? this.trackNumber,
      albumLength: albumLength ?? this.albumLength,
      year: year ?? this.year,
      genre: genre ?? this.genre,
      trackDuration: trackDuration ?? this.trackDuration,
      albumArt: albumArt ?? this.albumArt,
      albumArtist: albumArtist ?? this.albumArtist,
    );
  }
}
