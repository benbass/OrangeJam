import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).help),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).help_play,
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFFFF8100),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Icon(Icons.touch_app)
                      ],
                    ),
                  ),
                  TableCell(
                    child: Text(
                      S.of(context).help_play_desc,
                    ),
                  ),
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(height: 40), //SizeBox Widget
                  SizedBox(height: 40),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).help_stop,
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFFFF8100),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.touch_app),
                            Text(S.of(context).help_or),
                            const Icon(Icons.stop_rounded),
                          ],
                        ),
                      ],
                    ),
                  ),
                  TableCell(
                    child: Text(
                      S.of(context).help_stop_desc,
                    ),
                  ),
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(height: 40), //SizeBox Widget
                  SizedBox(height: 40),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).help_reorder_tracks,
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFFFF8100),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.swipe_up),
                            Icon(Icons.swipe_down),
                          ],
                        )
                      ],
                    ),
                  ),
                  TableCell(
                    child: Text(
                        S.of(context).help_reorder_tracks_desc,
                    ),
                  ),
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(height: 40), //SizeBox Widget
                  SizedBox(height: 40),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).help_repeat_track,
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFFFF8100),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Icon(Icons.repeat_one)
                      ],
                    ),
                  ),
                  TableCell(
                    child: Text(
                      S.of(context).help_repeat_track_desc,
                    ),
                  ),
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(height: 40), //SizeBox Widget
                  SizedBox(height: 40),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).help_shuffle,
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFFFF8100),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Icon(Icons.shuffle_rounded)
                      ],
                    ),
                  ),
                  TableCell(
                    child: Text(
                      S.of(context).help_shuffle_desc,
                    ),
                  ),
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(height: 40), //SizeBox Widget
                  SizedBox(height: 40),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).help_view_tags,
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFFFF8100),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Icon(Icons.info_outline_rounded)
                      ],
                    ),
                  ),
                  TableCell(
                    child: Text(
                      S.of(context).help_view_tags_desc,
                    ),
                  ),
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(height: 40), //SizeBox Widget
                  SizedBox(height: 40),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).help_edit_tags,
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFFFF8100),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.swipe_left),
                                Text(" + "),
                                Icon(Icons.edit),
                              ],

                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(S.of(context).help_or),
                                const Icon(Icons.edit),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  TableCell(
                    child: Text(
                      S.of(context).help_edit_tags_desc,
                    ),
                  ),
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(height: 40), //SizeBox Widget
                  SizedBox(height: 40),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).help_create_playlist,
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFFFF8100),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/playlist.png",
                              height: 24,
                            ),
                            const Text(" + "),
                            const Icon(Icons.add),
                          ],
                        )
                      ],
                    ),
                  ),
                  TableCell(
                    child: Text(
                      S.of(context).help_create_playlist_desc,
                    ),
                  ),
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(height: 40), //SizeBox Widget
                  SizedBox(height: 40),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).help_delete_playlist,
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFFFF8100),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/playlist.png",
                              height: 26,
                            ),
                            const Text(" + "),
                            const Icon(Icons.touch_app),
                          ],
                        )
                      ],
                    ),
                  ),
                  TableCell(
                    child: Text(
                      S.of(context).help_delete_playlist_desc,
                    ),
                  ),
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(height: 40), //SizeBox Widget
                  SizedBox(height: 40),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).help_add_to_playlist,
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFFFF8100),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Icon(Icons.swipe_right),
                      ],
                    ),
                  ),
                  TableCell(
                    child: Text(
                      S.of(context).help_add_to_playlist_desc,
                    ),
                  ),
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(height: 40), //SizeBox Widget
                  SizedBox(height: 40),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).help_remove_from_playlist,
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFFFF8100),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.swipe_left),
                            Text(" + "),
                            Icon(Icons.delete),
                          ],
                        )
                      ],
                    ),
                  ),
                  TableCell(
                    child: Text(
                      S.of(context).help_remove_from_playlist_desc,
                    ),
                  ),
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(height: 40), //SizeBox Widget
                  SizedBox(height: 40),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).help_automatic_playback,
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFFFF8100),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Icon(Icons.menu)
                      ],
                    ),
                  ),
                  TableCell(
                    child: Text(
                      S.of(context).help_automatic_playback_desc,
                    ),
                  ),
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(height: 40), //SizeBox Widget
                  SizedBox(height: 40),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).help_backup_restore,
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFFFF8100),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Icon(Icons.menu)
                      ],
                    ),
                  ),
                  TableCell(
                    child: Text(
                      S.of(context).help_backup_restore_desc,
                    ),
                  ),
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(height: 40), //SizeBox Widget
                  SizedBox(height: 40),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).help_refresh,
                          style: themeData.textTheme.bodyMedium!.copyWith(
                            color: const Color(0xFFFF8100),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Icon(Icons.menu)
                      ],
                    ),
                  ),
                  TableCell(
                    child: Text(
                      S.of(context).help_refresh_desc,
                    ),
                  ),
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(height: 40), //SizeBox Widget
                  SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

