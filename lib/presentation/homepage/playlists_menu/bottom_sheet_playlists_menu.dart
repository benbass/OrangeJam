import 'package:flutter/material.dart';
import 'package:orange_player/presentation/homepage/playlists_menu/widgets/first_row_allfiles_and_queue_buttons.dart';
import 'package:orange_player/presentation/homepage/playlists_menu/widgets/second_row_playlist_buttons.dart';
import 'package:orange_player/presentation/homepage/playlists_menu/widgets/topbar_playlists_menu.dart';

import '../../../application/playlists/playlists_bloc.dart';
import '../../../application/listview/tracklist/tracklist_bloc.dart';
import '../../../application/extra_bar_all_files/filterby/appbar_filterby_cubit.dart';
import '../../../core/playlist_handler.dart';

class BottomSheetPlaylistsMenu extends StatelessWidget {
  const BottomSheetPlaylistsMenu({
    super.key,
    required this.tracklistBlock,
    required this.playlistHandler,
    required this.playlistsBloc,
    required this.appbarFilterByCubit,
  });

  final TracklistBloc tracklistBlock;
  final PlaylistHandler playlistHandler;
  final PlaylistsBloc playlistsBloc;
  final AppbarFilterByCubit appbarFilterByCubit;

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
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TopBarPlaylistsMenu(
                  tracklistBlock: tracklistBlock,
                  playlistHandler: playlistHandler,
                ),
              ),
              FirstRowAllFilesAndQueueButtons(
                playlistsBloc: playlistsBloc,
                appbarFilterByCubit: appbarFilterByCubit,
                playlistHandler: playlistHandler,
              ),
              SecondRowPlaylistButtons(
                playlistsBloc: playlistsBloc,
                appbarFilterByCubit: appbarFilterByCubit,
                playlistHandler: playlistHandler,
              ),
            ],
          )
        ],
      ),
    );
  }
}


