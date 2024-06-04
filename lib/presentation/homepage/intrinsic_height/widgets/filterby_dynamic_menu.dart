import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/bottombar/playlists/playlists_bloc.dart';
import '../../../../application/my_listview/ui/appbar_filterby_cubit.dart';
import '../../../../domain/entities/track_entity.dart';
import '../../homepage.dart';

class FilterByDynamicMenu extends StatelessWidget {
  const FilterByDynamicMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    List<String> menuItems = ["Artist", "Album", "Genre", "Year"];

    return BlocBuilder<PlaylistsBloc, PlaylistsState>(
      builder: (context, state) {
        List<String> artists = [];
        List<String> albums = [];
        List<String> genres = [];
        List<String> years = [];
        // Extract keywords from track tags for filter categories
        for (TrackEntity track in state.tracks) {
          // Artist
          if (track.trackArtistNames != "" && track.trackArtistNames != " " ||
              track.albumArtist != null) {
            String artistT = track.trackArtistNames.trim();
            String? artistA = track.albumArtist?.trim();
            if (!artists.contains(artistT) && !artists.contains(artistA)) {
              artists.add(artistT);
            } else if (track.trackArtistNames == "" ||
                track.trackArtistNames == " " && track.albumArtist == null) {
              if (!artists.contains("#")) {
                artists.add("#");
              }
            }
            artists.sort();
          }

          // Album
          if (track.albumName != null &&
              track.albumName != "" &&
              track.albumName != " ") {
            if (!albums.contains(track.albumName)) {
              albums.add(track.albumName!);
            } else {
              if (!albums.contains("#")) {
                albums.add("#");
              }
            }
            albums.sort();
          }

          // Year
          if (track.year != null && track.year != 0) {
            if (!years.contains(track.year.toString())) {
              years.add(track.year.toString());
            } else {
              if (!years.contains("#")) {
                years.add("#");
              }
            }
            years.sort();
          }

          // Genre
          if (track.genre != null && track.genre != "") {
            String genre = track.genre!.trim();
            if (!genres.contains(genre)) {
              genres.add(genre);
            }
          } else if (track.genre == null || track.genre == "") {
            if (!genres.contains("#")) {
              genres.add("#");
            }
          }
          genres.sort();
        }
        return PopupMenuButton(
          color: const Color(0xFF202531),
          itemBuilder: (context) {
            return menuItems.map((value) {
              return PopupMenuItem(
                height: 20,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                value: value,
                child: SizedBox(
                  width: 300,
                  child: Builder(
                    builder: (context) {
                      if (value == "Artist") {
                        return MyExpansionTile(
                          themeData: themeData,
                          list: artists,
                          value: value,
                        );
                      }
                      if (value == "Album") {
                        return MyExpansionTile(
                          themeData: themeData,
                          list: albums,
                          value: value,
                        );
                      }
                      if (value == "Genre") {
                        return MyExpansionTile(
                          themeData: themeData,
                          list: genres,
                          value: value,
                        );
                      }
                      if (value == "Year") {
                        return MyExpansionTile(
                          themeData: themeData,
                          list: years,
                          value: value,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              );
            }).toList();
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("Filter"),
              ),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        );
      },
    );
  }
}

class MyExpansionTile extends StatelessWidget {
  const MyExpansionTile({
    super.key,
    required this.themeData,
    required this.list,
    required this.value,
  });

  final ThemeData themeData;
  final List<String> list;
  final String value;

  @override
  Widget build(BuildContext context) {
    final playlistsBloc =
        BlocProvider.of<PlaylistsBloc>(myGlobals.scaffoldKey.currentContext!);
    final appbarFilterByCubit = BlocProvider.of<AppbarFilterByCubit>(myGlobals.scaffoldKey.currentContext!);

    return ExpansionTile(
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      iconColor: const Color(0xFFFF8100),
      collapsedIconColor: const Color(0xFFFFFCFF),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      title: Text(
        value,
        style: themeData.textTheme.bodyLarge!.copyWith(
          fontSize: 13,
          color: const Color(0xFFCBD4C2),
        ),
      ),
      children: list
          .map(
            (e) => Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        playlistsBloc
                            .add(PlaylistFiltered(filterdBy: value, value: e));
                        appbarFilterByCubit.setStringFilterBy(e);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        e,
                        style: themeData.textTheme.bodyLarge!.copyWith(
                          fontSize: 13,
                          color: const Color(0xFFFF8100),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
