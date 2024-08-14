import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/playlists/playlists_bloc.dart';
import '../../../application/extra_bar_all_files/filterby/appbar_filterby_cubit.dart';
import '../../../generated/l10n.dart';

class AppBarContent extends StatelessWidget {
  const AppBarContent({
    super.key,
    required this.themeData,
  });

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 3,
            child: BlocBuilder<PlaylistsBloc, PlaylistsState>(
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
            )),
        const SizedBox(
          width: 20,
        ),

        /// This builder shows a filtering hint: filtertext1 > filtertext2 > filtertext3...
        BlocBuilder<AppbarFilterByCubit, String?>(
          builder: (context, appbarFilterByState) {
            return Expanded(
              flex: 2,
              child: appbarFilterByState != null
                  ? Text(
                      appbarFilterByState,
                      style: themeData.appBarTheme.titleTextStyle?.copyWith(
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
