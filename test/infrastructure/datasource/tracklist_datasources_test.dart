
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:orange_player/infrastructure/datasources/audiofiles_datasources.dart';
import 'package:orange_player/infrastructure/models/track_model.dart';
import 'package:flutter/material.dart';

import 'tracklist_datasources_test.mocks.dart';

@GenerateMocks([AudioFilesDataSources])
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  late MockAudioFilesDataSources mockAudioFilesDataSources;

  setUp(() {
    mockAudioFilesDataSources = MockAudioFilesDataSources();
  });

  final tTracklist = [
    TrackModel(
        filePath: "",
        trackName: "trackName",
        trackArtistNames: "trackArtistNames",
        albumName: null,
        trackNumber: null,
        albumLength: null,
        year: null,
        genre: null,
        trackDuration: null,
        albumArt: null,
        albumArtist: null).copyWith(id: 1)
  ];

  test("should return a tracklist when getAudioFiles successes", () async {
    when(mockAudioFilesDataSources.getAudioFiles()).thenAnswer((_) async => tTracklist);

    final result = await mockAudioFilesDataSources.getAudioFiles();

    verify(mockAudioFilesDataSources.getAudioFiles());
    expect(result, tTracklist);
    verifyNoMoreInteractions(mockAudioFilesDataSources);
  });


}
