import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/application/playlists/playlists_bloc.dart';

import '../../../../application/listview/list_of_tracks/tracks_bloc.dart';
import '../../../../application/extra_bar_all_files/filterby/appbar_filterby_cubit.dart';
import '../../playlists_menu/bottom_sheet_playlists_menu.dart';

// This button opens the playlist menu
class MenuPlaylistsWidget extends StatelessWidget {
  final ScrollController scrollController;
  final AppbarFilterByCubit appbarFilterByCubit;
  final ThemeData themeData;

  const MenuPlaylistsWidget({
    super.key,
    required this.scrollController,
    required this.appbarFilterByCubit,
    required this.themeData,
  });

  @override
  Widget build(BuildContext context) {
    final playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);
    final tracksBlock = BlocProvider.of<TracksBloc>(context);
    return BlocBuilder<PlaylistsBloc, PlaylistsState>(
      builder: (context, state) {
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
                  appbarFilterByCubit: appbarFilterByCubit,
                );
              },
            ),
          },
          icon: Image.asset(
            "assets/playlist.png",
            height: 40,
          ),
        );
      },
    );
  }
}
