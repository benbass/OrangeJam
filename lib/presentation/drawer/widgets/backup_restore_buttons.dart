import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/application/drawer_prefs/language/language_cubit.dart';

import '../../../generated/l10n.dart';
import '../../homepage/custom_widgets/custom_widgets.dart';
import '../../homepage/dialogs/dialogs.dart';

class BackupRestoreButtons extends StatelessWidget {
  const BackupRestoreButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, String>(
  builder: (context2, state) {
    return Column(
      children: [
        Text(
          S.of(context).drawer_playlists,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            SimpleButton(
              btnText: S.of(context).drawer_backup,
              function: () {
                //Navigator.of(context).pop(); We don't close Drawer to not lose the context for the dialog!
                dialogActionRestoreOrBackupPlaylists(context, "backup");
              },
            ),
            SimpleButton(
              btnText: S.of(context).drawer_restore,
              function: () {
                //Navigator.of(context).pop();
                dialogActionRestoreOrBackupPlaylists(context, "restore");
              },
            ),
          ],
        ),
      ],
    );
  },
);
  }
}
