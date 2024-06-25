import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orange_player/application/bottombar/playlists/playlists_bloc.dart';

import '../../../../application/my_listview/tracklist/tracklist_bloc.dart';
import '../../../../application/my_listview/ui/appbar_filterby_cubit.dart';
import '../../../../core/playlist_handler_and_dialogs.dart';
import '../../playlists_menu/bottom_sheet_playlists_menu.dart';

class MenuPlaylistsWidget extends StatelessWidget {
  final PlaylistHandler playlistHandler;
  final AppbarFilterByCubit appbarFilterByCubit;
  final ThemeData themeData;

  const MenuPlaylistsWidget({
    super.key,
    required this.playlistHandler,
    required this.appbarFilterByCubit,
    required this.themeData,
  });

  @override
  Widget build(BuildContext context) {
    final playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);
    final tracklistBlock = BlocProvider.of<TracklistBloc>(context);
    return BlocBuilder<PlaylistsBloc, PlaylistsState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () => {
            showModalBottomSheet(
              context: context,
              shape: const ContinuousRectangleBorder(),
              builder: (context) {
                return BottomSheetPlaylistsMenu(
                  tracklistBlock: tracklistBlock,
                  playlistHandler: playlistHandler,
                  playlistsBloc: playlistsBloc,
                  appbarFilterByCubit: appbarFilterByCubit,
                );
              },
            ),
          },
          icon: Image.asset(
            "assets/playlist.png",
            color: const Color(0xFFCBD4C2),
            height: 24,
          ),
        );
      },
    );
  }
}

