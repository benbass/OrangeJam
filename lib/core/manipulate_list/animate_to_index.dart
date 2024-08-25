import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:orangejam/injection.dart' as di;
import '../../application/playlists/playlists_bloc.dart';
import '../player/audiohandler.dart';
import '../globals.dart';

// this is used to jump to currently playing track in list
void gotoItem(double offset, ListObserverController observerController ) {
  // we need current index in case user sorted or filtered the list
  // 1. so first we get current track id
  int selectedTrackId = di.sl<MyAudioHandler>().currentTrack.id;

  // 2. and we need index of this current track in current list state
  int index = BlocProvider.of<PlaylistsBloc>(globalScaffoldKey.scaffoldKey.currentContext!).state.tracks
      .indexWhere((element) => element.id == selectedTrackId);

  // 3. we jump to index
  observerController.animateTo(
    alignment: 0,
    index: index,
    offset: (_) => offset,
    isFixedHeight: true,
    padding: const EdgeInsets.only(bottom: 200),
    duration: const Duration(milliseconds: 1000),
    curve: Curves.easeInOut,
  );
}