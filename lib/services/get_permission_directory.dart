import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionAndDirectory{
  // Pfad zur gewünschten device library (/Music)
  late String path;
  late bool isGranted = false;

  //PermissionAndDirectory();
  // Selbsterklärend: Permissions für den root directory
  // Unterschied dabei, ob sdk < 33, da ab sdk 33 nur noch einzelne permission abgefragt werden können.
  Future<void> getStoragePermission() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
      if (await Permission.storage.request().isGranted) {
        // OK: get directory
        //Scaffold will call getPublicMusicDirectoryPath();
        isGranted = true;
      } else if (await Permission.storage.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.audio.request().isDenied) {
        // ....
      }
    } else {
      if (await Permission.audio.request().isGranted) {
        isGranted = true;
      } else if (await Permission.audio.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.audio.request().isDenied) {
        // ...
      }
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
