import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orange_player/application/playlists/playlists_bloc.dart';
import 'package:orange_player/application/extra_bar_all_files/sortby/sort_by_cubit.dart';
import 'package:orange_player/application/playercontrols/bloc/playercontrols_bloc.dart';
import '../../../../application/extra_bar_all_files/filterby/appbar_filterby_cubit.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController searchController;
  final AppbarFilterByCubit appbarFilterByCubit;

  const SearchTextField({
    super.key,
    required this.searchController,
    required this.appbarFilterByCubit,
  });

  @override
  Widget build(BuildContext context) {
    final SortByCubit sortByCubit = BlocProvider.of<SortByCubit>(context);
    return BlocBuilder<PlaylistsBloc, PlaylistsState>(
      builder: (context, state) {
        final playlistsBloc = BlocProvider.of<PlaylistsBloc>(context);
        return SizedBox(
          width: 140,
          height: 30,
          child: TextField(
            controller: searchController,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.start,
            onChanged: (value) {
              playlistsBloc.add(PlaylistSearchedByKeyword(keyword: value));
              // In case list was previously sorted, we update sort dropdown (unselect dropdown item)
              // since list is always reset to initial order when filtered
              sortByCubit.sortBy("");
            },
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                playlistsBloc.add(PlaylistSearchedByKeyword(keyword: value));
                sortByCubit.sortBy("");
              }
            },
            onTap: () =>
                BlocProvider.of<PlayerControlsBloc>(context)
                    .add(ShowHideControlsButtonPressed(height: 0)),
            onTapOutside: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            cursorColor: const Color(0xFFFF8100),
            cursorHeight: 24.0,
            enableInteractiveSelection: false,
            style: const TextStyle(
              color: Color(0xFFFF8100),
              fontSize: 16.0,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                right: 8,
              ),
              isCollapsed: true,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              label: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.search,
                    color: Color(0xFFCBD4C2),
                    size: 28,
                  ),
                ],
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefixIcon: BlocBuilder<AppbarFilterByCubit, String?>(
                builder: (context, state) {
                  return IconButton(
                    padding: const EdgeInsets.only(bottom: 0),
                    icon: Icon(
                      Icons.clear,
                      size: 26,
                      color: searchController.value.text.isNotEmpty ||
                          state != null
                          ? const Color(0xFFFF8100)
                          : Colors.transparent,
                    ),
                    onPressed: () async {
                      searchController.clear();
                      playlistsBloc.add(PlaylistSearchedByKeyword(
                          keyword: null));
                      sortByCubit.sortBy("");
                      appbarFilterByCubit.setStringFilterBy(null);
                      // Close on screen keyboard if open
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
