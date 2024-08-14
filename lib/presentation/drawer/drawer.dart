import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orange_player/application/language/language_cubit.dart';

import '../../application/listview/tracklist/tracklist_bloc.dart';
import '../../generated/l10n.dart';
import '../../injection.dart';
import '../homepage/custom_widgets/custom_widgets.dart';
import '../homepage/dialogs/dialogs.dart';

class MyDrawer extends StatelessWidget {
  final List<Locale> supportedLang;

  const MyDrawer({
    super.key,
    required this.supportedLang,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Drawer(
      backgroundColor: themeData.colorScheme.primaryContainer,
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          /// Language
          Text(S.of(context).drawer_language),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: supportedLang
                .map(
                  (locale) => SimpleButton(
                    themeData: themeData,
                    btnText: locale.languageCode.toUpperCase(),
                    function: () {
                      BlocProvider.of<LanguageCubit>(context)
                          .setLang(locale.languageCode);
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(
            height: 20,
          ),
          /// Backup/Restore playlists
          const Text("Playlists"),
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
          const SizedBox(
            height: 20,
          ),
          /// Scan device
          SimpleButton(
            themeData: themeData,
            btnText: S.of(context).drawer_scanDevice,
            function: () {
              Navigator.of(context).pop();
              trackBox.removeAll();
              BlocProvider.of<TracklistBloc>(context)
                  .add(TrackListRefreschingEvent());
            },
          ),
        ],
      ),
    );
  }
}
