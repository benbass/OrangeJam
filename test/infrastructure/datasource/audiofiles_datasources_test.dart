import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:orangejam/infrastructure/datasources/audiofiles_datasources.dart';

import '../../fixtures/fixture_reader.dart';
import 'audiofiles_datasources_test.mocks.dart';

@GenerateMocks([AudioFilesDataSources])
void main() {
  late MockAudioFilesDataSources mockAudioFilesDataSources;

  setUp(() {
    mockAudioFilesDataSources = MockAudioFilesDataSources();
  });

  final File file = fixture("test.mp3");
  final List<FileSystemEntity> list = [file];

  test("should return a list of FileSystemEntity when getAudioFiles successes",
      () async {
    when(mockAudioFilesDataSources.getAudioFiles())
        .thenAnswer((_) async => list);

    final result = await mockAudioFilesDataSources.getAudioFiles();

    verify(mockAudioFilesDataSources.getAudioFiles());
    expect(result, list);
    verifyNoMoreInteractions(mockAudioFilesDataSources);
  });
}
