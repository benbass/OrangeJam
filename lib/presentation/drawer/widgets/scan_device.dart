import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:orangejam/application/drawer_prefs/language/language_cubit.dart';
import 'package:orangejam/application/playlists/playlists_bloc.dart';
import 'package:orangejam/core/storage_permission/storage_permission_handler.dart';
import '../../../core/globals.dart';
import '../../../generated/l10n.dart';
import '../../homepage/custom_widgets/custom_widgets.dart';

class ScanDevice extends StatelessWidget {
  const ScanDevice({super.key});

  @override
  Widget build(BuildContext context) {
    StoragePermissionHandler storagePermissionHandler = StoragePermissionHandler(context: context);
    return BlocBuilder<LanguageCubit, String>(
      builder: (context2, state) {
        return Column(
          children: [
            Text(
              S.of(context).files,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SimpleButton(
              btnText: S.of(context).drawer_scanDevice,
              function: () async {
                Navigator.of(context).pop();
                trackBox.removeAll();
                if(await storagePermissionHandler.callDialogForStoragePermission() == false && context.mounted) {
                  BlocProvider.of<PlaylistsBloc>(context)
                    .add(PlaylistsTracksLoadingEvent());
                }
              },
            ),
          ],
        );
      },
    );
  }
}
