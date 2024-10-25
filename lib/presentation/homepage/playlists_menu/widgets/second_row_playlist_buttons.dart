import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/presentation/homepage/playlists_menu/widgets/open_playlist_button.dart';

import '../../../../application/playlists/playlists_bloc.dart';

// list of buttons for each playlist
class SecondRowPlaylistButtons extends StatelessWidget {
  const SecondRowPlaylistButtons({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistsBloc, PlaylistsState>(
      builder: (contextBloc, state) {
        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.playlists.length,
            itemBuilder: (context, index) {
              final String item = state.playlists[index][0];
              final int length = state.playlists[index][1].length;
              if (state.playlists.isNotEmpty) {
                return OpenPlaylistButton(
                  scrollController: scrollController,
                  id: index,
                  width: 150,
                  name: item,
                  length: length.toString(),
                );
              } else {
                return const Text("");
              }
            },
          ),
        );
      },
    );
  }
}
