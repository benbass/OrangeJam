# OrangeJam audio player

Player for local audio files

## Features

Beautiful player for audio files located in the device's music folder.

- Supported audio files with flutter_sound package: mp3, flac, m4a, ogg, opus, wav (https://pub.dev/packages/flutter_sound)
  flutter_sound is using deprecated API and prevents other packages to be updated due to incompatible dependencies: it may be replaced in near future.
- Metadata with metadata_god package on mp3 (id3v2.4), m4a, flac, ogg and opus (https://pub.dev/packages/metadata_god)
- audiotgs (https://pub.dev/packages/audiotags) for writing metadata. metadata_god could theoretically be used for writing but with issues on art cover pictures (changes are ignored)
- Player notifications provided by awesome_notifications package. (https://pub.dev/packages/awesome_notifications)
- Data persistence for playlists via m3u files.
- Data persistence for tracks objects: Objectbox database package (https://pub.dev/packages/objectbox)

