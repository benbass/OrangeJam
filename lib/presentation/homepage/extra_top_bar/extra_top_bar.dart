import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:orangejam/presentation/homepage/extra_top_bar/widgets/filterby_popupmenubutton.dart';
import 'package:orangejam/presentation/homepage/extra_top_bar/widgets/search_textfield.dart';
import 'package:orangejam/presentation/homepage/extra_top_bar/widgets/sortby_dropdown.dart';

import '../../../application/playlists/playlists_bloc.dart';
import '../../../domain/entities/track_entity.dart';
import '../../../generated/l10n.dart';
import '../dialogs/dialogs.dart';

// this extra bar is displayed only if playlistId == -2 (Files) or -1 (Queue)
class ExtraTopBar extends StatelessWidget {
  const ExtraTopBar({
    super.key,
    required this.searchController,
  });

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    padding: const EdgeInsets.only(right: 12.0, top: 0),
                    child: SearchTextField(
                      searchController: searchController,
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
                    playlistsBloc.add(
                      ClearQueue(),
                    );
                  },
                ),
                const Expanded(
                  child: SizedBox(),
                ),

                /// SAVE to new playlist
                InkWell(
                  child: Text(S.of(context).save),
                  onTap: () {
                    if (playlistsBloc.state.tracks.isNotEmpty) {
                      List<String> filePaths = [];
                      for (TrackEntity track in playlistsBloc.state.tracks) {
                        filePaths.add(track.filePath);
                      }
                      dialogCreatePlaylist(
                        S.of(context).extraBar_saveTheQueueAsAPlaylist,
                        filePaths,
                        context,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1),
                          content: Text(S.of(context).extraBar_theQueueIsEmpty),
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
