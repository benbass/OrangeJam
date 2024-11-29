import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as sign_in;
import 'package:file_picker/file_picker.dart';

import '../../application/listview/ui/is_comm_with_google_cubit.dart';
import '../../generated/l10n.dart';
import '../../presentation/homepage/dialogs/dialogs.dart';
import '../../services/google_auth_client.dart';
import '../globals.dart';

// ANLEITUNG:
// Zuerst unter https://console.cloud.google.com/ Projekt erstellen.
// Dann Google Drive Api aktivieren
// Anmeldedaten erstellen (OAuth) für Android app. SHA1 key unbedingt!!!! hier mit " ./gradlew signingReport " (zuerst ins Verz. android wechseln!)
// Wenn später die Anmeldung beim Testen fehlschlägt, dann ist der key wahrscheinlich falsch (falsch erstellt!)
// Unter OAuth-Zustimmungsbildschirm muss die App Test sein, Usertyp: extern, (Wenn die App veröffenltlicht ist, aud Production wechseln)
// dann nach "Bearbeiten" einfach Speichern und Fortfahren um zu den Scopes zu gelangen.
// Dort Google Drive API auswählen und speichern.
// Dann die email des test users eingeben
/// !!! WICHTIG: Beim Release zu https://play.google.com/ -> App-Signatur gehen und dort oben unter "Zertifikat für den App-Signaturschlüssel"
/// den SHA-1 Zertifikats kopieren und dann in https://console.cloud.google.com/ -> Client-ID für Android den Schlüssel durch Einfügen ersetzen!!!!

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
Future<void> backupM3uFiles(BuildContext context) async {
  var encoder = ZipFileEncoder();
  final isCommunicating = context.read<IsCommWithGoogleCubit>();
  final s = S.of(context);

  // Define common strings
  const backupFolder = '$appName backup dir';
  final dateTimeForReuse = _getFormattedDateTime();

  // Get platform-specific directory
  final tempDir = await getTemporaryDirectory();

  // Create backup path and folder
  final backupPath = p.join(tempDir.path, backupFolder);
  await Directory(backupPath).create(recursive: true);

  // Get app data directory
  final appDataDir = Directory(p.join((await getApplicationDocumentsDirectory()).path,
          '${appName}_Playlists'));

  try {
    // Get list of m3u files
    final files = await _getPlaylistFiles(appDataDir);

    // Copy files to backup folder
    await _copyFilesToBackupFolder(files, backupPath);

    // Create zip file
    final zipFilePath =
        p.join(tempDir.path, '${appName}_Playlists_$dateTimeForReuse.zip');

    encoder.zipDirectory(Directory(backupPath), filename: zipFilePath);

    if (Platform.isAndroid) {
      if (context.mounted) {
        await _uploadToGoogleDrive(
                context, tempDir, isCommunicating, zipFilePath, s, dateTimeForReuse)
            .whenComplete(() => deleteZipFile(zipFilePath))
            .whenComplete(() => Directory(backupPath).delete(recursive: true))
            .whenComplete(() {
          isCommunicating.isCommunicatingWithGoogleDrive(false);
        });
      }
    } else {
      if (context.mounted) {
        await _handleLocalBackup(context, s, zipFilePath, backupPath);
      }
    }
  } catch (e) {
    final message =
        "${s.backupRestore_error}: $e.\n${s.backupRestore_backupFileNotCreated}\n${s.backupRestore_pleaseTryAgain}";
    if (context.mounted) {
      dialogClose(context, message);
    }
  }
}

// Helper functions:

String _getFormattedDateTime() {
  final now = DateTime.now();
  return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
}

Future<List<File>> _getPlaylistFiles(Directory directory) async {
  final files = <File>[];
  await for (final entity in directory.list()) {
    if (entity is File && entity.path.endsWith('.m3u')) {
      files.add(entity);
    }
  }
  return files;
}

Future<void> _copyFilesToBackupFolder(
    List<File> files, String backupPath) async {
  for (final file in files) {
    final fileName = file.extractFileNameFromPath;
    await file.copy(p.join(backupPath, fileName));
  }
}

deleteZipFile(String filePath) async {
  return await File(filePath).delete();
}

Future<void> _uploadToGoogleDrive(
    BuildContext context,
    Directory dir,
    IsCommWithGoogleCubit isCommunicating,
    String zipFilePath,
    S s,
    String dateTimeForReuse) async {
  isCommunicating.isCommunicatingWithGoogleDrive(true);

  final googleSignIn =
      sign_in.GoogleSignIn.standard(scopes: [drive.DriveApi.driveFileScope]);
  final account = await googleSignIn.signIn();

  if (account == null) {
    if (context.mounted) {
      dialogClose(
          context, s.backupRestore_youAreNotSignedInToYourGoogleAccount);
    }
    return;
  }

  final authHeaders = await account.authHeaders;
  final authenticateClient = GoogleAuthClient(authHeaders);
  final driveApi = drive.DriveApi(authenticateClient);

  try {
    final folderId = await _getOrCreateFolder(driveApi, '$appName Playlists');
    final fileName = '${appName}_Playlists_$dateTimeForReuse.zip';
    final file = File(zipFilePath);

    // create file info for Google Drive and upload
    await _uploadFile(
      driveApi,
      folderId,
      fileName,
      file,
    );

    if (context.mounted) {
      dialogClose(context,
          "${s.backupRestore_theFile} '$fileName' ${s.backupRestore_hasBeenUploadedToYourGoogleDrive}");
    }
  } catch (e) {
    if (context.mounted) {
      dialogClose(context, "${s.backupRestore_unableToUpload} ${e.toString()}");
    }
    // Handle exception, e.g., log it or show a more specific error message
  } finally {
    isCommunicating.isCommunicatingWithGoogleDrive(false);
  }
}

Future<String> _getOrCreateFolder(
    drive.DriveApi driveApi, String folderName) async {
  final query =
      "mimeType='application/vnd.google-apps.folder' and name='$folderName'";
  final folders = await driveApi.files.list(q: query);

  if (folders.files!.isNotEmpty) {
    return folders.files!.first.id!;
  } else {
    final folderMetadata = drive.File()
      ..name = folderName
      ..mimeType = 'application/vnd.google-apps.folder';
    final folder = await driveApi.files.create(folderMetadata);
    return folder.id!;
  }
}

Future<void> _uploadFile(
  drive.DriveApi driveApi,
  String folderId,
  String fileName,
  File file,
) async {
  final fileMetadata = drive.File()
    ..name = fileName
    ..parents = [folderId];

  await driveApi.files.create(
    fileMetadata,
    uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
  );
}

Future<void> _handleLocalBackup(
    BuildContext context, S s, String zipFilePath, String backupPath) async {
  String? outputFile = await FilePicker.platform
      .saveFile(
        dialogTitle: "Please select the location for your backup",
        fileName: p.basename(zipFilePath),
        allowedExtensions: ["zip"],
        bytes: File(zipFilePath).readAsBytesSync(),
      )
      .whenComplete(() => deleteZipFile(zipFilePath))
      .whenComplete(() => Directory(backupPath).delete(recursive: true))
      .whenComplete(() => context.mounted
          ? dialogClose(context,
              "${s.backupRestore_theFile}${s.backupRestore_hasBeenSaved}")
          : {});

  if (outputFile == null) {
    if (context.mounted) {
      dialogClose(context, s.backupRestore_backupAborted);
    }
  }
}
