import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../dialogs/dialogs.dart';

// Icon + : create a new playlist
class CreatePlaylistButton extends StatelessWidget {
  const CreatePlaylistButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //const Spacer(),
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            dialogCreatePlaylist(S.of(context).playlistsMenu_NewPlaylist, []);
          },
          icon: const Icon(
            Icons.add,
            size: 32,
            color: Color(0xFF181C25),
          ),
        ),
      ],
    );
  }
}