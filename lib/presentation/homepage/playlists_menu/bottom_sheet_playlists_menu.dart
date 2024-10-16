import 'package:flutter/material.dart';
import 'package:orangejam/presentation/homepage/playlists_menu/widgets/first_row_allfiles_and_queue_buttons.dart';
import 'package:orangejam/presentation/homepage/playlists_menu/widgets/second_row_playlist_buttons.dart';
import 'package:orangejam/presentation/homepage/playlists_menu/widgets/topbar_playlists_menu.dart';

import '../../../application/listview/list_of_tracks/tracks_bloc.dart';
import '../../../application/playlists/playlists_bloc.dart';

// The menu to access playlists
class BottomSheetPlaylistsMenu extends StatelessWidget {
  const BottomSheetPlaylistsMenu({
    super.key,
    required this.scrollController,
    required this.tracksBlock,
    required this.playlistsBloc,
  });

  final ScrollController scrollController;
  final TracksBloc tracksBlock;
  final PlaylistsBloc playlistsBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/orange.jpeg"),
          fit: BoxFit.fitWidth,
          opacity: 0.35,
          alignment: Alignment.center,
          colorFilter: ColorFilter.mode(
            Color(0xFFFF8100),
            BlendMode.darken,
          ),
        ),
        color: Color(0xFFFF8100),
      ),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Column(
              children: [
                TopBarPlaylistsMenu(
                  tracksBlock: tracksBlock,
                ),
                FirstRowAllFilesAndQueueButtons(
                  scrollController: scrollController,
                  playlistsBloc: playlistsBloc,
                ),
                const SizedBox(height: 15,),
                SecondRowPlaylistButtons(
                  scrollController: scrollController,
                  playlistsBloc: playlistsBloc,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
