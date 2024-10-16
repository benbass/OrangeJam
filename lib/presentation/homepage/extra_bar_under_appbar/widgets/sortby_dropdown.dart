import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/application/extra_bar_all_files/sortby/sort_by_cubit.dart';
import 'package:orangejam/application/drawer_prefs/language/language_cubit.dart';
import '../../../../application/extra_bar_all_files/filterby/appbar_filterby_cubit.dart';
import '../../../../application/playlists/playlists_bloc.dart';
import '../../../../generated/l10n.dart';

class SortByDropdown extends StatelessWidget {
  const SortByDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);
    final SortByCubit sortByCubit = BlocProvider.of<SortByCubit>(context);
    final AppbarFilterByCubit appbarFilterByCubit = BlocProvider.of<AppbarFilterByCubit>(context);

    // Vars for sorting in DropdownButton (BottomNavigationBar)
    String? selectedOption; // state for selected option
    bool ascending = true;


    return BlocBuilder<SortByCubit, String?>(
      builder: (context, sortbyState) {
        return BlocBuilder<LanguageCubit, String>(
          builder: (context, state) {
            final List<String> sortByItems = [
              S.of(context).sortByDropdown_trackName,
              S.of(context).sortByDropdown_fileName,
              //S.of(context).sortByDropdown_artist,
              //S.of(context).sortByDropdown_genre,
              S.of(context).sortByDropdown_creationDate,
              //S.of(context).sortByDropdown_shuffle,
              S.of(context).sortByDropdown_reset,
            ];
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
                    String englishString = "";
                    if (newValue == S.of(context).sortByDropdown_trackName) {
                      englishString = "Track name";
                    }
                    if (newValue == S.of(context).sortByDropdown_fileName) {
                      englishString = "File name";
                    }
                 /*   if (newValue == S.of(context).sortByDropdown_artist) {
                      englishString = "Artist";
                    }
                    if (newValue == S.of(context).sortByDropdown_genre) {
                      englishString = "Genre";
                    }*/
                    if (newValue == S.of(context).sortByDropdown_creationDate) {
                      englishString = "Creation date";
                    }
                   /* if (newValue == S.of(context).sortByDropdown_shuffle) {
                      englishString = "Shuffle";
                    }*/
                    if (newValue == S.of(context).sortByDropdown_reset) {
                      englishString = "Reset";
                      // List may be filtered: we reset the filter string to null
                      appbarFilterByCubit.setStringFilterBy(null);
                    }

                    if (sortbyState == newValue) {
                      ascending = !ascending;
                    } else {
                      ascending = true;
                    }

                    selectedOption = newValue!;
                    sortByCubit.sortBy(selectedOption!);
                    playlistsBloc.add(PlaylistSorted(
                        sortBy: englishString, ascending: ascending));
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
                            color: sortbyState == e &&
                                    e != S.of(context).sortByDropdown_reset
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
