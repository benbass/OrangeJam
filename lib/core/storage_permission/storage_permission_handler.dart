import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../application/playlists/playlists_bloc.dart';
import '../../generated/l10n.dart';
import '../../injection.dart';
import '../../presentation/homepage/custom_widgets/custom_widgets.dart';
import '../globals.dart';

class StoragePermissionHandler {
  final BuildContext context;

  const StoragePermissionHandler({
    required this.context,
  });

  /// Checks if storage/audio permission is permanently denied.
  /// If so, dialog is called so user can open app settings
  Future<bool> callDialogForStoragePermission() async {
    late bool isPermanentlyDenied;
    if (await mediaStorePlugin.getPlatformSDKInt() < 33) {
      isPermanentlyDenied = await Permission.storage.isPermanentlyDenied;
    } else {
      isPermanentlyDenied = await Permission.audio.isPermanentlyDenied;
    }
    if (isPermanentlyDenied) {
      if (context.mounted) {
        //permissionDialog(context);
        bool sdkAtLeast33 = await mediaStorePlugin.getPlatformSDKInt() < 33;
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => CustomDialog(
              content: Text(!sdkAtLeast33
                  ? S.of(context).storage_permissions_dialog_content_33
                  : S.of(context).storage_permissions_dialog_content),
              actions: [
                SimpleButton(
                  btnText: S.of(context).buttonCancel,
                  function: () {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                SimpleButton(
                  btnText: S.of(context).buttonOk,
                  function: () {
                    openAppSettings().then((value) {
                      if (value == true && context.mounted) {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                ),
              ],
              showDropdown: false,
              titleWidget: DescriptionText(
                description: S.of(context).storage_permissions_dialog_description,
              ),
            ),
          );
        }
      }
    }
    return isPermanentlyDenied;
  }

  /// Checks audio/storage permission on app resume in case user updated permission
  /// If so, we can scan device and refresh UI
  void checkStoragePermissionOnResumed() async {
    late bool granted;
    if (await mediaStorePlugin.getPlatformSDKInt() < 33) {
      granted = await Permission.storage.isGranted;
    } else {
      granted = await Permission.audio.isGranted;
    }
    // We scan device only if track list is empty. Doing so, we prevent a scan at each resume
    // An empty list can indicate that permission was never granted
    if (granted && sl<GlobalLists>().initialTracks.isEmpty) {
      if (context.mounted) {
        BlocProvider.of<PlaylistsBloc>(context)
            .add(PlaylistsTracksLoadingEvent());
      }
    }
  }
}
