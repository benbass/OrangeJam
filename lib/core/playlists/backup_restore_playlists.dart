import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as sign_in;
import 'package:file_picker/file_picker.dart';

import '../../application/listview/ui/is_comm_with_google_cubit.dart';
import '../../application/playlists/playlists_bloc.dart';
import '../../generated/l10n.dart';
import '../../presentation/homepage/dialogs/dialogs.dart';
import '../../services/google_auth_client.dart';
import '../globals.dart';

// extension requires import dart:io
extension FileExtention on FileSystemEntity {
  dynamic get extractFileNameFromPath {
    return path.split("/").last;
  }

  dynamic get extractFileNameFromPathWin {
    return path.split(Platform.pathSeparator).last;
  }
}

/// TODO: optionally use a file picker for saving the backup file to device storage
class BackupRestorePlaylists {

  /// BACKUP
  void backupFiles() async {
    final isCommunicating = BlocProvider.of<IsCommWithGoogleCubit>(
        globalScaffoldKey.scaffoldKey.currentContext!);
    var encoder = ZipFileEncoder();
    String messageNotSignedIn =
        S.of(globalScaffoldKey.scaffoldKey.currentContext!).backupRestore_youAreNotSignedInToYourGoogleAccount;
    String theFile = S.of(globalScaffoldKey.scaffoldKey.currentContext!).backupRestore_theFile;
    String hasBeenUploaded =
        S.of(globalScaffoldKey.scaffoldKey.currentContext!).backupRestore_hasBeenUploadedToYourGoogleDrive;
    String error = S.of(globalScaffoldKey.scaffoldKey.currentContext!).backupRestore_error;
    String backupNotCreated =
        S.of(globalScaffoldKey.scaffoldKey.currentContext!).backupRestore_backupFileNotCreated;
    String pleaseTryAgain =
        S.of(globalScaffoldKey.scaffoldKey.currentContext!).backupRestore_pleaseTryAgain;
    String successCreated =
        S.of(globalScaffoldKey.scaffoldKey.currentContext!).backupRestore_wasSuccessfullyCreatedIn;

    dynamic dir;

    // Folder in app storage with playlist m3u files
    String folderName = "$appName user data";

    // temp folder where zip file will stored. Will be deleted after backup is completed.
    String backupFolder = "$appName backup dir";

    // Date as string for backup file name
    final now = DateTime.now();
    final convertedDateTime =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final dateTimeForReuse = convertedDateTime;

    // List of m3u files where files from user data folder will be stored
    List<File> files = [];

    if (Platform.isAndroid) {
      // create the temp backup folder
      dir = await getTemporaryDirectory();
      final backupPath = dir.path + '/' + backupFolder;
      // Create the folder if it doesn't exist
      if (!await Directory(backupPath).exists()) {
        await Directory(backupPath).create(recursive: true);
      }
      // get the app folder where m3u files are stored
      dynamic appDir = await getApplicationDocumentsDirectory();
      var userData = Directory('${appDir.path}/${appName}_Playlists');

      try {
        // fill the list 'files' with the detected m3u files in user data folder
        var dirList = userData.list();
        await for (final FileSystemEntity f in dirList) {
          if (f is File && f.path.endsWith('.m3u')) {
            files.add(File(f.path));
          } /*else if (f is Directory) {
            print('Found dir ${f.path}');
          }*/
        }
        // copy files form list to temp backup folder
        for (var element in files) {
          String fileName = element.extractFileNameFromPath;
          await element.copy('$backupPath/$fileName');
        }

        // encode temp backup folder to zip and save zip file to device temp directory
        // the zip file will be deleted after upload is completed
        encoder.zipDirectory(Directory(backupPath),
            filename:
                '${dir.path}/${appName}_Playlists_$dateTimeForReuse.zip');

        // SCHRITTE BEI GOOGLE:
        // Zuerst unter https://console.cloud.google.com/ Projekt erstellen.
        // Dann Google Drive Api aktivieren
        // Anmeldedaten erstellen (OAuth) für Android app. SHA1 key unbedingt!!!! hier mit " ./gradlew signingReport " (zuerst ins Verz. android wechseln!)
        // Wenn später die Anmeldung beim Testen fehlschlägt, dann ist der key wahrscheinlich falsch (falsch erstellt!)
        // Unter OAuth-Zustimmungsbildschirm muss die App Test sein, Usertyp: extern,
        // dann nach "Bearbeiten" einfach Speichern und Fortfahren um zu den Scopes zu gelangen.
        // Dort Google Drive API auswählen und speichern.
        // Dann die email des test users eingeben
        /// !!! WICHTIG: Beim Release zu https://play.google.com/ -> App-Signatur gehen und dort oben unter "Zertifikat für den App-Signaturschlüssel"
        /// den SHA-1 Zertifikats kopieren und dann in https://console.cloud.google.com/ -> Client-ID für Android den Schlüssel durch Einfügen ersetzen!!!!
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
            // UI will display the progress indicator
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
              // save file to Google drive folder we just created
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
                  S.of(globalScaffoldKey.scaffoldKey.currentContext!).backupRestore_unableToUpload + e.toString());
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
        S.of(globalScaffoldKey.scaffoldKey.currentContext!).backupRestore_noBackupFileSelected; //AppLocalizations.of(context)!.noFileSelected;
    String restoreAborted =
        S.of(globalScaffoldKey.scaffoldKey.currentContext!).backupRestore_restoreAborted; //AppLocalizations.of(context)!.restoreAborted;
    //String pleaseRestartApp = "Please restart the app for the changes to take effect!"; //AppLocalizations.of(context)!.pleaseRestartApp;
    String noValidFiles =
        S.of(globalScaffoldKey.scaffoldKey.currentContext!).backupRestore_theZipFileDoesNotContainValidPlaylistFilesExtension; //AppLocalizations.of(context)!.noValidFiles;

    late FilePickerResult? result;
    try{
      result = await FilePicker.platform.pickFiles();
    } catch(e){
      String message =
          S.of(globalScaffoldKey.scaffoldKey.currentContext!).backupRestore_errorWhileRetrievingTheBackupFilenpleaseTryAgain;
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
            S.of(globalScaffoldKey.scaffoldKey.currentContext!).backupRestore_yourPlaylistsFromTheBackupFileHaveBeenRestored;
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
