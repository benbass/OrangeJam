import 'package:flutter/material.dart';
import 'package:orange_player/presentation/homepage/intrinsic_height/widgets/filterby_dynamic_popupmenubutton.dart';
import 'package:orange_player/presentation/homepage/intrinsic_height/widgets/search_textfield.dart';
import 'package:orange_player/presentation/homepage/intrinsic_height/widgets/sortby_dropdown.dart';

import '../../../application/bottombar/playlists/playlists_bloc.dart';
import '../../../application/my_listview/ui/appbar_filterby_cubit.dart';
import '../../../core/playlist_handler.dart';
import '../../../domain/entities/track_entity.dart';

class SortFilterSearchMenu extends StatelessWidget {
  const SortFilterSearchMenu({
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
            child: SortBy(),
          ),
          const Expanded(
            flex: 2,
            child: SizedBox.expand(),
          ),
          /// FILTER
          const Expanded(
            flex: 7,
            child: FilterByDynamicMenu(),
          ),
          /// SEARCH
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 12.0, top: 0),
              child: SearchWidget(
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
          InkWell(
            child: const Text("Clear"),
            onTap: () {
              playlistsBloc.add(ClearQueue());
            },
          ),
          const Expanded(
            child: SizedBox(),
          ),
          InkWell(
            child: const Text("Save"),
            onTap: () {
              if (playlistsBloc
                  .state.tracks.isNotEmpty) {
                List<String> filePaths = [];
                for (TrackEntity track
                in playlistsBloc
                    .state.tracks) {
                  filePaths.add(track.filePath);
                }
                playlistHandler.createPlaylist(
                  "Save the queue as a playlist:",
                  filePaths,
                );
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    duration:
                    Duration(seconds: 1),
                    content: Text(
                        "The queue is empty!"),
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