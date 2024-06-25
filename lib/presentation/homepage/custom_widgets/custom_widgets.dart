import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/globals.dart';
import 'package:orange_player/core/backup_restore_playlists.dart';

class CustomDialog extends StatelessWidget {
  final Widget content;
  final List<Widget> actions;
  final bool showDropdown;
  final Widget titleWidget;
  final ThemeData themeData;

  const CustomDialog({
    super.key,
    required this.content,
    required this.actions,
    required this.showDropdown,
    required this.titleWidget,
    required this.themeData,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: AlertDialog(
        title: titleWidget,
        backgroundColor:
            themeData.dialogTheme.backgroundColor!.withOpacity(0.9),
        content: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              content,
              if (showDropdown) const Placeholder() // DropDown?
            ],
          ),
        ),
        actions: actions,
      ),
    );
  }
}

class DescriptionText extends StatelessWidget {
  const DescriptionText({
    super.key,
    required this.themeData,
    required this.description,
  });

  final ThemeData themeData;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: themeData.dialogTheme.titleTextStyle,
    );
  }
}

void dialogClose(BuildContext context, message) {
  final themeData = Theme.of(context);
  showDialog(
    builder: (context) => CustomDialog(
      content: const SizedBox.shrink(),
      actions: [
        SimpleButton(
          themeData: themeData,
          btnText: 'Close',
          function: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      showDropdown: false,
      titleWidget: DescriptionText(
        themeData: themeData,
        description: message,
      ),
      themeData: themeData,
    ),
    context: context,
  );
}

void dialogActionRestoreOrBackupPlaylists(
    BuildContext context, String restoreOrBackup) {
  final themeData = Theme.of(context);
  BackupRestorePlaylists backupRestorePlaylists = BackupRestorePlaylists();
  String playlistsWillBeDeleted =
      "Pick the ZIP file that contains your backup in the '$appName Playlists' folder in your Google Drive."
      "\nWarning: the restored playlists will overwrite existing playlists with the same name."; //AppLocalizations.of(context)!.playlistsWillBeDeleted;
  String zipWillBeCreated =
      "A ZIP archive will be created and uploaded to your Google Drive"; //AppLocalizations.of(context)!.zipWillBeCreated;
  String abort = "Cancel"; //AppLocalizations.of(context)!.abort;
  String continu = "Continue"; //AppLocalizations.of(context)!.continu;
  String restore = "Restore"; //AppLocalizations.of(context)!.restore;
  String backup = "Backup"; //AppLocalizations.of(context)!.backup;
  showDialog(
          builder: (context) => BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: AlertDialog(
                  title: Text(
                    restoreOrBackup == "restore" ? restore : backup,
                    style: themeData.dialogTheme.titleTextStyle,
                  ),
                  backgroundColor:
                      themeData.dialogTheme.backgroundColor!.withOpacity(0.9),
                  content: restoreOrBackup == "restore"
                      ? Text(playlistsWillBeDeleted)
                      : Text(zipWillBeCreated),
                  actions: <Widget>[
                    TextButton(
                      style: themeData.textButtonTheme.style,
                      child: Text(
                        abort,
                      ),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    TextButton(
                      style: themeData.textButtonTheme.style,
                      child: Text(
                        continu,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              ),
          context: context)
      .then((exit) {
    if (exit == null) return;
    if (exit) {
      restoreOrBackup == "restore"
          ? backupRestorePlaylists.restoreFiles()
          : backupRestorePlaylists.backupFiles();
    } else {
      return;
    }
  });
}

class SimpleButton extends StatelessWidget {
  const SimpleButton({
    super.key,
    required this.themeData,
    required this.btnText,
    required this.function,
  });

  final ThemeData themeData;
  final String btnText;
  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: function,
      style: themeData.textButtonTheme.style,
      child: Text(
        btnText,
      ),
    );
  }
}

class MyTextInput extends StatelessWidget {
  const MyTextInput({
    super.key,
    required this.txtController,
    required this.themeData,
  });

  final TextEditingController txtController;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: txtController,
      autofocus: true,
      cursorColor: Colors.white54,
      decoration: const InputDecoration(
        focusColor: Colors.white54,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
      ),
      style: themeData.textTheme.bodyLarge!,
    );
  }
}
