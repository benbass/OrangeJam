import 'package:flutter/material.dart';
import 'package:orange_player/presentation/homepage/extra_bar_under_appbar/widgets/filterby_popupmenubutton.dart';
import 'package:orange_player/presentation/homepage/extra_bar_under_appbar/widgets/search_textfield.dart';
import 'package:orange_player/presentation/homepage/extra_bar_under_appbar/widgets/sortby_dropdown.dart';

import '../../../application/playlists/playlists_bloc.dart';
import '../../../application/extra_bar_all_files/filterby/appbar_filterby_cubit.dart';
import '../../../core/playlists/playlist_handler.dart';
import '../../../domain/entities/track_entity.dart';
import '../../../generated/l10n.dart';
import '../custom_widgets/custom_widgets.dart';

class SortFilterSearchAndQueueMenu extends StatelessWidget {
  const SortFilterSearchAndQueueMenu({
    super.key,
    required this.playlistsBloc,
    required this.searchController,
    required this.appbarFilterByCubit,
    required this.playlistHandler,
  });

  final PlaylistsBloc playlistsBloc;
  final TextEditingController searchController;
  final AppbarFilterByCubit appbarFilterByCubit;
  final PlaylistHandler playlistHandler;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: playlistsBloc.state.playlistId != -1
        /// ALL FILES
            ? [
              /// SORT
          const Expanded(
            flex: 10,
            child: SortByDropdown(),
          ),
          const Expanded(
            flex: 2,
            child: SizedBox.expand(),
          ),
          /// FILTER
          const Expanded(
            flex: 7,
            child: FilterByPopupMenuButton(),
          ),
          /// SEARCH
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 12.0, top: 0),
              child: SearchTextField(
                searchController:
                searchController,
                appbarFilterByCubit:
                appbarFilterByCubit,
              ),
            ),
          ),
        ]
        /// QUEUE
            : [
          const Expanded(
            child: SizedBox(
              height: 50,
            ),
          ),
          /// CLEAR
          InkWell(
            child: Text(S.of(context).extraBar_clear),
            onTap: () {
              playlistsBloc.add(ClearQueue());
            },
          ),
          const Expanded(
            child: SizedBox(),
          ),
          /// SAVE to new playlist
          InkWell(
            child: Text(S.of(context).save),
            onTap: () {
              if (playlistsBloc
                  .state.tracks.isNotEmpty) {
                List<String> filePaths = [];
                for (TrackEntity track
                in playlistsBloc
                    .state.tracks) {
                  filePaths.add(track.filePath);
                }
                dialogCreatePlaylist(
                  S.of(context).extraBar_saveTheQueueAsAPlaylist,
                  filePaths,
                  playlistHandler,
                );
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    duration:
                    const Duration(seconds: 1),
                    content: Text(
                        S.of(context).extraBar_theQueueIsEmpty),
                  ),
                );
              }
            },
          ),
          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}