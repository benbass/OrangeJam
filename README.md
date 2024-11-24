# OrangeJam audio player

Player for local audio files

## Features

Player for audio files located in the device's music folder (music library)

- Supported audio files with flutter_sound package: mp3, flac, m4a, ogg, opus, wav (https://pub.dev/packages/flutter_sound)
  flutter_sound is using deprecated API and prevents other packages to be updated due to incompatible dependencies: it may be replaced in near future.
- Metadata with metadata_god package on mp3 (id3v2.4), m4a, flac, ogg and opus (https://pub.dev/packages/metadata_god)
- audiotags (https://pub.dev/packages/audiotags) for writing metadata. metadata_god could theoretically be used for writing but with issues on art cover pictures (changes are ignored)
- Player notifications provided by awesome_notifications package. (https://pub.dev/packages/awesome_notifications)
- Data persistence for playlists via m3u files.
- Data persistence for tracks objects: Objectbox database package (https://pub.dev/packages/objectbox)

## Technical notes
- IMPORTANT: this is the main branch to be used for Android.
- For iOS use main_ios branch.
  
- Project uses Google Services for OAuth: this project will run only with the google-service.json (Android) and the GoogleService-Info.plist (iOS) file from the developer's own firebase project.
- Android Studio Ladybug (2024.2...) is shipped with JDK 21. That causes compilation issue with plugins that expect JDK 17.
  That's why Flutter on machines running this app on Android emulator must be configured as follows:
  MacOS: flutter config --jdk-dir "/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home"
  Windows: flutter config --jdk-dir "C:\Program Files\Java\jdk-17"
  (adjust path to your jdk17 installation)

## Supported platforms
- Android: fully supported with plugin metadata_god: ^0.5.2+1. Newer version 1.0.0 causes build issues on real device.
- iOS: see readme in main_ios branch