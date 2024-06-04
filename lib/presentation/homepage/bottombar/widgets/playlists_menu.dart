import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orange_player/application/bottombar/playlists/playlists_bloc.dart';
import 'package:orange_player/presentation/homepage/bottombar/widgets/playlist_button.dart';
import 'package:orange_player/core/backup_restore_playlists.dart';

import '../../../../application/my_listview/ui/appbar_filterby_cubit.dart';
import '../../../../core/playlist_handler.dart';

class MenuPlaylistsWidget extends StatelessWidget {
  final PlaylistHandler playlistHandler;
  final AppbarFilterByCubit appbarFilterByCubit;
  final ThemeData themeData;

  const MenuPlaylistsWidget({
    super.key,
    required this.playlistHandler,
    required this.appbarFilterByCubit,
    required this.themeData,
  });

  @override
  Widget build(BuildContext context) {
    final BackupRestorePlaylists backupRestorePlaylists =
        BackupRestorePlaylists(playlistHandler: playlistHandler);
    final playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);
    return BlocBuilder<PlaylistsBloc, PlaylistsState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () => {
            showModalBottomSheet(
              context: context,
              shape: const ContinuousRectangleBorder(),
              builder: (context) {
                return Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/orange.jpeg"),
                      fit: BoxFit.fitWidth,
                      opacity: 0.75,
                      alignment: Alignment.center,
                      colorFilter: ColorFilter.mode(
                        Color(0xFFFF8100),
                        BlendMode.color,
                      ),
                    ),
                    color: Color(0xFFFF8100),
                  ),
                  child: Wrap(
                    children: [
                      Column(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: ()
                                      {
                                        Navigator.of(context).pop();
                                        backupRestorePlaylists.dialogAction(
                                            context, "backup");

                                      },
                                      icon: const Icon(
                                        Icons.backup,
                                        size: 26,
                                        color: Color(0xFF181C25),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        backupRestorePlaylists
                                            .dialogAction(context, "restore");

                                      },
                                      icon: const Icon(
                                        Icons.restore,
                                        size: 26,
                                        color: Color(0xFF181C25),
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        playlistHandler.createPlaylist(
                                            "New playlist:", []);
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        size: 26,
                                        color: Color(0xFF181C25),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 65,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ButtonOpenPlaylist(
                                      playlistsBloc: playlistsBloc,
                                      appbarFilterByCubit: appbarFilterByCubit,
                                      id: -2,
                                      width: 120,
                                      name: 'Files',
                                      length: GlobalLists().initialTracks.length.toString(),
                                      playlistHandler: playlistHandler,
                                    ),
                                    ButtonOpenPlaylist(
                                      playlistsBloc: playlistsBloc,
                                      appbarFilterByCubit: appbarFilterByCubit,
                                      id: -1,
                                      width: 120,
                                      name: 'Queue',
                                      length: GlobalLists().queue.length.toString(),
                                      playlistHandler: playlistHandler,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: playlistsBloc.state.playlists.length,
                              itemBuilder: (context, index) {
                                final String item =
                                    playlistsBloc.state.playlists[index][0];
                                final int length = playlistsBloc
                                    .state.playlists[index][1].length;
                                if (playlistsBloc.state.playlists.isNotEmpty) {
                                  return ButtonOpenPlaylist(
                                    playlistsBloc: playlistsBloc,
                                    appbarFilterByCubit: appbarFilterByCubit,
                                    id: index,
                                    width: 150,
                                    name: item,
                                    length: length.toString(),
                                    playlistHandler: playlistHandler,
                                  );
                                } else {
                                  return const Text("");
                                }
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          },
          icon: Image.asset(
            "assets/playlist.png",
            color: const Color(0xFFCBD4C2),
            height: 24,
          ),
        );
      },
    );
  }
}
