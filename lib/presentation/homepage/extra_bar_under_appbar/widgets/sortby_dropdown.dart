import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orange_player/application/extra_bar_all_files/sortby/ascending_cubit.dart';
import 'package:orange_player/application/extra_bar_all_files/sortby/sort_by_cubit.dart';
import '../../../../application/playlists/playlists_bloc.dart';
import '../../../../generated/l10n.dart';


class SortByDropdown extends StatelessWidget {
  const SortByDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);
    final SortByCubit sortByCubit = BlocProvider.of<SortByCubit>(context);
    final ascendingCubit = BlocProvider.of<AscendingCubit>(context);

    // Vars für die Sortierung im DropdownButton (BottomNavigationBar)
    String? selectedOption; // Zustand für die ausgewählte Option
    final List<String> sortByItems = [
      S.of(context).sortByDropdown_trackName,
      S.of(context).sortByDropdown_fileName,
      S.of(context).sortByDropdown_artist,
      S.of(context).sortByDropdown_genre,
      S.of(context).sortByDropdown_creationDate,
      S.of(context).sortByDropdown_shuffle,
      S.of(context).sortByDropdown_reset,
    ];

    return BlocBuilder<AscendingCubit, bool>(
      builder: (context, ascendingState) {
        return BlocBuilder<SortByCubit, String?>(
          builder: (context, sortbyState) {
            return ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: const Color(0xFF202531),
                  //isExpanded: true,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFFCBD4C2),
                  ),
                  hint: Text(
                    S.of(context).sortByDropdown_sort,
                    style: themeData.textTheme.bodyLarge!.copyWith(
                      fontSize: 13,
                    ),
                  ),
                  value: selectedOption,
                  onChanged: (String? newValue) {
                    if (sortbyState == newValue) {
                      ascendingCubit.ascending(!ascendingState);
                    } else {
                      ascendingCubit.ascending(true);
                    }

                    selectedOption = newValue!;
                    sortByCubit.sortBy(newValue);
                    playlistsBloc.add(PlaylistSorted(sortBy: newValue, ascending: ascendingState));
                    selectedOption = null;
                  },
                  items: sortByItems.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Center(
                        child: Text(
                          e,
                          style: themeData.textTheme.bodyLarge!.copyWith(
                            fontSize: 13,
                            color: sortbyState == e && e != S.of(context).sortByDropdown_reset
                                ? const Color(0xFFFF8100)
                                : const Color(0xFFCBD4C2),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
