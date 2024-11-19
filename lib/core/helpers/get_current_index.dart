import 'package:flutter/material.dart';
import 'package:orangejam/domain/entities/track_entity.dart';

import '../../injection.dart' as di;
import '../player/audiohandler.dart';

int getIndex(BuildContext context, List<TrackEntity> tracks) {
  // we need current index in case user sorted or filtered the list
  return tracks.indexWhere(
      (element) => element.id == di.sl<MyAudioHandler>().currentTrack.id);
}
