import 'package:flutter/material.dart';

import '../../../../application/listview/tracklist/tracklist_bloc.dart';
import '../../../../core/playlists/playlist_handler.dart';
import '../../../../generated/l10n.dart';
import '../../dialogs/dialogs.dart';

class TopBarPlaylistsMenu extends StatelessWidget {
  const TopBarPlaylistsMenu({
    super.key,
    required this.tracklistBlock,
    required this.playlistHandler,
  });

  final TracklistBloc tracklistBlock;
  final PlaylistHandler playlistHandler;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //const Spacer(),
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            dialogCreatePlaylist(S.of(context).playlistsMenu_NewPlaylist, [], playlistHandler);
          },
          icon: const Icon(
            Icons.add,
            size: 32,
            color: Color(0xFF181C25),
          ),
        ),
      ],
    );
  }
}