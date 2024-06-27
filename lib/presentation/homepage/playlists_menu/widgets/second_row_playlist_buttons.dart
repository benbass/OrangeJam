import 'package:flutter/material.dart';
import 'package:orange_player/presentation/homepage/playlists_menu/widgets/playlist_button.dart';

import '../../../../application/playlists/playlists_bloc.dart';
import '../../../../application/extra_bar_all_files/filterby/appbar_filterby_cubit.dart';
import '../../../../core/playlist_handler_and_dialogs.dart';

class SecondRowPlaylistButtons extends StatelessWidget {
  const SecondRowPlaylistButtons({
    super.key,
    required this.playlistsBloc,
    required this.appbarFilterByCubit,
    required this.playlistHandler,
  });

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