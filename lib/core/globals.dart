import 'package:media_store_plus/media_store_plus.dart';

import '../domain/entities/track_entity.dart';
import '../objectbox.g.dart';

const String appName = "OrangeJam";

/// Provides access to the ObjectBox Store throughout the app.
late Box<TrackEntity> trackBox;

// We will use this plugin to be able to overwrite audio files in music library with updated metadata
final mediaStorePlugin = MediaStore();

