import 'dart:io';
import 'dart:ui';

import 'package:archive/archive_io.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orange_player/presentation/homepage/dialogs/widgets/custom_widgets.dart';
import 'package:orange_player/core/playlist_handler.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as sign_in;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../application/bottombar/playlists/is_comm_with_google_cubit.dart';
import '../application/bottombar/playlists/playlists_bloc.dart';
import '../services/google_auth_client.dart';
import 'const_appname.dart';
import 'globals.dart';

// extension requires import dart:io
extension FileExtention on FileSystemEntity {
  dynamic get extractFileNameFromPath {
    return path.split("/").last;
  }

  dynamic get extractFileNameFromPathWin {
    return path.split(Platform.pathSeparator).last;
  }
}

class BackupRestorePlaylists {
  final PlaylistHandler playlistHandler;

  BackupRestorePlaylists({required this.playlistHandler});

  void dialogClose(BuildContext context, message) {
    final themeData = Theme.of(context);
    showDialog(
      builder: (context) => CustomDialog(
        content: const SizedBox.shrink(),
        actions: [
          SimpleButton(
            themeData: themeData,
            btnText: 'Close',
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

  void dialogAction(BuildContext context, String restoreOrBackup) {
    final themeData = Theme.of(context);
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
        restoreOrBackup == "restore" ? restoreFiles() : backupFiles();
      } else {
        return;
      }
    });
  }

  /// BACKUP
  void backupFiles() async {
    final isCommunicating = BlocProvider.of<IsCommWithGoogleCubit>(
        globalScaffoldKey.scaffoldKey.currentContext!);
    var encoder = ZipFileEncoder();
    String messageNotSignedIn =
        "You are not signed in to your Google account"; //AppLocalizations.of(context)!.notSignedIn;
    String theFile = "The file "; //AppLocalizations.of(context)!.theFile;
    String hasBeenUploaded =
        "has been uploaded to your Google Drive."; //AppLocalizations.of(context)!.hasBeeUploaded;
    String error = "Error"; //AppLocalizations.of(context)!.error;
    String backupNotCreated =
        "Backup file not created."; //AppLocalizations.of(context)!.backupFileNotCreated;
    String pleaseTryAgain =
        "Please try again."; //AppLocalizations.of(context)!.pleaseTryAgain;
    String successCreated =
        "was successfully created in "; //AppLocalizations.of(context)!.fileSuccessCreated;

    dynamic dir;
    String folderName = "$appName user data";
    final now = DateTime.now();
    final convertedDateTime =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    String backupFolder =
        "$appName backup dir"; // temp dir for files backup. Will be deleted after backup is completed.
    final dateTimeForReuse = convertedDateTime;

    List<File> files = [];

    if (Platform.isAndroid) {
      dir = await getTemporaryDirectory();
      final backupPath = dir.path + '/' + backupFolder;
      // Create the folder if it doesn't exist
      if (!await Directory(backupPath).exists()) {
        await Directory(backupPath).create(recursive: true);
      }
      dynamic appDir = await getApplicationDocumentsDirectory();
      var userData = Directory('${appDir.path}/${appName}_Playlists');

      try {
        var dirList = userData.list();
        await for (final FileSystemEntity f in dirList) {
          if (f is File && f.path.endsWith('.m3u')) {
            files.add(File(f.path));
          } /*else if (f is Directory) {
            print('Found dir ${f.path}');
          }*/
        }
        for (var element in files) {
          String fileName = element.extractFileNameFromPath;
          await element.copy('$backupPath/$fileName');
        }
        encoder.zipDirectory(Directory(backupPath),
            filename:
                '${dir.path}/${appName}_Playlists_$dateTimeForReuse.zip');

        // SCHRITTE BEI GOOGLE:
        // Zuerst unter https://console.cloud.google.com/ die Projekt erstellen.
        // Dann Google Drive Api aktivieren
        // Anmeldedaten erstellen (OAuth) für Android app. SHA1 key unbedingt!!!! hier mit " ./gradlew signingReport " (zuerst ins Verz. android wechseln!)
        // Wenn später die Anmeldung beim Testen fehlschlägt, dann ist der key wahrscheinlich falsch (falsch erstellt!)
        // Unter OAuth-Zustimmungsbildschirm muss die App Test sein, Usertyp: extern,
        // dann nach "Bearbeiten" einfach Speichern und Fortfahren um zu den Scopes zu gelangen.
        // Dort Google Drive API auswählen und speichern.
        // Dann die email des test users eingeben
        final googleSignIn = sign_in.GoogleSignIn.standard(
            scopes: [drive.DriveApi.driveFileScope]);

        final sign_in.GoogleSignInAccount? account =
            await googleSignIn.signIn();
        //print("User account $account");

        if (account == null) {
          dialogClose(
              globalScaffoldKey.scaffoldKey.currentContext!, messageNotSignedIn);
        } else {
          final authHeaders = await account.authHeaders;
          final authenticateClient = GoogleAuthClient(authHeaders);
          final driveApi = drive.DriveApi(authenticateClient);
          //print('User account id: '+account.id);

          uploadFileToGoogleDrive() async {
            isCommunicating.isCommunicatingWithGoogleDrive(true);
            // file
            drive.File fileToUpload = drive.File();
            var file = File(
                '${dir.path}/${appName}_Playlists_$dateTimeForReuse.zip');
            fileToUpload.name = file.extractFileNameFromPath;
            // Create directory
            drive.File dirMetadata = drive.File();
            dirMetadata.name = '$appName Playlists';
            dirMetadata.mimeType = 'application/vnd.google-apps.folder';
            try {
              var dir = await driveApi.files.create(dirMetadata);
              //print('Folder ID: ${dir.id}');
              //return dir.id;
              fileToUpload.parents = [dir.id!];
              await driveApi.files.create(
                fileToUpload,
                uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
              );
            } catch (e) {
              dialogClose(globalScaffoldKey.scaffoldKey.currentContext!,
                  'Unable to upload: $e');
              rethrow;
            }
          }

          deleteZipFile(String filePath) async {
            return await File(filePath).delete();
          }

          String message =
              "$theFile '${appName}_Playlists_$dateTimeForReuse.zip' $hasBeenUploaded";
          uploadFileToGoogleDrive()
              .whenComplete(() => deleteZipFile(
                  '${dir.path}/${appName}_Playlists_$dateTimeForReuse.zip'))
              .whenComplete(() => Directory(backupPath).delete(recursive: true))
              .whenComplete(() {
            isCommunicating.isCommunicatingWithGoogleDrive(false);
            dialogClose(globalScaffoldKey.scaffoldKey.currentContext!, message);
          });
        }
      } catch (e) {
        String message = "$error: $e.\n$backupNotCreated\n$pleaseTryAgain";
        dialogClose(globalScaffoldKey.scaffoldKey.currentContext!, message);
      }
    } else {
      dir = await getApplicationDocumentsDirectory();

      final backupPath = "${dir.path}/$backupFolder";
      // Create the folder if it doesn't exist
      if (!await Directory(backupPath).exists()) {
        await Directory(backupPath).create(recursive: true);
      }
      var userData = Directory(dir.path + '/' + folderName);

      try {
        var dirList = userData.list();
        await for (final FileSystemEntity f in dirList) {
          if (f is File && f.path.endsWith('.m3u')) {
            files.add(File(f.path));
          } /*else if (f is Directory) {
            print('Found dir ${f.path}');
          }*/
        }
        for (var element in files) {
          String fileName = element.extractFileNameFromPathWin;
          await element.copy('$backupPath/$fileName');
        }

        encoder.zipDirectory(Directory(backupPath),
            filename: dir.path + '/${appName}_$dateTimeForReuse.zip');

        if (dir.path + '/${appName}_$dateTimeForReuse.zip' != null) {
          String newZip = '${appName}_$dateTimeForReuse.zip';
          String message = "$theFile '$newZip' $successCreated $dir.";
          Directory('${dir.path}/$backupFolder')
              .delete(recursive: true)
              .whenComplete(() =>
                  dialogClose(globalScaffoldKey.scaffoldKey.currentContext!, message));
        } else {
          String message = "$error: $backupNotCreated\n$pleaseTryAgain";
          dialogClose(globalScaffoldKey.scaffoldKey.currentContext!, message);
        }
      } catch (e) {
        String message = "$error: $e.\n$backupNotCreated\n$pleaseTryAgain";
        dialogClose(globalScaffoldKey.scaffoldKey.currentContext!, message);
      }
    }
  }

  /// RESTORE
  void restoreFiles() async {
    final isCommunicating = BlocProvider.of<IsCommWithGoogleCubit>(
        globalScaffoldKey.scaffoldKey.currentContext!);
    dynamic appDir = await getApplicationDocumentsDirectory();
    var playlistsDir = Directory('${appDir.path}/${appName}_Playlists');
    String noBackupSelected =
        "No backup file selected. "; //AppLocalizations.of(context)!.noFileSelected;
    String restoreAborted =
        "Restore aborted."; //AppLocalizations.of(context)!.restoreAborted;
    //String pleaseRestartApp = "Please restart the app for the changes to take effect!"; //AppLocalizations.of(context)!.pleaseRestartApp;
    String noValidFiles =
        "The Zip file does not contain valid playlist files (extension: m3u) for this app!"; //AppLocalizations.of(context)!.noValidFiles;

    late FilePickerResult? result;
    try{
      result = await FilePicker.platform.pickFiles();
    } catch(e){
      String message =
          "Error while retrieving the backup file.\nPlease try again.";
      dialogClose(globalScaffoldKey.scaffoldKey.currentContext!, message);
      return;
    }


    if (result == null) {
      String message = "$noBackupSelected\n$restoreAborted";
      dialogClose(globalScaffoldKey.scaffoldKey.currentContext!, message);
    } else {
      isCommunicating.isCommunicatingWithGoogleDrive(true);
      dynamic pickedFilePath = result.files.single.path;
      final zipFile =
          await File(pickedFilePath).copy('${appDir.path}/tempFile.zip');

      // Read the Zip file from disk.
      final bytes = zipFile.readAsBytesSync();
      // Decode the Zip file
      final archive = ZipDecoder().decodeBytes(bytes);

      // check if all files in archive are 'hive' files:
      bool isValidFile = false;
      for (final file in archive) {
        final filename = file.name;
        if (extension(filename) == ".m3u") {
          isValidFile = true;
          break;
        }
      }

      //will be called only if all files in archive are 'm3u' files:
      extractFiles() async {
        // Create the folder (empty for new files)
        String tempDirName = "tempDirMAP";
        String pathExtTempDirName = "${appDir.path}/$tempDirName";
        Directory extTempDir = Directory(pathExtTempDirName);
        await extTempDir.create(recursive: true);

        // Extract the contents of the Zip archive to user data folder.
        String filename = "";
        for (final file in archive) {
          filename = file.name;
          if (file.isFile) {
            final data = file.content as List<int>;
            File('${playlistsDir.path}/$filename')
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
            //..copy('${appDocDir.path}/$filename');
          }
        }

        /// Update playlist menue
        final playlistsBloc = BlocProvider.of<PlaylistsBloc>(
            globalScaffoldKey.scaffoldKey.currentContext!);
        playlistsBloc
            .add(PlaylistsLoadingEvent(tracks: GlobalLists().initialTracks));

        //Delete the created temp dir and file in it since we don't need them anymore
        extTempDir.delete(recursive: true);
        await zipFile.delete();
      }

      if (isValidFile) {
        String message =
            "Your playlists from the backup file have been restored.";
        extractFiles().whenComplete(() {
          isCommunicating.isCommunicatingWithGoogleDrive(false);
          dialogClose(globalScaffoldKey.scaffoldKey.currentContext!, message);
        });
      } else {
        zipFile.delete();
        isCommunicating.isCommunicatingWithGoogleDrive(false);
        dialogClose(globalScaffoldKey.scaffoldKey.currentContext!, noValidFiles);
      }
    }
  }
}
