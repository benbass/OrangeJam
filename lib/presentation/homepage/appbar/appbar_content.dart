import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/playlists/playlists_bloc.dart';
import '../../../application/extra_bar_all_files/filterby/appbar_filterby_cubit.dart';

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
                if (state.playlistId == -2) {
                  return Text(
                    "Files (${state.tracks.length})",
                  );
                } else if (state.playlistId == -1) {
                  return Text(
                    "Queue (${state.tracks.length})",
                  );
                } else if (state.playlistId > -1) {
                  return Text(
                    "${state.playlists[state.playlistId][0]} (${state.tracks.length})",
                    overflow: TextOverflow.ellipsis,
                    //"Playlist",
                  );
                } else {
                  return Text(
                    "Files (${state.tracks.length})",
                  );
                }
              },
            )),
        const SizedBox(
          width: 20,
        ),

        /// This builder shows a sort of filtering hint: filtertext1 > filtertext2 > filtertext3...
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