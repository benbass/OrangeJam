import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

import '../../application/listview/ui/is_comm_with_google_cubit.dart';
import '../../application/playlists/playlists_bloc.dart';
import '../../generated/l10n.dart';
import '../../presentation/homepage/dialogs/dialogs.dart';
import '../globals.dart';

/// RESTORE
Future<void> restoreM3uFiles(BuildContext context) async {
  final isCommunicating = context.read<IsCommWithGoogleCubit>();
  final s = S.of(context);

  // Show loading indicator
  isCommunicating.isCommunicatingWithGoogleDrive(true);

  try {
    // Pick backup file
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      if (context.mounted) {
        _showRestoreAbortedDialog(context, s);
      }
      return;
    }

    final pickedFilePath = result.files.single.path!;
    final zipFile = await File(pickedFilePath).copy(
        '${(await getApplicationDocumentsDirectory()).path}/tempFile.zip');

    // Extract files from zip archive
    if (context.mounted) {
      await _extractFilesFromZip(zipFile, context, s);
    }

    // Update playlist view
    if (context.mounted) {
      context.read<PlaylistsBloc>().add(PlaylistsTracksLoadingEvent());
      dialogClose(context,
          s.backupRestore_yourPlaylistsFromTheBackupFileHaveBeenRestored);
    }
  } catch (e) {
    // Handle errors
    if (context.mounted) {
      _handleError(context, s, e);
    }
  } finally {
    // Hide loading indicator
    isCommunicating.isCommunicatingWithGoogleDrive(false);
  }
}

Future<void> _extractFilesFromZip(
    File zipFile, BuildContext context, S s) async {
  final bytes = zipFile.readAsBytesSync();
  final archive = ZipDecoder().decodeBytes(bytes);

  // Validate file extensions
  if (!archive.every((file) => extension(file.name) == '.m3u')) {
    await zipFile.delete();
    if (context.mounted) {
      _showInvalidFileDialog(context, s);
    }
    return;
  }

  // Extract files to playlists directory
  final playlistsDir = Directory(
      '${(await getApplicationDocumentsDirectory()).path}/${appName}_Playlists');
  for (final file in archive) {
    if (file.isFile) {
      final data = file.content as List<int>;
      File('${playlistsDir.path}/${file.name}')
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
    }
  }

  // Delete temporary zip file
  await zipFile.delete();
}

void _showRestoreAbortedDialog(BuildContext context, S s) {
  if (context.mounted) {
    dialogClose(context,
        "${s.backupRestore_noBackupFileSelected}\n${s.backupRestore_restoreAborted}");
  }
}

void _showInvalidFileDialog(BuildContext context, S s) {
  if (context.mounted) {
    dialogClose(context,
        s.backupRestore_theZipFileDoesNotContainValidPlaylistFilesExtension);
  }
}

void _handleError(BuildContext context, S s, Object error) {
  if (context.mounted) {
    dialogClose(context,
        "${s.backupRestore_errorWhileRetrievingTheBackupFilenpleaseTryAgain}: $error");
  }
}
