import 'package:flutter/material.dart';
import 'package:orange_player/presentation/homepage/custom_widgets/custom_widgets.dart';

import '../../../../application/listview/tracklist/tracklist_bloc.dart';
import '../../../../core/playlist_handler_and_dialogs.dart';
import '../../../../injection.dart';

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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
           dialogActionRestoreOrBackupPlaylists(context, "backup");
          },
          icon: const Icon(
            Icons.backup,
            size: 26,
            color: Color(0xFF181C25),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            dialogActionRestoreOrBackupPlaylists(context, "restore");
          },
          icon: const Icon(
            Icons.restore,
            size: 26,
            color: Color(0xFF181C25),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            trackBox.removeAll();
            tracklistBlock.add(TrackListRefreschingEvent());
          },
          icon: const Icon(
            Icons.refresh,
            size: 26,
            color: Color(0xFF181C25),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            playlistHandler.createPlaylist("New playlist:", []);
          },
          icon: const Icon(
            Icons.add,
            size: 26,
            color: Color(0xFF181C25),
          ),
        ),
      ],
    );
  }
}