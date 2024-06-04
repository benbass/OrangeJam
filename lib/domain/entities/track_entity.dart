import 'dart:io';
import 'dart:typed_data';

class TrackEntity {
  final int id;
  final File file;
  final String trackName;
  //final List<String>? trackArtistNames;
  String trackArtistNames;
  final String? albumName;
  final int? trackNumber;
  final int? albumLength;
  final int? year;
  final String? genre;
  final double? trackDuration;
  //final int? bitrate;
  final Uint8List? albumArt;
  final String? albumArtist;

  late List<TrackEntity> adjacentNodes;

  TrackEntity({
    required this.id,
    required this.file,
    required this.trackName,
    required this.trackArtistNames,
    required this.albumName,
    required this.trackNumber,
    required this.albumLength,
    required this.year,
    required this.genre,
    required this.trackDuration,
    //required this.bitrate,
    required this.albumArt,
    required this.albumArtist,
  }) {
    adjacentNodes = [];
  }

  TrackEntity clone() {
    return TrackEntity(
      id: id,
      file: file,
      trackName: trackName,
      trackArtistNames: trackArtistNames,
      albumName: albumName,
      trackNumber: trackNumber,
      albumLength: albumLength,
      year: year,
      genre: genre,
      trackDuration: trackDuration ?? 0,
      //bitrate: bitrate,
      albumArt: albumArt,
      albumArtist: albumArtist,
    )..adjacentNodes = adjacentNodes.map((item) => item.clone()).toList();
  }

  factory TrackEntity.empty() {
    return TrackEntity(
      id: -1,
      file: File(""),
      trackName: "",
      trackArtistNames: "",
      albumName: null,
      trackNumber: null,
      albumLength: null,
      year: null,
      genre: null,
      trackDuration: null,
      albumArt: null,
      albumArtist: null,
    );
  }

  TrackEntity copyWith({
    int? id,
    File? file,
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
      id: id ?? this.id,
      file: file ?? this.file,
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
