import 'package:flutter/material.dart';
import 'package:orange_player/presentation/homepage/custom_widgets/custom_widgets.dart';

import '../../../../application/playlists/playlists_bloc.dart';
import '../../../../application/extra_bar_all_files/filterby/appbar_filterby_cubit.dart';
import '../../../../core/playlists/playlist_handler.dart';
import '../../../../generated/l10n.dart';

class ButtonOpenPlaylist extends StatelessWidget {
  const ButtonOpenPlaylist({
    super.key,
    required this.playlistsBloc,
    required this.appbarFilterByCubit,
    required this.width,
    required this.name,
    required this.length,
    required this.id,
    required this.playlistHandler,
  });

  final PlaylistsBloc playlistsBloc;
  final AppbarFilterByCubit appbarFilterByCubit;
  final double width;
  final String name;
  final String length;
  final int id;
  final PlaylistHandler playlistHandler;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return InkResponse(
      onTap: id != playlistsBloc.state.playlistId
          ? () async {
              playlistsBloc.add(PlaylistChanged(id: id));
              appbarFilterByCubit.setStringFilterBy(null);
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
                      themeData: themeData,
                      btnText: S.of(context).buttonCancel,
                      function: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SimpleButton(
                      themeData: themeData,
                      btnText: S.of(context).buttonOk,
                      function: () {
                        playlistsBloc.state.playlists.removeAt(id);
                        playlistHandler.deleteFile(name);
                        playlistsBloc.add(PlaylistDeleted(id: id));
                        Navigator.pop(context); // closes the dialog
                        Navigator.pop(context); // closes the playlist menu
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 2),
                            content: Text(
                              S.of(context).playlistButton_SnackbarNameWasDeleted(name),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  showDropdown: false,
                  titleWidget:
                      Text(S.of(context).playlistButton_ThisWillDefinitelyDeleteThePlaylist(name)),
                  themeData: themeData,
                ),
              );
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Material(
          color: id == playlistsBloc.state.playlistId
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
  }
}
