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
    final themeData = Theme.of(context);
    return BlocBuilder<LanguageCubit, String>(
  builder: (context2, state) {
    return Column(
      children: [
        Text(
          S.of(context).drawer_playlists,
          style: themeData.textTheme.displayLarge,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            SimpleButton(
              themeData: themeData,
              btnText: S.of(context).drawer_backup,
              function: () {
                Navigator.of(context).pop();
                dialogActionRestoreOrBackupPlaylists(context, "backup");
              },
            ),
            SimpleButton(
              themeData: themeData,
              btnText: S.of(context).drawer_restore,
              function: () {
                Navigator.of(context).pop();
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
