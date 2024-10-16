import 'package:flutter/material.dart';
import 'package:orangejam/presentation/homepage/playlists_menu/widgets/playlist_button.dart';

import '../../../../application/playlists/playlists_bloc.dart';
import '../../../../core/globals.dart';
import '../../../../generated/l10n.dart';

// row of 2 buttons for "Files" and "Queue"
class FirstRowAllFilesAndQueueButtons extends StatelessWidget {
  const FirstRowAllFilesAndQueueButtons({
    super.key,
    required this.scrollController,
    required this.playlistsBloc,
  });

  final ScrollController scrollController;
  final PlaylistsBloc playlistsBloc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ButtonOpenPlaylist(
            scrollController: scrollController,
            playlistsBloc: playlistsBloc,
            id: -2,
            width: 120,
            name: S.of(context).files,
            length: GlobalLists().initialTracks.length.toString(),
          ),
          ButtonOpenPlaylist(
            scrollController: scrollController,
            playlistsBloc: playlistsBloc,
            id: -1,
            width: 120,
            name: S.of(context).queue,
            length: GlobalLists().queue.length.toString(),
          ),
        ],
      ),
    );
  }
}
