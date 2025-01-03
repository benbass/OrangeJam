import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/application/drawer_prefs/language/language_cubit.dart';

import '../../../application/extra_top_bar/filterby/topbar_filterby_cubit.dart';
import '../../../application/playlists/playlists_bloc.dart';
import '../../../generated/l10n.dart';

// the appBar shows the name of the list + (the list length) + if list is filtered: filter keywords (if many separated by ">")
class AppBarContent extends StatelessWidget {
  const AppBarContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 3,
            child: BlocBuilder<LanguageCubit, String>(
              builder: (context, langState) {
                return BlocBuilder<PlaylistsBloc, PlaylistsState>(
                  builder: (context, state) {
                    // Title of app bar depends on current list
                    // -2 -> all tracks
                    if (state.playlistId == -2) {
                      return Text(
                        "${S.of(context).files} (${state.tracks.length})",
                      );
                    } else if (state.playlistId == -1) {
                      // -1 -> queue
                      return Text(
                        "${S.of(context).queue} (${state.tracks.length})",
                      );
                    } else if (state.playlistId > -1) {
                      // > -1 -> the selected playlists
                      return Text(
                        "${state.playlists[state.playlistId][0]} (${state.tracks.length})",
                        overflow: TextOverflow.ellipsis,
                        //"Playlist",
                      );
                    } else {
                      return Text(
                        "${S.of(context).files} (${state.tracks.length})",
                      );
                    }
                  },
                );
              },
            )),
        const SizedBox(
          width: 20,
        ),

        /// This builder shows a filtering hint: filtertext1 > filtertext2 > filtertext3...
        BlocBuilder<TopBarFilterByCubit, String?>(
          builder: (context, appbarFilterByState) {
            return Expanded(
              flex: 2,
              child: appbarFilterByState != null
                  ? Text(
                      appbarFilterByState,
                      style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                        color: const Color(0xFFFF8100),
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.end,
                    )
                  : const SizedBox.shrink(),
            );
          },
        ),
      ],
    );
  }
}
