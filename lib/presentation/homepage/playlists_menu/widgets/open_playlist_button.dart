import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/presentation/homepage/custom_widgets/custom_widgets.dart';

import '../../../../application/extra_top_bar/filterby/topbar_filterby_cubit.dart';
import '../../../../application/playlists/playlists_bloc.dart';
import '../../../../core/playlists/playlist_handler.dart';
import '../../../../generated/l10n.dart';

class OpenPlaylistButton extends StatelessWidget {
  const OpenPlaylistButton({
    super.key,
    required this.scrollController,
    required this.width,
    required this.name,
    required this.length,
    required this.id,
  });

  final ScrollController scrollController;
  final double width;
  final String name;
  final String length;
  final int id;

  @override
  Widget build(BuildContext context) {

    refreshUiOnPlaylistChanged() {
      // We remove filters
      BlocProvider.of<TopBarFilterByCubit>(context).setStringFilterBy(null);
      // We update UI to selected playlists
      BlocProvider.of<PlaylistsBloc>(context).add(PlaylistChanged(id: id));
    }

    deletePlaylistAndUpdateUi(){
      BlocProvider.of<PlaylistsBloc>(context).state.playlists.removeAt(id);
      PlaylistHandler().deleteFile(name);
      BlocProvider.of<PlaylistsBloc>(context)
          .add(PlaylistDeleted(id: id));
      Navigator.pop(context); // closes the dialog
      Navigator.pop(context); // closes the playlist menu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(
            S
                .of(context)
                .playlistButton_SnackbarNameWasDeleted(
                name),
          ),
        ),
      );
    }

    return BlocBuilder<PlaylistsBloc, PlaylistsState>(
      builder: (context, state) {
        return InkResponse(
          onTap: id != state.playlistId
              ? () async {
                  /// Scroll is the easiest way to remove slide panes from previous playlist, if any, when user changes playlist:
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (scrollController.hasClients) {
                      scrollController
                          .animateTo(5,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeIn)

                          /// END
                          .whenComplete(refreshUiOnPlaylistChanged);

                      // we want the new list with offset 0
                      scrollController.animateTo(0,
                          duration: const Duration(milliseconds: 50),
                          curve: Curves.easeOut);
                    }
                  });
                  Navigator.pop(context);
                }
              : null,
          onLongPress: id > -1
              ? () {
                  showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      content: const SizedBox.shrink(),
                      actions: [
                        SimpleButton(
                          btnText: S.of(context).buttonCancel,
                          function: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        SimpleButton(
                          btnText: S.of(context).buttonOk,
                          function: deletePlaylistAndUpdateUi,
                        ),
                      ],
                      showDropdown: false,
                      titleWidget: Text(S
                          .of(context)
                          .playlistButton_ThisWillDefinitelyDeleteThePlaylist(
                              name)),
                    ),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Material(
              color: id == state.playlistId
                  ? const Color(0xFF181C25).withOpacity(0.6)
                  : const Color(0xFF181C25),
              elevation: 16.0,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(length),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
