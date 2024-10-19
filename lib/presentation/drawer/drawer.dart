import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orangejam/application/drawer_prefs/automatic_playback/automatic_playback_cubit.dart';
import 'package:orangejam/presentation/drawer/widgets/automatic_playback_switch.dart';
import 'package:orangejam/presentation/drawer/widgets/backup_restore_buttons.dart';
import 'package:orangejam/presentation/drawer/widgets/language_selection.dart';
import 'package:orangejam/presentation/drawer/widgets/scan_device.dart';
import 'package:orangejam/presentation/help_page/help_page.dart';

import '../../generated/l10n.dart';
import '../homepage/custom_widgets/custom_widgets.dart';

class MyDrawer extends StatelessWidget {
  final List<Locale> supportedLang;

  const MyDrawer({
    super.key,
    required this.supportedLang,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AutomaticPlaybackCubit>(context);
    final themeData = Theme.of(context);

    return Drawer(
      backgroundColor: themeData.colorScheme.primaryContainer,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),

            /// Switch automatic playback
            const AutomaticPlaybackSwitch(),
            const SizedBox(
              height: 40,
            ),

            /// Language
            LanguageSelection(supportedLang: supportedLang),
            const SizedBox(
              height: 40,
            ),

            /// Backup/Restore playlists
            const BackupRestoreButtons(),
            const SizedBox(
              height: 40,
            ),

            /// Scan device
            const ScanDevice(),
            const SizedBox(
              height: 40,
            ),
            //const Spacer(),

            /// Help
            SimpleButton(
              themeData: themeData,
              btnText: S.of(context).help,
              function: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
