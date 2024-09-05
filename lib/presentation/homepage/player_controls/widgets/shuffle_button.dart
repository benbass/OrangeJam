import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/playlists/playlists_bloc.dart';

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);

    return IconButton(
      onPressed: () {
        playlistsBloc
            .add(PlaylistSorted(sortBy: "Shuffle", ascending: true));
      },
      icon: const Icon(
        Icons.shuffle,
        color: Color(0xFF202531),
      ),
      iconSize: 22,
    );
  }
}
