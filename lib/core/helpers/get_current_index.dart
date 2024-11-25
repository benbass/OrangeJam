import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/playlists/playlists_bloc.dart';
import '../../injection.dart' as di;
import '../player/audiohandler.dart';

int getIndex(BuildContext context) {
  final tracks = context.read<PlaylistsBloc>().state.tracks;
  // we need current index in case user sorted or filtered the list
  return tracks.indexWhere(
      (element) => element.id == di.sl<MyAudioHandler>().id);
}
