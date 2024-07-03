import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orange_player/application/language/language_cubit.dart';

import '../../application/listview/tracklist/tracklist_bloc.dart';
import '../../generated/l10n.dart';
import '../../injection.dart';
import '../homepage/custom_widgets/custom_widgets.dart';

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
          /// Language
          const SizedBox(
            height: 50,
          ),
          Text(S.of(context).drawer_language),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: supportedLang
                .map(
                  (locale) => TextButton(
                      onPressed: () {
                        BlocProvider.of<LanguageCubit>(context)
                            .setLang(locale.languageCode);
                      },
                      child: Text(
                        locale.languageCode.toUpperCase(),
                      )),
                )
                .toList(),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("Playlists"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  dialogActionRestoreOrBackupPlaylists(context, "backup");
                },
                child: Text(
                  S.of(context).drawer_backup,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  dialogActionRestoreOrBackupPlaylists(context, "restore");
                },
                child: Text(
                  S.of(context).drawer_restore,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              trackBox.removeAll();
              BlocProvider.of<TracklistBloc>(context)
                  .add(TrackListRefreschingEvent());
            },
            child: Text(
              S.of(context).drawer_scanDevice,
            ),
          ),
        ],
      ),
    );
  }
}
