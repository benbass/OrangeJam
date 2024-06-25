import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orange_player/application/my_listview/sortby/ascending_cubit.dart';
import 'package:orange_player/application/my_listview/sortby/sort_by_cubit.dart';
import '../../../../application/bottombar/playlists/playlists_bloc.dart';


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
      "Track name",
      "File name",
      "Artist",
      "Genre",
      "Creation date",
      "Shuffle",
      "Reset",
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
                    'Sort',
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
                            color: sortbyState == e && e != 'Reset'
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
