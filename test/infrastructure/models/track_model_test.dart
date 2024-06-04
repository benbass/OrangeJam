
import 'package:flutter_test/flutter_test.dart';
import 'package:orange_player/domain/entities/track_entity.dart';
import 'package:orange_player/infrastructure/models/track_model.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tTrackmodel = TrackModel(
      id: 1,
      file: fixture("mp3.mp3"),
      trackName: "test",
      trackArtistNames: "artist",
      albumName: null,
      trackNumber: null,
      albumLength: null,
      year: 2018,
      genre: null,
      trackDuration: null,
      albumArt: null,
      albumArtist: null);

  test("model should be subclass of TrackEntity", () {
    expect(tTrackmodel, isA<TrackEntity>());
  });

}
