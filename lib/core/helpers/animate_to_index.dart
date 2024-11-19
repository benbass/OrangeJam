import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import '../../application/playlists/playlists_bloc.dart';
import 'get_current_index.dart';

// this is used to jump to currently playing track in list
void gotoItem(double offset, ListObserverController observerController, BuildContext context ) {
  final tracks = context.read<PlaylistsBloc>().state.tracks;
  observerController.animateTo(
    alignment: 0,
    index: getIndex(context, tracks),
    offset: (_) => offset,
    isFixedHeight: true,
    padding: const EdgeInsets.only(bottom: 200),
    duration: const Duration(milliseconds: 1000),
    curve: Curves.easeInOut,
  );
}

