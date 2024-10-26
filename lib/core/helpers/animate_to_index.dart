import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:orangejam/injection.dart' as di;
import '../../application/playlists/playlists_bloc.dart';
import '../player/audiohandler.dart';

// this is used to jump to currently playing track in list
void gotoItem(double offset, ListObserverController observerController, BuildContext context ) {
  observerController.animateTo(
    alignment: 0,
    index: getIndex(context),
    offset: (_) => offset,
    isFixedHeight: true,
    padding: const EdgeInsets.only(bottom: 200),
    duration: const Duration(milliseconds: 1000),
    curve: Curves.easeInOut,
  );
}

int getIndex(BuildContext context){
  // we need current index in case user sorted or filtered the list
  return BlocProvider.of<PlaylistsBloc>(context).state.tracks
      .indexWhere((element) => element.id == di.sl<MyAudioHandler>().currentTrack.id);
}