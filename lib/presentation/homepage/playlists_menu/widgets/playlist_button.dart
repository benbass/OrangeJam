import 'package:flutter/material.dart';

import '../../../../application/bottombar/playlists/playlists_bloc.dart';
import '../../../../application/my_listview/ui/appbar_filterby_cubit.dart';
import '../../../../core/playlist_handler_and_dialogs.dart';

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
              playlistsBloc.state.playlists.removeAt(id);
              //playlistHandler.updateDatabase();
              playlistHandler.deleteFile(name);
              playlistsBloc.add(PlaylistDeleted(id: id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text(
                    'The playlist \'$name\' was deleted.',
                  ),
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
