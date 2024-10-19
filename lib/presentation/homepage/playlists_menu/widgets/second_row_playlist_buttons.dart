import 'package:flutter/material.dart';
import 'package:orangejam/presentation/homepage/playlists_menu/widgets/open_playlist_button.dart';

import '../../../../application/playlists/playlists_bloc.dart';

// list of buttons for each playlist
class SecondRowPlaylistButtons extends StatelessWidget {
  const SecondRowPlaylistButtons({
    super.key,
    required this.scrollController,
    required this.playlistsBloc,
  });

  final ScrollController scrollController;
  final PlaylistsBloc playlistsBloc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: playlistsBloc.state.playlists.length,
        itemBuilder: (context, index) {
          final String item = playlistsBloc.state.playlists[index][0];
          final int length = playlistsBloc.state.playlists[index][1].length;
          if (playlistsBloc.state.playlists.isNotEmpty) {
            return OpenPlaylistButton(
              scrollController: scrollController,
              playlistsBloc: playlistsBloc,
              id: index,
              width: 150,
              name: item,
              length: length.toString(),
            );
          } else {
            return const Text("");
          }
        },
      ),
    );
  }
}
