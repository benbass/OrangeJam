import 'package:flutter/material.dart';
import 'package:orangejam/presentation/homepage/playlists_menu/widgets/first_row_allfiles_and_queue_buttons.dart';
import 'package:orangejam/presentation/homepage/playlists_menu/widgets/second_row_playlist_buttons.dart';
import 'package:orangejam/presentation/homepage/playlists_menu/widgets/create_playlist_button.dart';


// The menu to access playlists
class BottomSheetPlaylistsMenu extends StatelessWidget {
  const BottomSheetPlaylistsMenu({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/orange.jpeg"),
            fit: BoxFit.fitWidth,
            opacity: 0.35,
            alignment: Alignment.center,
            colorFilter: ColorFilter.mode(
              Color(0xFFFF8100),
              BlendMode.darken,
            ),
          ),
          color: Color(0xFFFF8100),
        ),
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Column(
                children: [
                  const CreatePlaylistButton(),
                  FirstRowAllFilesAndQueueButtons(
                    scrollController: scrollController,
                  ),
                  const SizedBox(height: 15,),
                  SecondRowPlaylistButtons(
                    scrollController: scrollController,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
