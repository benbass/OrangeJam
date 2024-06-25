import 'package:flutter/material.dart';
import 'package:orange_player/presentation/homepage/playlists_menu/widgets/playlist_button.dart';

import '../../../../application/bottombar/playlists/playlists_bloc.dart';
import '../../../../application/my_listview/ui/appbar_filterby_cubit.dart';
import '../../../../core/playlist_handler.dart';

class FirstRowAllFilesAndQueueButtons extends StatelessWidget {
  const FirstRowAllFilesAndQueueButtons({
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
      height: 65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ButtonOpenPlaylist(
            playlistsBloc: playlistsBloc,
            appbarFilterByCubit: appbarFilterByCubit,
            id: -2,
            width: 120,
            name: 'Files',
            length: GlobalLists().initialTracks.length.toString(),
            playlistHandler: playlistHandler,
          ),
          ButtonOpenPlaylist(
            playlistsBloc: playlistsBloc,
            appbarFilterByCubit: appbarFilterByCubit,
            id: -1,
            width: 120,
            name: 'Queue',
            length: GlobalLists().queue.length.toString(),
            playlistHandler: playlistHandler,
          ),
        ],
      ),
    );
  }
}