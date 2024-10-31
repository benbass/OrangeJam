import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/playlists/playlists_bloc.dart';
import '../../injection.dart' as di;
import '../player/audiohandler.dart';

int getIndex(BuildContext context){
  // we need current index in case user sorted or filtered the list
  return context.read<PlaylistsBloc>().state.tracks
      .indexWhere((element) => element.id == di.sl<MyAudioHandler>().currentTrack.id);
}