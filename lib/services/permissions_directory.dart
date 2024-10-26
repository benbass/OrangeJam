import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/globals.dart';

// From API 33, we request photos, audio, videos permission to read these files. This the new way
// From API 29, we request storage permission only to read access all files
// API lower than 30, we request storage permission to read & write access access all files
// For writing purpose, we are using [MediaStore] plugin. It will use MediaStore or java File based on API level.
// It will use MediaStore for writing files from API level 30 or use java File lower than 30

class PermissionsAndDirectory {
  late String path;
  late bool isGranted = false;
  List<Permission> permissions = [];

  Future<bool> _checkPermissions(List<Permission> permissions) async {
    for (Permission permission in permissions) {
      if (await permission.request().isPermanentlyDenied) {
        return false;
      } else if (await permission.request().isDenied) {
        return false;
      } else if (!await permission.isGranted) {
        return false;
      }
    }
    return true;
  }

  // audiofiles_datasources.dart calls this function before getting music folder
  Future<void> getStoragePermission() async {
    if (await mediaStorePlugin.getPlatformSDKInt() < 33) {
      permissions.add(Permission.storage);
      isGranted = await _checkPermissions(permissions);
      // isGranted == true:
      // audiofiles_datasources.dart will call getPublicMusicDirectoryPath();
    } else {
      permissions.add(Permission.audio);
      // permissions.add(Permission.photos); // NOT NEEDED
      // permissions.add(Permission.videos); // NOT NEEDED
      isGranted = await _checkPermissions(permissions);
    }
  }

  // Get path of music library folder
  Future<String> getPublicMusicDirectoryPath() async {
    path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_MUSIC);

    // path = /storage/emulated/0/Music
    return path;
  }
}
