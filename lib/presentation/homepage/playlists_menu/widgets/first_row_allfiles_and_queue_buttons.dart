import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/application/playlists/playlists_bloc.dart';
import 'package:orangejam/presentation/homepage/playlists_menu/widgets/open_playlist_button.dart';
import '../../../../generated/l10n.dart';

// row of 2 buttons for "Files" and "Queue"
class FirstRowAllFilesAndQueueButtons extends StatelessWidget {
  const FirstRowAllFilesAndQueueButtons({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          OpenPlaylistButton(
            scrollController: scrollController,
            id: -2,
            width: 120,
            name: S.of(context).files,
            length: BlocProvider.of<PlaylistsBloc>(context).state.initialTracks.length.toString(),
          ),
          OpenPlaylistButton(
            scrollController: scrollController,
            id: -1,
            width: 120,
            name: S.of(context).queue,
            length: BlocProvider.of<PlaylistsBloc>(context).state.queue.length.toString(),
          ),
        ],
      ),
    );
  }
}
