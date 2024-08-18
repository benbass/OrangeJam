import 'package:flutter/material.dart';
import 'package:orangejam/presentation/homepage/playlists_menu/widgets/playlist_button.dart';

import '../../../../application/playlists/playlists_bloc.dart';
import '../../../../application/extra_bar_all_files/filterby/appbar_filterby_cubit.dart';
import '../../../../core/playlists/playlist_handler.dart';

// list of buttons for each playlist
class SecondRowPlaylistButtons extends StatelessWidget {
  const SecondRowPlaylistButtons({
    super.key,
    required this.scrollController,
    required this.playlistsBloc,
    required this.appbarFilterByCubit,
    required this.playlistHandler,
  });

  final ScrollController scrollController;
  final PlaylistsBloc playlistsBloc;
  final AppbarFilterByCubit appbarFilterByCubit;
  final PlaylistHandler playlistHandler;

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
            return ButtonOpenPlaylist(
              scrollController: scrollController,
              playlistsBloc: playlistsBloc,
              appbarFilterByCubit: appbarFilterByCubit,
              id: index,
              width: 150,
              name: item,
              length: length.toString(),
              playlistHandler: playlistHandler,
            );
          } else {
            return const Text("");
          }
        },
      ),
    );
  }
}
