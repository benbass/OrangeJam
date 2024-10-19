import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/application/playlists/playlists_bloc.dart';

import '../../../../application/listview/data/tracks_bloc.dart';
import '../../playlists_menu/bottom_sheet_playlists_menu.dart';

// This button opens the playlist menu
class PlaylistsMenuButton extends StatelessWidget {
  final ScrollController scrollController;

  const PlaylistsMenuButton({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);
    final tracksBlock = BlocProvider.of<TracksBloc>(context);

    return IconButton(
      // padding + constraints as following removes padding from IconButton!
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () => {
        showModalBottomSheet(
          context: context,
          shape: const ContinuousRectangleBorder(),
          builder: (context) {
            return BottomSheetPlaylistsMenu(
              scrollController: scrollController,
              tracksBlock: tracksBlock,
              playlistsBloc: playlistsBloc,
            );
          },
        ),
      },
      icon: Image.asset(
        "assets/playlist.png",
        height: 40,
      ),
    );
  }
}
