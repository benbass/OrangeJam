import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/application/language/language_cubit.dart';
import 'package:orangejam/application/playlists/automatic_playback_cubit.dart';

import '../../application/listview/list_of_tracks/tracks_bloc.dart';
import '../../application/playercontrols/cubits/continuousplayback_mode_cubit.dart';
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
    final continuousPlaybackModeCubit =
    BlocProvider.of<ContinuousPlaybackModeCubit>(context);
    final automaticPlaybackCubit =
        BlocProvider.of<AutomaticPlaybackCubit>(context);
    final themeData = Theme.of(context);

    return Drawer(
      backgroundColor: themeData.colorScheme.primaryContainer,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              S.of(context).drawer_automaticPlayback,
              style: themeData.textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 60,
            height: 44,
            child: FittedBox(
              fit: BoxFit.fill,
              child: BlocBuilder<AutomaticPlaybackCubit, bool>(
                builder: (context, state) {
                  return Switch(
                    value: state,
                    onChanged: (value) {
                      automaticPlaybackCubit.setAutomaticPlayback(value);
                      continuousPlaybackModeCubit.setContinuousPlaybackMode(value);
                    },
                    // we set the theme here because SwitchThemeData has too few option :-(
                    inactiveThumbColor:
                        const Color(0xFF202531).withOpacity(0.9),
                    inactiveTrackColor:
                        const Color(0xFFCBD4C2).withOpacity(0.6),
                    activeColor: const Color(0xFFFF8100),
                    activeTrackColor: const Color(0xFFCBD4C2).withOpacity(0.2),
                    trackOutlineColor:
                        const WidgetStatePropertyAll(Colors.transparent),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),

          /// Language
          Text(
            S.of(context).drawer_language,
            style: themeData.textTheme.displayLarge,
          ),
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
            height: 40,
          ),

          /// Backup/Restore playlists
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
          const SizedBox(
            height: 40,
          ),

          /// Scan device
          SimpleButton(
            themeData: themeData,
            btnText: S.of(context).drawer_scanDevice,
            function: () {
              Navigator.of(context).pop();
              trackBox.removeAll();
              BlocProvider.of<TracksBloc>(context).add(TracksRefreshingEvent());
            },
          ),
        ],
      ),
    );
  }
}
