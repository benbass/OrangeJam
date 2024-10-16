import 'package:flutter/material.dart';

import '../../../../application/listview/data/tracks_bloc.dart';
import '../../../../generated/l10n.dart';
import '../../dialogs/dialogs.dart';

// Icon + : create a new playlist
class TopBarPlaylistsMenu extends StatelessWidget {
  const TopBarPlaylistsMenu({
    super.key,
    required this.tracksBlock,
  });

  final TracksBloc tracksBlock;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //const Spacer(),
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            dialogCreatePlaylist(S.of(context).playlistsMenu_NewPlaylist, []);
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