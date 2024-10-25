import 'package:flutter/material.dart';

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
