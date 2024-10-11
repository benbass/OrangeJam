import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/globals.dart';
import '../generated/l10n.dart';
import '../presentation/homepage/custom_widgets/custom_widgets.dart';

// From API 33, we request photos, audio, videos permission to read these files. This the new way
// From API 29, we request storage permission only to read access all files
// API lower than 30, we request storage permission to read & write access access all files
// For writing purpose, we are using [MediaStore] plugin. It will use MediaStore or java File based on API level.
// It will use MediaStore for writing files from API level 30 or use java File lower than 30

class PermissionsAndDirectory {
  late String path;
  late bool isGranted = false;
  List<Permission> permissions = [];
  late bool sdkAtLeast33;
  final themeData = Theme.of(globalScaffoldKey.scaffoldKey.currentContext!);

  void permissionDialog() {
    showDialog(
      context: globalScaffoldKey.scaffoldKey.currentContext!,
      builder: (context) => CustomDialog(
        content:
            Text(sdkAtLeast33 ? S.of(context).storage_permissions_dialog_content_33 : S.of(context).storage_permissions_dialog_content),
        actions: [
          SimpleButton(
            themeData: themeData,
            btnText: S.of(context).buttonOk,
            function: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
          ),
        ],
        showDropdown: false,
        titleWidget: DescriptionText(
          themeData: themeData,
          description: S.of(context).storage_permissions_dialog_description,
        ),
        themeData: themeData,
      ),
    );
  }

  Future<bool> _checkPermissions(List<Permission> permissions) async {
    for (Permission permission in permissions) {
      if (await permission.request().isPermanentlyDenied) {
        permissionDialog();
        return false;
      } else if (await permission.request().isDenied) {
        return false;
      } else if (!await permission.isGranted) {
        permissionDialog();
        return false;
      }
    }
    return true;
  }

  // audiofiles_datasources.dart calls this function before getting music folder
  Future<void> getStoragePermission() async {
    if (await mediaStorePlugin.getPlatformSDKInt() < 33) {
      sdkAtLeast33 = false;
      permissions.add(Permission.storage);
      isGranted = await _checkPermissions(permissions);
      // isGranted == true:
      // audiofiles_datasources.dart will call getPublicMusicDirectoryPath();
    } else {
      sdkAtLeast33 = true;
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
